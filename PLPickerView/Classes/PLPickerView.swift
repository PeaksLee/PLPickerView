//
//  PLPickerView.swift
//  PLPickerView
//
//  Created by za on 2020/10/28.
//

import UIKit

public class PLPickerView: UIView, UITableViewDelegate, UITableViewDataSource{

    weak public var _dataSource: PLPickerViewDataSource?
    weak public var dataSource: PLPickerViewDataSource? {
        get { return _dataSource }
        set {
            _dataSource = newValue
            if newValue != nil  {
                setupUI()
            } else {
                for obj in subviews {
                    obj.removeFromSuperview()
                }
                componentViews.removeAll()
            }
        }
    }
    
    weak public var _delegate: PLPickerViewDelegate?
    weak public var delegate: PLPickerViewDelegate? {
        get { return _delegate }
        set {
            _delegate = newValue
            if let _ = newValue?.pickerView?(self, rowHeightForComponent: 0) {
                setNeedsLayout()
            }
        }
    }
    
    private(set) public var numberOfComponents: Int = 0
    
    private var componentViews: [PLPickerTableView] = []
    private var topGradientLayer: CAGradientLayer?
    private var topLine: CALayer?
    private var bottomGradientLayer: CAGradientLayer?
    private var bottomLine: CALayer?
    
    public func numberOfRows(inComponent component: Int) -> Int {
        let tableView = componentViews[component]
        return tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0) ?? 0
    }

    public func rowSize(forComponent component: Int) -> CGSize {
        return CGSize(width: componentViews[component].bounds.size.width, height: rowHeight(component: component))
    }
    
    public func view(forRow row: Int, forComponent component: Int) -> UIView? {
        let cell = componentViews[component].cellForRow(at: IndexPath(row: row, section: 0))
        if cell != nil && cell?.contentView.subviews.count ?? 0 > 0 {
            return cell?.contentView.subviews.first
        }
        return nil
    }

    public func reloadAllComponents() {
        
        numberOfComponents = self.dataSource?.numberOfComponents(in: self) ?? 0
        
        if numberOfComponents != componentViews.count {
            for obj in componentViews { obj.removeFromSuperview() }
            componentViews.removeAll()
            setupComponentsViews()
            setNeedsLayout()
            
        } else {
            for obj in componentViews { obj.reloadData() }
        }
    }

    public func reloadComponent(_ component: Int) {
        componentViews[component].reloadData()
    }
    
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        DispatchQueue.main.async {
            self.componentViews[component].pickerSelectRow(row, rowHeight: self.rowHeight(component: component), animated: animated)
        }
    }
    
    public func selectedRow(inComponent component: Int) -> Int {
        return componentViews[component].pickerSelectRow
    }
    
    //MARK: 视图相关
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            setupUI()
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            DispatchQueue.main.async {
                for obj in self.componentViews {
                    if obj.pickerSelectRow == 0 {
                        self.rotateCells(obj)
                    }
                }
            }
        }
    }
    
    public override func layoutSubviews() {
        
        if componentViews.count > 0 {
            let width: CGFloat = bounds.size.width/CGFloat(componentViews.count)
            var x: CGFloat = 0
            
            for (index, obj) in componentViews.enumerated() {
                
                let useWidth = self.delegate?.pickerView?(self, widthForComponent: index) ?? width
                obj.frame = CGRect(x: x, y: 0, width: useWidth, height: bounds.size.height)
                x += useWidth
                
                let inset: CGFloat = (bounds.size.height-rowHeight(component: index))/2
                obj.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0)
                obj.setContentOffset(CGPoint(x: 0, y: -inset), animated: false)
            }
        }
        
        if topGradientLayer != nil {
            
            var rowHeight: CGFloat = bounds.size.height/5.0
            for (index, _) in componentViews.enumerated() {
                rowHeight = min(rowHeight, self.delegate?.pickerView?(self, rowHeightForComponent: index) ?? rowHeight)
            }
            let inset: CGFloat = (bounds.size.height-rowHeight)/2
            
            topGradientLayer?.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: inset)
            topLine?.frame = CGRect(x: 0, y: inset, width: bounds.size.width, height: 1/(UIScreen.main.scale))
            
            bottomGradientLayer?.frame = CGRect(x: 0, y: inset+rowHeight, width: bounds.size.width, height: inset)
            bottomLine?.frame = CGRect(x: 0, y: inset+rowHeight, width: bounds.size.width, height: 1/(UIScreen.main.scale))
        }
    }
        
    
    func setupUI() {
        
        setupComponentsViews()
        
        if topGradientLayer == nil {
            
            topGradientLayer = createGradientLayer(position: true)
            layer.addSublayer(topGradientLayer!)
            
            topLine = createLine()
            layer.addSublayer(topLine!)
            
            bottomGradientLayer = createGradientLayer(position: false)
            layer.addSublayer(bottomGradientLayer!)
            
            bottomLine = createLine()
            layer.addSublayer(bottomLine!)
        }
    }
    
    func setupComponentsViews() {
        
        if let dataSource = self.dataSource {
            
            numberOfComponents = dataSource.numberOfComponents(in: self)
            
            if self.componentViews.count == 0 {
                
                for _ in 0..<numberOfComponents {
                    let tableView: PLPickerTableView = PLPickerTableView(frame: .zero, style: .plain)
                    tableView.separatorStyle = .none
                    tableView.showsVerticalScrollIndicator = false
                    tableView.showsHorizontalScrollIndicator = false
                    tableView.delegate = self
                    tableView.dataSource = self
                    tableView.estimatedRowHeight = 0
                    addSubview(tableView)
                    sendSubview(toBack: tableView)
                    componentViews.append(tableView)
                }
            }
        }
    }
    
    func createGradientLayer(position isTop: Bool) -> CAGradientLayer {
        let gl: CAGradientLayer = CAGradientLayer()
        gl.colors = [UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4).cgColor, UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95).cgColor]
        gl.startPoint = isTop ? CGPoint(x: 0.51, y: 1) : CGPoint(x: 0.52, y: 0)
        gl.endPoint = isTop ? CGPoint(x: 0.52, y: 0) : CGPoint(x: 0.52, y: 1)
        return gl
    }
    
    func createLine() -> CALayer {
        let layer: CALayer = CALayer()
        layer.backgroundColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1).cgColor
        return layer
    }
    
    //MARK: UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.pickerView(self, numberOfRowsInComponent: componentViews.index(of: tableView as! PLPickerTableView) ?? 0) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "PLPickerViewCell") ?? UITableViewCell(style: .default, reuseIdentifier: "PLPickerViewCell")
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        if let delegate = self.delegate {
            
            let component: Int = componentViews.index(of: tableView as! PLPickerTableView)!
                        
            if let view:UIView = delegate.pickerView?(self, viewForRow: indexPath.row, forComponent: component, reusing: cell.contentView.subviews.first) {
                
                view.frame = cell.contentView.bounds
                cell.contentView.addSubview(view)
            } else if let attStr: NSAttributedString = delegate.pickerView?(self, attributedTitleForRow: indexPath.row, forComponent: component) {

                cell.textLabel?.frame = cell.contentView.bounds
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.attributedText = attStr
            } else if let title: String = delegate.pickerView?(self, titleForRow: indexPath.row, forComponent: component) {
                
                cell.textLabel?.frame = cell.contentView.bounds
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor.black
                if #available(iOS 8.2, *) {
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
                }
                cell.textLabel?.text = title
            } else {
                cell.textLabel?.attributedText = nil
                cell.textLabel?.text = nil
            }
        } else {
            for obj in cell.contentView.subviews {
                if !(obj is UILabel) {
                    obj .removeFromSuperview()
                }
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight(component: componentViews.index(of: tableView as! PLPickerTableView) ?? 0)
    }
    
    //MARK: UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let tableView: PLPickerTableView = scrollView as! PLPickerTableView
        let component: Int = componentViews.index(of: tableView)!
        
        if let dataSource = self.dataSource {
            
            if dataSource.pickerView(self, numberOfRowsInComponent: component) > 0 {
                rotateCells(tableView)
                let rowHeight: CGFloat = self.rowHeight(component: component)
                let inset: CGFloat = (bounds.size.height-rowHeight)/2
                let count: Int = dataSource.pickerView(self, numberOfRowsInComponent: component)
                
                if tableView.contentOffset.y < -tableView.contentInset.top {
                    tableView.pickerSelectRow(0, vibrate: false)
                } else if tableView.contentOffset.y > (rowHeight*CGFloat(count-1)-inset) {
                    tableView.pickerSelectRow(count-1, vibrate: false)
                } else {
                    let index: Int = Int(round((tableView.contentOffset.y+tableView.contentInset.top)/rowHeight))
                    tableView.pickerSelectRow(index, vibrate: true)
                }
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(tableView: scrollView as! PLPickerTableView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll(tableView: scrollView as! PLPickerTableView)
        }
    }
    
    func scrollViewDidEndScroll(tableView: PLPickerTableView) -> Void {
        
        let component: Int = componentViews.index(of: tableView)!
        let rowHeight: CGFloat = self.rowHeight(component: component)
        
        for cell in tableView.visibleCells {
            
            let y: CGFloat = cell.frame.midY-tableView.contentOffset.y
            
            if fabs(bounds.size.height/2-y) < rowHeight/2 {
                let contentOffsetY: CGFloat = tableView.contentOffset.y - (bounds.size.height/2-y);
                let index: Int = Int(round((contentOffsetY + tableView.contentInset.top)/rowHeight))
                tableView.pickerSelectRow(index, rowHeight: rowHeight, animated: true)
                delegate?.pickerView?(self, didSelectRow: index, inComponent: component)
            }
        }
        
    }
    
    func rotateCells(_ tableView: PLPickerTableView) -> Void {
        
        for cell in tableView.visibleCells {
            let height: CGFloat = tableView.bounds.size.height/2
            let offset: CGFloat = (height - cell.frame.midY + tableView.contentOffset.y)/height
            var transform: CATransform3D = CATransform3DRotate(CATransform3DIdentity, CGFloat(Double.pi)/3*offset, 1, 0, 0)
            transform = CATransform3DTranslate(transform, 0, 0, -fabs(offset)*20)
            cell.contentView.layer.transform = transform
        }
    }
    
    
    private func rowHeight(component: Int) -> CGFloat {
        return delegate?.pickerView?(self, rowHeightForComponent: component) ?? bounds.size.height/5.0
    }
    
}
