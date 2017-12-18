//
//  ContactsViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/15/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var help = Helpers()
    var contacts:[String] = ["tes"]
    var contactsImage:[String] = ["tes"]
    @IBOutlet weak var contactsTableView: UITableView!
    let dbRef = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadContacts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadContacts()
    }
    
    func reloadContacts(){
        dbRef.child("Friends").observe(DataEventType.childAdded, with: { (snapshot) in
            let dict = snapshot.value as! NSDictionary
            let selfUid:String = (Auth.auth().currentUser?.uid)!
            let friendsuid1 = dict["uid1"] as! String
            let friendsuid2 = dict["uid2"] as! String
            //APPEND TO CONTACTS ARRAY
            if(selfUid == dict["uid1"] as! String){
                self.dbRef.child("Users").child(friendsuid2).observeSingleEvent(of: .value, with:{
                    (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    //print("ini valuenya \(value)")
                    let contactsName = value?["fullname"] as? String ?? "not yet set"
                    let contactImageFromFB = value?["displaypict"] as? String ?? "not yet set"
                    self.contacts.append(contactsName)
                    self.contactsImage.append(contactImageFromFB)
                    //self.contactsTableView.reloadData()
                })
            } else if(selfUid == dict["uid2"] as! String) {
                self.dbRef.child("Users").child(friendsuid1).observeSingleEvent(of: .value, with:{
                    (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    //print("ini valuenya \(value)")
                    let contactsName = value?["fullname"] as? String ?? "not yet set"
                    let contactImageFromFB = value?["displaypict"] as? String ?? "not yet set"
                    self.contacts.append(contactsName)
                    self.contactsImage.append(contactImageFromFB)
                    //self.contactsTableView.reloadData()
                })
            }
            //END OF APPEND TO CONTACTS ARRAY
        })
        contactsTableView.reloadData()
        print(contacts.count)
        print(contactsImage.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addContactsClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoAddContacts", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(contacts.count)
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell") as! ContactsTableViewCell
        let row = indexPath.row
        cell.contactsNameLabel.text = contacts[row]
        help.changeProfilePicture(imagePath: contactsImage[row], pictureImageView: cell.contactsImageView)
        return cell
    }
    

}
