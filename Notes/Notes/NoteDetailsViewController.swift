//
//  NoteDetailsView.swift
//  Notes
//
//  Created by admin on 1/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class NoteDetailsViewController : UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @objc var note: Note?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.note != nil) {
            let note: Note! = self.note!
            self.navigationItem.title = note.title
            self.categoryLabel.text = note.categoryTitle
            self.createdDateLabel.text = note.readableCreatedDate()
            self.contentTextView.text = note.content
        } else {
            self.navigationItem.title = "Note not found"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  (segue.identifier == "NoteEdit") {
            guard let navController = segue.destination as? UINavigationController else {
                return
            }
            let destination = navController.viewControllers.first as! NoteEditViewController;
            destination.note = note;
        }
    }
}
