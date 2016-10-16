//
//  ViewController.swift
//  SecretSiri
//
//  Created by Aditya Maru on 2016-10-12.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {
    var messageRecipients = Set<NSManagedObject>();
    
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("sent")
    }
    
    func sendMessage()
    {
        var messageVC = MFMessageComposeViewController()
        messageVC.body = "SOS"
        
        let delegate = UIApplication.shared.delegate as? AppDelegate;
        
        let context = delegate?.persistentContainer.viewContext;
        
        let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Contacts")
        
        do
        {
            let results = try context?.fetch(fetchRequest);
            for i in results!
            {
               messageRecipients.insert(i);
               messageVC.recipients?.append((i.value(forKey: "number") as? String)!)
                
                
            }
        }
        catch let error as NSError
        {
            print("Fetching error")
        }
    }
    
    
    


}

