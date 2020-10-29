//
//  ViewController.swift
//  PLPickerView
//
//  Created by lifengfeng on 10/28/2020.
//  Copyright (c) 2020 lifengfeng. All rights reserved.
//

import UIKit
import PLPickerView

class ViewController: UIViewController, PLPickerViewDelegate, PLPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pickerView: PLPickerView = PLPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.frame = CGRect(x: 0, y: 150, width: view.bounds.size.width, height: 250)
        view.addSubview(pickerView)
    }

    func numberOfComponents(in pickerView: PLPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: PLPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    
    func pickerView(_ pickerView: PLPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("选中了第\(row)行")
    }
    
    func pickerView(_ pickerView: PLPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "这是第\(row)行"
    }
    
    func pickerView(_ pickerView: PLPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: PLPickerView, widthForComponent component: Int) -> CGFloat {
        return view.bounds.size.width/3 * (component == 0 ? 2 : 1)
    }
    
    func pickerView(_ pickerView: PLPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        return NSAttributedString(string: "这是第\(row)行", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor.green,
            NSAttributedStringKey.paragraphStyle : paragraph
        ])
    }
    
    func pickerView(_ pickerView: PLPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView? {
        
        if component == 0 {
            
            if view != nil {
                for obj in view?.subviews ?? [] {
                    if obj is UILabel {
                        (obj as! UILabel).text = "复用第\(row)行"
                    }
                }
                return view
            } else {
                
                let contentView: UIView = UIView()
                
                let imageView: UIImageView = UIImageView(image: UIImage(named: "schedule_home_create"))
                imageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
                contentView.addSubview(imageView)
                
                let label: UILabel = UILabel(frame: CGRect(x: 45, y: 10, width: 100, height: 30))
                label.textColor = UIColor.red
                label.text = "这是第\(row)行"
                contentView.addSubview(label)
                
                return contentView
            }
        }
        
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

