//
//  NoteEditViewController.swift
//  Notes
//
//  Created by admin on 1/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class NoteEditViewController : UIViewController {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    var note: Note?
    override func viewDidLoad() {
        super.viewDidLoad()
        let categories = DataManager.shared().getCategories()
        let categoriesTitles = categories.map { (category) -> String in
            return category.title;
        }
        self.categoryTextField.loadDropdownData(data: categoriesTitles)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (note != nil) {
            self.navigationTitle.title = "Edit Note"
            self.titleTextField.text = note!.title
            self.categoryTextField.text = note!.categoryTitle
            self.contentTextView.text = note!.content
        }
        else {
            self.navigationTitle.title = "Add Note"
            self.titleTextField.text = ""
            self.categoryTextField.text = ""
            self.contentTextView.text = ""
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveAction(_ sender: Any) {
        let category = DataManager.shared().getCategoryByTitle(self.categoryTextField.text!)
        if (self.note != nil) {
            self.note?.title = self.titleTextField.text!
            self.note?.categoryTitle = category.title
            self.note?.categoryId = category.identifier
            self.note?.content = self.contentTextView.text
        } else {
            self.note = Note(title: self.titleTextField.text!, content: self.contentTextView.text!, categoryTitle: category.title, andCategoryId: category.identifier)
            DataManager.shared().add(note!)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
