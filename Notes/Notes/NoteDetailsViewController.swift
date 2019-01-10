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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @objc var note: Note?
    var mode: Int! = 0;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.note != nil) {
            let note: Note! = self.note!
            self.navigationTitle.title = note.title
            self.categoryLabel.text = note.categoryTitle
            self.createdDateLabel.text = note.readableCreatedDate()
            self.contentTextView.text = note.content
        } else {
            self.navigationTitle.title = "Note not found"
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  (segue.identifier == "NoteEdit") {
            let destination = segue.destination as! NoteEditViewController;
            destination.note = note;
        }
    }
}
