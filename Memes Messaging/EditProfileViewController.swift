//
//  EditProfileViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/17/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var help = Helpers()
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var newDisplayPicture: UIImageView!
    let dbRef = Database.database().reference()
    let storageRef = Storage.storage().reference().child("display-picture")
    var uid = ""
    var emailaddr = ""
    var displaypict = ""
    var fullname = ""
    var selectedIndex:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.isHidden = true
        newDisplayPicture.isHidden = true
        saveButton.isHidden = false
        loadingIndicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(selectedIndex == 0){
            titleLabel.text = "Change Display Name"
            firstTextField.isHidden = false
            firstTextField.placeholder = "Enter your new name"
        } else if(selectedIndex == 1){
            titleLabel.text = "Change Display Picture"
            newDisplayPicture.isHidden = false
            newDisplayPicture.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.tapDetected))
            newDisplayPicture.addGestureRecognizer(singleTap)
        }
        uid = (Auth.auth().currentUser?.uid)!
        emailaddr = (Auth.auth().currentUser?.email)!
        dbRef.child("Users").child(uid).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.fullname = value?["fullname"] as? String ?? "not yet set"
            self.displaypict = value?["displaypict"] as? String ?? "default"
        })
        help.changeProfilePicture(imagePath: displaypict, pictureImageView: newDisplayPicture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden=false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func tapDetected() {
        print("Imageview Clicked")
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        newDisplayPicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveClick(_ sender: Any) {
        saveButton.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        if(selectedIndex == 0){
            let post = ["email" : emailaddr, "fullname" : firstTextField.text ?? "fullname", "uid" : uid, "displaypict" : displaypict] as [String : Any]
            let childUpdates = [ uid : post ]
            dbRef.child("Users").updateChildValues(childUpdates)
            self.performSegue(withIdentifier: "gotoBackProfile", sender: self)
        } else if(selectedIndex == 1){
            let uploadRef = storageRef.child(uid+".png")
            if let uploadData = UIImagePNGRepresentation(self.newDisplayPicture.image!){
                uploadRef.putData(uploadData, metadata: nil, completion:{
                    (metadata, error) in
                    if(error != nil){
                        print(error ?? "error")
                        return
                    }
                    if let profileImgUrl = metadata?.downloadURL()?.absoluteString{
                        let post = ["email" : self.emailaddr, "fullname" : self.fullname, "uid" : self.uid, "displaypict" : profileImgUrl] as [String : Any]
                        let childUpdates = [ self.uid : post ]
                        self.dbRef.child("Users").updateChildValues(childUpdates)
                        self.performSegue(withIdentifier: "gotoBackProfile", sender: self)
                    }
                    print(metadata ?? "no metadata")
                })
            }
        }
    }

}
