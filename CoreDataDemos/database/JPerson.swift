//
//  JPerson.swift
//  CoreDataDemos
//
//  Created by hackeru on 13 Heshvan 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit

//declarations only

class SPerson {
    var firstName: String
    let id: UUID //universaly unique id
    var image: UIImage?
    
    
    init(firstName: String, uid:UUID = UUID(), image:UIImage? = nil) {
        self.firstName = firstName
        self.id = uid
        self.image = image
    }
//    convenience init(firstName: String) {
//        //call the 2nd init:
//        let uid = UUID()
//        self.init(firstName: firstName, uid: uid)
//    }
//    //TODO: Convencience init
//    convenience init(firstName: String, uid: UUID) {
//       //call the 3rd init: pass nil for the image
//        self.init(firstName: firstName, uid: uid, image: nil)
//    }
//
//    //TODO: Designated init
//    init (firstName: String, uid:UUID, image: UIImage?){
//        self.firstName = firstName
//        self.id = uid
//        self.image = image
//    }
}

let p = SPerson(firstName: "Moe")
let p1 = SPerson(firstName: "Moe2", uid: UUID())
let p2  = SPerson(firstName: "Moe3", image: nil)
let p3  = SPerson(firstName: "Moe3", uid: UUID(),  image: nil)

