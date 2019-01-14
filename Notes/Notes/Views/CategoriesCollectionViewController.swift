//
//  CategoriesCollectionViewController.swift
//  Notes
//
//  Created by admin on 1/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class CategoriesCollectionViewController : UICollectionViewController {
    var collectionData : [Notes.Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTable()
        collectionData = DataManager.shared().getCategories()
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
        cell.titleLabel.text = category.title
        return cell
    }
    
    @objc func reloadData(_ notification:Notification) {
        self.refreshTable()
    }

    func refreshTable() {
        
    }
}
