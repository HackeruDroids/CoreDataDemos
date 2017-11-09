//
//  PersonCollectionViewCell.swift
//  CoreDataDemos
//
//  Created by hackeru on 17 Heshvan 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var editingImage: UIImageView!
    
    var isEditing = false {
        //property observer
        didSet{
            editingImage.isHidden = !isEditing
        }
    }
    override var isSelected: Bool{
        //property observer
        didSet{
            editingImage.image = isSelected ? #imageLiteral(resourceName: "icons8-ok") : #imageLiteral(resourceName: "icons8-circle")
        }
    }
}
