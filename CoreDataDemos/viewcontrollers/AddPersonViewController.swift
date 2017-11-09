//
//  AddPersonViewController.swift
//  CoreDataDemos
//
//  Created by hackeru on 13 Heshvan 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit

class AddPersonViewController: UIViewController {
    
    
    var personToEdit: Person?
    
    @objc  func saveBtn(_ sender: UIButton) {
        let email = emailText.text ?? ""
        //TODO: Show Alert or do better than that!
        
        if email.count < 3 {
            let alert = UIAlertController(title: "Email Not Valid", message: "Must be at least 3 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                print("")
            }))
            present(alert, animated: true)
            return
        }
        
        
        
        if let personToEdit = personToEdit{
            personToEdit.email = email
            if let img = ivPersonImage.image{
                //UIImage -> Data - > NSData
                let data = UIImageJPEGRepresentation(img, 1) as NSData?
                personToEdit.image = data
            }
            //Save Person to Data base
            DBManager.shared.edit(person: personToEdit) //encapsulation - abstraction, oop!
            //shout:
            NotificationCenter.default.post(name: .personEdit, object: nil, userInfo: ["person" : personToEdit])
            navigationController?.popViewController(animated: true)
            
        }else{
            //new Person
            let p = Person(email: email, image: ivPersonImage.image)
            
            //Save Person to Data base
            DBManager.shared.add(person: p) //encapsulation - abstraction, oop!
            
            //shout that we created a new Person:
            
            let userInfoDictionary = ["Person": p]
            NotificationCenter.default.post(name: .personAdded, object: nil, userInfo: userInfoDictionary)
            self.dismiss(animated: true)
        }
        
        
    }
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var ivPersonImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let iv = self.view.viewWithTag(2) as! UIImageView
        //        iv.image = UIImage(named: "paris") //spriteSheet.
        
        ivPersonImage.image = #imageLiteral(resourceName: "paris")
        ivPersonImage.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage(sender:)))
        // Do any additional setup after loading the view.
        ivPersonImage.addGestureRecognizer(tapGesture)
        ivPersonImage.clipsToBounds = true
        
        let btn = view.viewWithTag(R.id.btn) as! UIButton
        
        //  btn.clipsToBounds = true
        //init //present
        btn.addTarget(self, action: #selector(saveBtn(_:)), for: UIControlEvents.touchUpInside)
        
        
        //check if we are editing
        guard let personToEdit = personToEdit else{return}
        
        emailText.text = personToEdit.email
        
        //ivPersonImage.image =
        guard let imgData:NSData = personToEdit.image else {return}
        
        let data = imgData as Data
        ivPersonImage.image = UIImage(data: data)
        
    }
    
    @objc func pickImage(sender: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddPersonViewController :  UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ivPersonImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//custom notification:
extension Notification.Name{
    static let personAdded = Notification.Name(rawValue: "personAdded")
    static let personEdit = Notification.Name(rawValue: "personEdit")
    static let personDeleted = Notification.Name(rawValue: "personDeleted")
}

public class R{
    public class id{
        public static let btn = 4
    }
}
