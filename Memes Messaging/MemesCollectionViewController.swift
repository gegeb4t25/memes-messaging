//
//  MemesCollectionViewController.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/18/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit

protocol DelegasiSebrang{
    func sendMemes(choosenMemes: UIImageView)
}

class MemesCollectionViewController: UICollectionViewController {
    
    var delegate: DelegasiSebrang! = nil
    var memesCollection = ["doge", "FlipTable", "ForeverAlone", "NoMeGusta", "success", "TrollFace", "YaoMingMeme", "youdontsay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memesCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memesCell", for: indexPath)
        let myImage = cell.viewWithTag(1) as! UIImageView
        let theImage = UIImage(named: memesCollection[indexPath.row])
        myImage.image = theImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theImage = UIImage(named: memesCollection[indexPath.row])
        let imageView = UIImageView(image: theImage)
        delegate.sendMemes(choosenMemes: imageView)
        //self.navigationController?.popToRootViewController(animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
}
