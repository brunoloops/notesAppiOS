//
//  CategoryCollectionViewCell.swift
//  Notes
//
//  Created by admin on 1/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class CategoryCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    class func identifier() -> String! {
        return "categoryCellIdentifier"
    }
    
}
