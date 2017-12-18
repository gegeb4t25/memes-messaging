//
//  ProfileViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/15/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var help = Helpers()
    @IBOutlet weak var emailaddrLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    var labelArr:[String] = ["Display Name : ", "Change Display Picture", "Logout"]
    var isiProfileArr:[String] = []
    var fullNames:String = ""
    var imagePath:String = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference()
        dbRef.child("Users").child(uid!).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            //print(value)
            self.emailaddrLabel.text = value?["email"] as? String ?? "not yet set"
            self.fullNames = value?["fullname"] as? String ?? "not yet set"
            self.imagePath = value?["displaypict"] as? String ?? "default"
            self.isiProfileArr.append(self.fullNames)
            self.isiProfileArr.append("Click here to change current display picture")
            self.isiProfileArr.append("Click here to sign out from application")
            self.profileTableView.reloadData()
        })
        help.changeProfilePicture(imagePath: imagePath, pictureImageView: pictureImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       help.changeProfilePicture(imagePath: imagePath, pictureImageView: pictureImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isiProfileArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
        let row = indexPath.row
        cell?.textLabel?.text = labelArr[row]
        cell?.detailTextLabel?.text = isiProfileArr[row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 2){
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "gotoLogin", sender: self)
            } catch let signOutError as NSError {
                print("Error signing out : %@", signOutError)
                help.showErrorAlert(message: signOutError as! String, uivc: self)
            }
        } else {
           self.performSegue(withIdentifier: "gotoEditProfile", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoEditProfile"){
            let dest = segue.destination
            let d = (dest as! EditProfileViewController)
            let index = profileTableView.indexPathForSelectedRow?.row
            d.selectedIndex = index!
        }
    }
}
