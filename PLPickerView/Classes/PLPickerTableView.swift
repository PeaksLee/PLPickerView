//
//  PLPickerTableView.swift
//  PLPickerView
//
//  Created by za on 2020/10/28.
//

import UIKit

class PLPickerTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        textLabel?.frame = contentView.bounds
    }
}

class PLPickerTableView: UITableView {
    
    var pickerSelectRow: Int = 0
    
    func pickerSelectRow(_ pickerSelectRow: Int, rowHeight: CGFloat, animated: Bool) -> Void {
        selectRow(at: IndexPath(row: pickerSelectRow, section: 0), animated: animated, scrollPosition: .middle)
        self.pickerSelectRow(pickerSelectRow, vibrate: false)
    }
    
    func pickerSelectRow(_ pickerSelectRow: Int, vibrate: Bool) -> Void {
        
        if self.pickerSelectRow != pickerSelectRow {
            print(pickerSelectRow)
            self.pickerSelectRow = pickerSelectRow
            if vibrate {
                if #available(iOS 10.0, *) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
    }
    
}
