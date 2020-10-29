//
//  PLPickerViewProtocol.swift
//  PLPickerView
//
//  Created by za on 2020/10/28.
//

@objc public protocol PLPickerViewDataSource : NSObjectProtocol {
    
    /// 列数
    /// - Parameter pickerView: pickerView
    func numberOfComponents(in pickerView: PLPickerView) -> Int
    
    
    /// 每列的行数
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - component: 第几列
    func pickerView(_ pickerView: PLPickerView, numberOfRowsInComponent component: Int) -> Int
}


@objc public protocol PLPickerViewDelegate : NSObjectProtocol {
    
    /// 每列的宽度
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - component: 第几列
    @objc optional func pickerView(_ pickerView: PLPickerView, widthForComponent component: Int) -> CGFloat
    
    /// 每列的行高
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - component: 第几列
    @objc optional func pickerView(_ pickerView: PLPickerView, rowHeightForComponent component: Int) -> CGFloat
    
    /// 每行的标题，优先级低
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - row: 第几行
    ///   - component: 第几列
    @objc optional func pickerView(_ pickerView: PLPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    
    /// 每行的富文本，优先级中
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - row: 第几行
    ///   - component: 第几列
    @objc optional func pickerView(_ pickerView: PLPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    
    /// 每行的view，优先级高
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - row: 第几行
    ///   - component: 第几列
    ///   - view: 复用的view，之前创建过的view
    @objc optional func pickerView(_ pickerView: PLPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView?
    
    /// 选择了第几行第几列
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - row: 第几行
    ///   - component: 第几列
    @objc optional func pickerView(_ pickerView: PLPickerView, didSelectRow row: Int, inComponent component: Int)
    
}
