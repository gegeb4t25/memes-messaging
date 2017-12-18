//
//  Helpers.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/15/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    let tes:String = "tes"
    
   func showErrorAlert(message: String, uivc: UIViewController){
        let alert = UIAlertController(title: "Please try again!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        alert.addAction(ok)
        uivc.present(alert, animated: true, completion: nil)
    }
    
    func changeProfilePicture(imagePath: String, pictureImageView: UIImageView){
        if(imagePath != "default"){
            guard let url = URL(string: imagePath) else {return}
            URLSession.shared.dataTask(with: url){
                (data, response, error) in
                if(error != nil){
                    print("Error fetching image : ", error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }
                
                DispatchQueue.main.async{
                    pictureImageView.image = UIImage(data: data!)
                }
                }.resume()
        }
    }
}
