//
//  AddContactsViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/15/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddContactsViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var userUid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if(emailTextField.text != ""){
            let dbRef = Database.database().reference()
                dbRef.child("Users").observe(DataEventType.childAdded, with: { (snapshot) in
                    let value = snapshot as! DataSnapshot
                    let dict = value.value as! NSDictionary
                    let userEmail = dict["email"]
                    if(userEmail! as! String == self.emailTextField.text){
                        self.userUid = dict["uid"] as! String
                    }
                })
                //end of cari uid teman
                let uid = Auth.auth().currentUser?.uid
                if(self.userUid != ""){
                    let relatecontact : [String : Any] = ["uid1" : uid,
                                                          "uid2" : self.userUid]
                    //dbRef.child("Friends").child(uid!).childByAutoId().setValue(["uid" : self.userUid])
                    dbRef.child("Friends").childByAutoId().setValue(relatecontact)
                    //ALERT
                    let alert = UIAlertController(title: "Success!", message: "Friends added successfully", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action) -> Void in
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    //END OF ALERT
                }
        }
    }
    
}
