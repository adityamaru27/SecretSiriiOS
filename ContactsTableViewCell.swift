//
//  ContactsTableViewCell.swift
//  SecretSiri
//
//  Created by Aditya Maru on 2016-10-14.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    public func Create(name: String) -> ContactsTableViewCell
    {
        let cell = ContactsTableViewCell();
        cell.displayLabel.text = name;
        return cell;
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
