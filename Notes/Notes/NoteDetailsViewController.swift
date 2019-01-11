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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.note != nil) {
            let note: Note! = self.note!
            self.navigationItem.title = note.title
            self.categoryLabel.text = note.categoryTitle
            self.createdDateLabel.text = note.readableCreatedDate
            self.contentTextView.text = note.content
            NotificationCenter.default.addObserver(self, selector:#selector(self.reloadData(_:)) , name: NSNotification.Name(rawValue: DataManager.updateNoteNotificationName(for: self.note!)), object: nil)
        } else {
            self.navigationItem.title = "Note not found"
        }
    }
    
    @objc func reloadData(_ notification:Notification) {
        self.note = notification.object as? Note
        if (self.note != nil) {
            NotificationCenter.default.removeObserver(self);
            let note: Note! = self.note!
            self.navigationItem.title = note.title
            self.categoryLabel.text = note.categoryTitle
            self.createdDateLabel.text = note.readableCreatedDate
            self.contentTextView.text = note.content
            NotificationCenter.default.addObserver(self, selector:#selector(self.reloadData(_:)) , name: NSNotification.Name(rawValue: DataManager.updateNoteNotificationName(for: self.note!)), object: nil)
        } else {
            self.navigationItem.title = "Note not found"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
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
