//
//  ContactsTableViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/18/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct User {
    let fullname: String!
    let uid : String!
    let imagePath : String!
}

class ContactsTableViewController: UITableViewController {
    var users = [User]()
    var help = Helpers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myUid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference()
        dbRef.child("Friends").queryOrderedByKey().observe(.childAdded, with:{
            snapshot in
            print(snapshot)
            let friendsuid1 = (snapshot.value as? NSDictionary)?["uid1"] as? String ?? ""
            let friendsuid2 = (snapshot.value as? NSDictionary)?["uid2"] as? String ?? ""
            
            if(myUid == friendsuid1){
                dbRef.child("Users").queryOrderedByKey().observe(.childAdded, with:{
                    snapshot in
                    //print(snapshot)
                    let fullname = (snapshot.value as? NSDictionary)?["fullname"] as? String ?? ""
                    let uid = (snapshot.value as? NSDictionary)?["uid"] as? String ?? ""
                    let imagePath = (snapshot.value as? NSDictionary)?["displaypict"] as? String ?? ""
                    if(friendsuid2 == uid){
                        self.users.append(User(fullname: fullname, uid: uid, imagePath: imagePath))
                        self.tableView.reloadData()
                    }
                })
            } else if (myUid == friendsuid2){
                dbRef.child("Users").queryOrderedByKey().observe(.childAdded, with:{
                    snapshot in
                    //print(snapshot)
                    let fullname = (snapshot.value as? NSDictionary)?["fullname"] as? String ?? ""
                    let uid = (snapshot.value as? NSDictionary)?["uid"] as? String ?? ""
                    let imagePath = (snapshot.value as? NSDictionary)?["displaypict"] as? String ?? ""
                    if(friendsuid1 == uid){
                        self.users.append(User(fullname: fullname, uid: uid, imagePath: imagePath))
                        self.tableView.reloadData()
                    }
                })
            }
        })
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func addClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoAddContacts", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myContactCell", for: indexPath)
        let nameTextField = cell.viewWithTag(2) as! UILabel
        nameTextField.text = users[indexPath.row].fullname
        let gambar = cell.viewWithTag(1) as! UIImageView
        help.changeProfilePicture(imagePath: users[indexPath.row].imagePath, pictureImageView: gambar)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "gotoChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoChat"){
            let dest = segue.destination
            let d = (dest as! ChatViewController)
            let kirimUid = tableView.indexPathForSelectedRow?.row
            d.friendsUid = users[kirimUid!].uid
        }
    }

}
