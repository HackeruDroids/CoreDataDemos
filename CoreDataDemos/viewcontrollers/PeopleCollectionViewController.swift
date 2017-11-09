//
//  PeopleCollectionViewController.swift
//  CoreDataDemos
//
//  Created by hackeru on 13 Heshvan 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "personCell"

class PeopleCollectionViewController: UICollectionViewController {
    
    //declarations.
    var data: [Person] = []
    
    @objc func personAdded(notification: Notification){
        print("Added")
        
        guard let info = notification.userInfo,
        
        let p = info["Person"] as? Person else{return}
        
        data.append(p)
        let path = IndexPath(item: data.count - 1, section: 0)
        
        collectionView?.insertItems(at: [path])
        
        collectionView?.scrollToItem(at: path, at: .centeredVertically, animated: true)
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        print("Editing: " , editing) //TODO: rid when done
        
        //notify all the items that are displayed:
        collectionView?.visibleCells.forEach({ (cell) in
            if let cell = cell as? PersonCollectionViewCell{
                cell.isEditing = editing
            }
        })
        
        collectionView?.allowsMultipleSelection = editing
    }
    
    
    
    @objc func trash(){

        let indices:[IndexPath] = collectionView?.indexPathsForSelectedItems ?? []
     
        
        indices.map{data[$0.item]}.forEach { (p) in
            //swift does not have delete object
            //index of -> remove(at:)
            if let i = data.index(of: p){
                data.remove(at: i)
                DBManager.shared.context.delete(p)
            }
        }
        DBManager.shared.saveContext()
        
        collectionView?.deleteItems(at: indices)
        
        
        
        
        
        
//        
//        var ints: [Int]  =  indices.map {$0.item}
//        
//       // var peopleToDelete = ints.map { (i) -> Person in
//        //    return data[i]
//       // }
//        
//        var peopleToDelete = ints.map{data[$0]}
//        
//        peopleToDelete.forEach { (p) in
//            if let i = data.index(of: p){
//                data.remove(at: i)
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add the trash item:
        
        //var items = [UIBarButtonItem]()
        //Array<UIBarButtonItem>()
        var items : [UIBarButtonItem] = []
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trash)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
  
        self.setToolbarItems(items, animated: false)
        
        //Add the Edit Button BarButton Item
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(personAdded(notification:)), name: .personAdded, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(personEdit(notification:)), name: .personEdit, object: nil)
        
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        let pad:CGFloat = 20
        let width = (self.view.frame.size.width / 2) - pad
        
        layout.itemSize = CGSize(width: width, height: width)
        //layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //expressions...
        do {
            data = try DBManager.shared.getPeople()
            collectionView?.reloadData()
        } catch let e {
            print(e)
            //TODO: Alerts and more
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPersonTapped))
    }
    
    @objc func personEdit(notification: Notification){
        print("Edit")
        guard let info = notification.userInfo,
        let person = info["person"] as? Person
        else {return}
  
        for (idx, p) in data.enumerated(){
            if p == person {
                let indexPath = IndexPath(item: idx, section: 0)
                collectionView?.reloadItems(at: [indexPath])
                break
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("")
    }
    //
    
    @objc func addPersonTapped(){
        print("Add Person Tapped")
        guard let addPersonVC = storyboard?.instantiateViewController(withIdentifier: "AddPersonViewController") else{return}
        
        //present modally:
        present(addPersonVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PersonCollectionViewCell
        
        // Configure the cell
        cell.isEditing = self.isEditing
        let p = data[indexPath.item]
        
        cell.emailLabel.text = p.email
        
        if let data = p.image{
            let d = data as Data
            cell.profileImage.image = UIImage(data: d)
        }
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let selectedCount = collectionView.indexPathsForSelectedItems?.count ?? 0
        navigationController?.setToolbarHidden(selectedCount == 0, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            //code...
              self.navigationController?.setToolbarHidden(false, animated: true)
            return
        }
        //1 init the vc
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddPersonViewController") as! AddPersonViewController
        
        
        let p = data[indexPath.item]
        vc.personToEdit = p
        
        //2) push it to the navigation controller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        //quick and dirty (don't use!)
//        super.viewDidAppear(animated)
//        //not efficient
//        data = try! DBManager.shared.getPeople()
//        collectionView?.reloadData()
//    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    
}
