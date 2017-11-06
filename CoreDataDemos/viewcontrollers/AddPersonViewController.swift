//
//  AddPersonViewController.swift
//  CoreDataDemos
//
//  Created by hackeru on 13 Heshvan 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit

class AddPersonViewController: UIViewController {
    
    @objc  func saveBtn(_ sender: UIButton) {
        let email = emailText.text ?? ""
        //TODO: Show Alert or do better than that!
        
        let p = Person(email: email, image: ivPersonImage.image)
        DBManager.shared.save(person: p) //encapsulation - abstraction, oop!
        
        //shout that we created a new Person:
        
        let userInfoDictionary = ["Person": p]
        NotificationCenter.default.post(name: .personAdded, object: nil, userInfo: userInfoDictionary)
        
        self.dismiss(animated: true)
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
        
        
        let btn = view.viewWithTag(R.id.btn) as! UIButton
        
        btn.clipsToBounds = true
        //init //present
        btn.addTarget(self, action: #selector(saveBtn(_:)), for: UIControlEvents.touchUpInside)
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
