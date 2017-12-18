//
//  RegisterViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/15/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypepasswordTextField: UITextField!
    var help = Helpers()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func registerClicked(_ sender: Any) {
        if(nameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" && retypepasswordTextField.text != "") {
            if(passwordTextField.text == retypepasswordTextField.text){
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
                    user, error in
                    if(error != nil){
                        print(error?.localizedDescription)
                        self.help.showErrorAlert(message: (error?.localizedDescription)!, uivc: self)
                        //self.showErrorAlert(message: (error?.localizedDescription)!)
                    } else {
                        let uid = Auth.auth().currentUser?.uid
                        let databaseRef = Database.database().reference()
                        let userIdentity : [String : Any] = ["fullname" : self.nameTextField.text,
                                                             "email" : self.emailTextField.text,
                                                             "uid" : uid!,
                                                             "displaypict" : "default"]
                        databaseRef.child("Users").child(uid!).setValue(userIdentity)
                        //ALERT
                        let alert = UIAlertController(title: "Successfully Registered", message: "Now you can log in with e-mail and password that has been registered", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler:{(action) -> Void in
                            self.performSegue(withIdentifier: "gotoLogin", sender: self)
                        })
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        //END OF ALERT
                    }
                })
            } else {
                help.showErrorAlert(message: "Your password didnt match. Check and retype again", uivc: self)
                //showErrorAlert(message: "Your password didnt match. Check and retype again")
            }
        } else {
            help.showErrorAlert(message: "Check corresponding data field. Field cannot be emptied", uivc: self)
            //showErrorAlert(message: "Check corresponding data. Box cannot be emptied")
        }
    }
    
    /*func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Please try again!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }*/

    @IBAction func cancelClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoLogin", sender: self)
    }
    
}
