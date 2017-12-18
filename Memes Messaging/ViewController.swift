//
//  ViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/15/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var help = Helpers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Auth.auth().addStateDidChangeListener({
            auth, user in
            if(user != nil){
                self.performSegue(withIdentifier: "gotoProfile", sender: self)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginClicked(_ sender: Any) {
        if(emailTextField.text != "" && passwordTextField.text != ""){
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
                user, error in
                if(error != nil){
                    print(error?.localizedDescription)
                    self.help.showErrorAlert(message: (error?.localizedDescription)!, uivc: self)
                } else {
                    self.performSegue(withIdentifier: "gotoProfile", sender: self)
                }
            })
        }
    }

    @IBAction func registerClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoRegister", sender: self)
    }
    
}

