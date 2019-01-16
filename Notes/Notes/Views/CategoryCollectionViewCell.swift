//
//  CategoryCollectionViewCell.swift
//  Notes
//
//  Created by admin on 1/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

protocol CategoryCollectionViewCellDelegate: AnyObject{
    func deleteButtonAction(cell:CategoryCollectionViewCell, category:Notes.Category)
    func editButtonAction(cell:CategoryCollectionViewCell, category:Notes.Category)
}

class CategoryCollectionViewCell : UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    private var category: Notes.Category!
    weak var delegate: CategoryCollectionViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CategoryCollectionViewCell.handleSwipeRight))
        swipeRight.direction = .left
        swipeRight.delegate = self
        self.addGestureRecognizer(swipeRight)
    }
    
    func set(category:Notes.Category!) {
        self.category = category
        self.titleLabel.text = category.title
        self.hideButtons()
    }
    
    @objc func handleSwipeRight(swipe: UISwipeGestureRecognizer) {
        if (self.editButton.isHidden) {
            self.editButton.isHidden = false
            self.deleteButton.isHidden = false
        }
        else {
            self.hideButtons()
        }
    }
    
    func hideButtons() {
        self.editButton.isHidden = true
        self.deleteButton.isHidden = true
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        delegate?.editButtonAction(cell: self, category: self.category)
        self.hideButtons()
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        delegate?.deleteButtonAction(cell: self, category: self.category)
        self.hideButtons()
    }
    
    class func identifier() -> String! {
        return "categoryCellIdentifier"
    }
    
}
