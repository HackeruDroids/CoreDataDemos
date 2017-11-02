//
//  Person+CoreDataClass.swift
import UIKit
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    convenience init(email:String, image: UIImage?) {
        let context = DBManager.shared.context
        let desc = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        
        //call the designated
        self.init(entity: desc, insertInto: context)

        if let image = image{
            self.image =  UIImageJPEGRepresentation(image, 1) as NSData?
        }
        self.email = email
    }
}


//KVO - > add Observer
//NotificationCenter

//init

//        let application = UIApplication.shared
//
//        let appDelegate = application.delegate as! AppDelegate
//
//        let context = appDelegate.persistentContainer.viewContext
