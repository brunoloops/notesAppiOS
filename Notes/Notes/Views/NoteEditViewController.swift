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
        self.categoryTextField.text = categories[0].title
        
        if (note != nil) {
            self.navigationItem.title = "Edit Note"
            self.titleTextField.text = note!.title
            self.categoryTextField.text = note!.categoryTitle
            self.contentTextView.text = note!.content
        }
        else {
            self.navigationItem.title = "Add Note"
            self.titleTextField.text = ""
            self.contentTextView.text = ""
        }
        self.titleTextField.becomeFirstResponder();
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let category = DataManager.shared().getCategoryByTitle(self.categoryTextField.text!)
        if (self.note != nil) {
            self.note!.title = self.titleTextField.text!
            self.note!.categoryTitle = category.title
            self.note!.categoryId = category.identifier
            self.note!.content = self.contentTextView.text
            var error: NSError?
            DataManager.shared().edit(self.note!, withError: &error);
            if (error != nil) {
                let errorAlert = UIAlertController(title: "Error editing note", message: "Note not found", preferredStyle: UIAlertController.Style.alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(errorAlert, animated: true, completion: nil)
            }
        } else {
            self.note = Note(title: self.titleTextField.text!, content: self.contentTextView.text!, categoryTitle: category.title, andCategoryId: category.identifier)
            DataManager.shared().add(note!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
