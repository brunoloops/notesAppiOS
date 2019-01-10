//
//  UITextField+Dropdown.swift
//  Notes
//
//  Created by admin on 1/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func loadDropdownData(data:[String]) {
        self.inputView = PickerView(pickerData: data, dropdownField: self)
    }
}
