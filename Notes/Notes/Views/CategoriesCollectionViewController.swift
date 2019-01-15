//
//  CategoriesCollectionViewController.swift
//  Notes
//
//  Created by admin on 1/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class CategoriesCollectionViewController : UICollectionViewController, CategoryCollectionViewCellDelegate {
    
    var collectionData : [Notes.Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTable()
        self.collectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier())
        NotificationCenter.default.addObserver(self, selector:#selector(self.reloadData(_:)) , name: NSNotification.Name(rawValue: DataManager.updateCategoriesNotificationName()), object: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as!CategoryCollectionViewCell
        let category = collectionData[indexPath.item]
        cell.set(category: category)
        cell.delegate = self
        return cell
    }
    
    @objc func reloadData(_ notification:Notification) {
        self.refreshTable()
    }

    func refreshTable() {
        self.collectionData = DataManager.shared().getCategories()
        self.collectionView.reloadData()
    }

    @IBAction func addButtonAction(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add category", message: "Insert title of category", preferredStyle: UIAlertController.Style.alert)
        addAlert.addTextField(configurationHandler: nil)
        addAlert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { (action) in
            let title = addAlert.textFields?.first?.text
            let category = Category(title:title!)
            DataManager.shared().add(category)
        }))
        addAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
        
    }
    
    func deleteButtonAction(cell: CategoryCollectionViewCell, category: Notes.Category) {
        let deleteAlert = UIAlertController(title: "Delete \(category.title)", message: "Are you sure you want to delete the category", preferredStyle: UIAlertController.Style.alert)
        deleteAlert.addAction(UIAlertAction(title: "Yes, delete", style: UIAlertAction.Style.destructive, handler: { (action) in
            DataManager.shared().delete(category)
        }))
        deleteAlert.addAction(UIAlertAction(title: "Don't Delete", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func editButtonAction(cell: CategoryCollectionViewCell, category: Notes.Category) {
        let editAlert = UIAlertController(title: "Edit \(category.title)", message: "Change title of category", preferredStyle: UIAlertController.Style.alert)
        editAlert.addTextField(configurationHandler: nil)
        editAlert.textFields?.first?.text = category.title
        editAlert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { (action) in
            category.title = (editAlert.textFields?.first?.text)!
            DataManager.shared().edit(category)
        }))
        editAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(editAlert, animated: true, completion: nil)
    }
}
