//
//  ViewController.swift
//  SecretSiri
//
//  Created by Aditya Maru on 2016-10-12.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func contactButton(_ sender: AnyObject) {
    }
    var userDefaults = UserDefaults.standard;
    @IBOutlet weak var nameLabel: UITextField!
    var clickedOnce = false;
    let userNameKey = "name"

    @IBAction func nameEdit(_ sender: AnyObject) {
        if(!clickedOnce)
        {
            nameLabel.isUserInteractionEnabled = true;
            nameLabel.becomeFirstResponder();
            clickedOnce = true;
        }
        else
        {
            nameLabel.resignFirstResponder();
            userDefaults.set(nameLabel.text, forKey: userNameKey);
            nameLabel.isUserInteractionEnabled = false;
            clickedOnce = false;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameLabel.resignFirstResponder();
        userDefaults.set(nameLabel.text, forKey: userNameKey);
        clickedOnce = false;
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        AppDelegate.sharedDelegate().checkAccessStatus { (accessGranted) in
            print(accessGranted)
        }
        nameLabel.isUserInteractionEnabled = false;
        if let name = userDefaults.string(forKey: userNameKey)
        {
            nameLabel.text = name;
        }
        self.nameLabel.delegate = self;
        title = "SecretSiri"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}

