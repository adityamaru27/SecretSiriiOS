//
//  CarouselContactsViewController.swift
//  SecretSiri
//
//  Created by Aditya Maru on 2016-10-13.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit

class CarouselContactsViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {

    @IBAction func contactsSearch(_ sender: AnyObject) {
        let searchTable = ContactsSearchTableViewController();
        navigationController?.pushViewController(searchTable, animated: true)
        print("Turn down for what")
        
    }
    @IBOutlet weak var ContactsCarousel: iCarousel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ContactsCarousel.type = iCarouselType.rotary;
        ContactsCarousel.reloadData();
        
        title = "Emergency Contacts";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 5;
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 250, height: 250));
        if(index == 0 || index == 2 || index == 4)
        {
            imageView.backgroundColor = UIColor.red;
        }
        else
        {
            imageView.backgroundColor = UIColor.yellow;

        }
        return imageView;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
