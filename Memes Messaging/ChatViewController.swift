//
//  ChatViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/15/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

struct ChatDetails {
    let uid1:String!
    let uid2:String!
    let imagePath:String!
    let message:String!
    let timeSent:String!
    let pengirim:String!
}

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DelegasiSebrang {
    
    var help = Helpers()
    var friendsUid = ""
    var currentUid = ""
    var theChat = [ChatDetails]()
    let dbRef = Database.database().reference()
    let storageRef = Storage.storage().reference().child("memes-images")
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUid = (Auth.auth().currentUser?.uid)!
        self.chatTableView.allowsMultipleSelectionDuringEditing = false
        //theChat.append(ChatDetails(uid1: "asd", uid2: "asdd", imagePath1: "asd", imagePath2: "zxc", message: "asd", timeSent: "asd"))
        // Do any additional setup after loading the view.
        dbRef.child("Chats").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            print(snapshot)
            let uid1 = (snapshot.value as? NSDictionary)?["uid1"] as? String ?? ""
            let uid2 = (snapshot.value as? NSDictionary)?["uid2"] as? String ?? ""
            let timestamp = (snapshot.value as? NSDictionary)?["timestamp"] as? String ?? ""
            let meesage = (snapshot.value as? NSDictionary)?["message"] as? String ?? ""
            let isGambar = (snapshot.value as? NSDictionary)?["isGambar"] as? String ?? ""
            let sender = (snapshot.value as? NSDictionary)?["sender"] as? String ?? ""
            
            if(self.currentUid == uid1 || self.currentUid == uid2){
                if(self.friendsUid == uid1 || self.friendsUid == uid2){
                    if(isGambar == "true"){
                        self.theChat.append(ChatDetails(uid1: uid1, uid2: uid2, imagePath: meesage, message: "", timeSent: timestamp, pengirim: sender))
                        self.chatTableView.reloadData()
                    } else if(isGambar == "false"){
                        self.theChat.append(ChatDetails(uid1: uid1, uid2: uid2, imagePath: "", message: meesage, timeSent: timestamp, pengirim: sender))
                        self.chatTableView.reloadData()
                    }
                }
            }
        })
        chatTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        chatTableView.reloadData()
    }
    @IBAction func sendClicked(_ sender: Any) {
        if(messageTextField.text != ""){
            let waktuSekarang:String = Date.init().description
            let postingan : [String : Any] = ["uid1" : currentUid,
                                            "uid2" : friendsUid,
                                            "isGambar" : "false",
                                            "message" : messageTextField.text ?? "",
                                            "timestamp" : waktuSekarang,
                                            "sender" : currentUid]
            dbRef.child("Chats").childByAutoId().setValue(postingan)
            chatTableView.reloadData()
        }
        chatTableView.reloadData()
        messageTextField.text = ""
    }
    
    func sendMemes(choosenMemes: UIImageView){
        let uploadRef = storageRef.child("memesnya.jpeg")
        if let uploadData = UIImagePNGRepresentation(choosenMemes.image!){
            uploadRef.putData(uploadData, metadata: nil, completion:{
                (metadata, error) in
                if(error != nil){
                    print(error ?? "error")
                    return
                }
                if let memesImgUrl = metadata?.downloadURL()?.absoluteString{
                    let waktuSekarang:String = Date.init().description
                    let postingan : [String : Any] = ["uid1" : self.currentUid,
                                                      "uid2" : self.friendsUid,
                                                      "isGambar" : "true",
                                                      "message" : memesImgUrl,
                                                      "timestamp" : waktuSekarang,
                                                      "sender" : self.currentUid]
                    self.dbRef.child("Chats").childByAutoId().setValue(postingan)
                    self.chatTableView.reloadData()
                }
                print(metadata ?? "no metadata")
            })
        }
        chatTableView.reloadData()
        messageTextField.text = ""
    }
    
    @IBAction func memesClicked(_ sender: Any) {
        performSegue(withIdentifier: "gotoMemesCollection", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell")
        let row = indexPath.row
        let messageField = cell?.viewWithTag(1) as! UITextView
        let descriptionLabel = cell?.viewWithTag(2) as! UILabel
        let gambarImageView = cell?.viewWithTag(3) as! UIImageView
        if(theChat[row].imagePath == ""){
            messageField.text = theChat[row].message
        } else {
           help.changeProfilePicture(imagePath: theChat[row].imagePath, pictureImageView: gambarImageView)
        }
        if(currentUid == theChat[row].pengirim){
            descriptionLabel.text = "sent by myself on "
            messageField.textAlignment = .right
            cell?.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.66)
        } else {
            descriptionLabel.text = "sent by friends on "
            messageField.textAlignment = .left
            cell?.backgroundColor = UIColor(red: 256/256, green: 255/256, blue: 0/256, alpha: 0.66)
        }
        descriptionLabel.text?.append(theChat[row].timeSent)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            print("delete")
            theChat.remove(at: indexPath.row)
            chatTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoMemesCollection"){
            let dest = segue.destination as! MemesCollectionViewController
            dest.delegate = self
        }
    }

}
