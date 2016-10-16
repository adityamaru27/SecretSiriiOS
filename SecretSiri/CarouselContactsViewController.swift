//
//  CarouselContactsViewController.swift
//  SecretSiri
//
//  Created by Aditya Maru on 2016-10-13.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import CoreData

class CarouselContactsViewController: UIViewController, iCarouselDelegate, iCarouselDataSource{
    
    public static var topFive: Set<NSManagedObject>!;
    private var longTouch = UILongPressGestureRecognizer(target: self, action: "longPress");
    
    @IBAction func deleteButton(_ sender: AnyObject)
    {
        
        let currentIndex = ContactsCarousel.currentItemIndex;
        let delegate = UIApplication.shared.delegate as? AppDelegate;
        let context = delegate?.persistentContainer.viewContext;
        
        let y = CarouselContactsViewController.topFive.index(CarouselContactsViewController.topFive.startIndex, offsetBy: currentIndex);
        context?.delete(CarouselContactsViewController.topFive[y]);
        CarouselContactsViewController.topFive.remove(at: y);
        ContactsCarousel.reloadData();
        
    }

    @IBAction func contactsSearch(_ sender: AnyObject) {
        
        if(CarouselContactsViewController.topFive == nil)
        {
            CarouselContactsViewController.topFive = Set<NSManagedObject>();
        }
        let searchTable = ContactsSearchTableViewController();
        searchTable.Setup(arr: CarouselContactsViewController.topFive)
//        searchTable.delegate = self;
        navigationController?.pushViewController(searchTable, animated: true)
        
    }
    @IBOutlet weak var ContactsCarousel: iCarousel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ContactsCarousel.type = iCarouselType.rotary;
        ContactsCarousel.reloadData();
        
        title = "Emergency Contacts";
        ContactsCarousel.delegate = self;
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as? AppDelegate;
        
        let context = delegate?.persistentContainer.viewContext;
        
        let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Contacts")
        
        do
        {
            let results = try context?.fetch(fetchRequest);
            for i in results!
            {
                if(CarouselContactsViewController.topFive == nil)
                {
                    CarouselContactsViewController.topFive = Set<NSManagedObject>();
                }
                CarouselContactsViewController.topFive.insert(i);
            }
        }
        catch let error as NSError
        {
            print("Fetching error")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(CarouselContactsViewController.topFive != nil)
        {
            print(CarouselContactsViewController.topFive.count);
        }
        ContactsCarousel.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 5;
    }
    
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let motherView = UIView(frame:CGRect(x: 0, y: 0, width: 250, height: 250));
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 250, height: 250));
        let contactsTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50));
        let numberTitle = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height / 2, width: 250, height: 50));
        numberTitle.textAlignment = NSTextAlignment.center;
        numberTitle.font = UIFont.boldSystemFont(ofSize: 16)
        numberTitle.textColor = UIColor.white;
        contactsTitle.textAlignment = NSTextAlignment.center;
        contactsTitle.font = UIFont.boldSystemFont(ofSize: 16);
        contactsTitle.textColor = UIColor.white;
        motherView.addSubview(imageView)
        motherView.addSubview(contactsTitle)
        motherView.addSubview(numberTitle)
        imageView.backgroundColor = AppDelegate.sharedDelegate().colorArray[index];
        
        //set correct contact
        if(CarouselContactsViewController.topFive != nil && CarouselContactsViewController.topFive.count != 0 && index < CarouselContactsViewController.topFive.count)
        {
//            let x = advance(CarouselContactsViewController.topFive.startIndex, index)
            let x = CarouselContactsViewController.topFive.index(CarouselContactsViewController.topFive.startIndex, offsetBy: index);
            contactsTitle.text = CarouselContactsViewController.topFive[x].value(forKey: "name") as? String;
            numberTitle.text = CarouselContactsViewController.topFive[x].value(forKey: "number") as? String
        }
        
        
//            [CarouselContactsViewController.topFive.index(CarouselContactsViewController.topFive.startIndex, off: index)].value(forKey: "name") as? String;
            
            
            
        return motherView;
    }
    
}
