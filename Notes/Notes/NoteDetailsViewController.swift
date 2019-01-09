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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
