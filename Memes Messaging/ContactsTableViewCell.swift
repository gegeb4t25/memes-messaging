//
//  ContactsTableViewCell.swift
//  Memes Messaging
//
//  Created by Gregorius on 12/18/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactsNameLabel: UILabel!
    @IBOutlet weak var contactsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
