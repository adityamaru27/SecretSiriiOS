//
//  ContactsSearchTableViewController.swift
//  SecretSiri
//
//  Created by Aditya Maru on 2016-10-13.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class ContactsSearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
//    weak var delegate:sendBack? = nil;
    var contactStore = CNContactStore();
    var my_contacts:[CNContact] = [];
    var shouldShowSearchResults = false;
    var searchController:UISearchController!;
    var carouselContactArray: Set<NSManagedObject>!;

    
    
    
    func Setup(arr: Set<NSManagedObject>)->Void
    {
        print("Guwop")
        carouselContactArray = arr;
    }
    

    func findContactsWithName(name: String)
    {
        AppDelegate.sharedDelegate().checkAccessStatus { (access) in
            if(access)
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name);
                        let keysToFetch = [CNContactGivenNameKey, CNContactPhoneNumbersKey];
//                        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor]);
//                        try self.contactStore.enumerateContacts(with: request, usingBlock: { (contact, stop)->Void in
//                            self.my_contacts.append(contact);
//                        })
                        self.my_contacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as [CNKeyDescriptor]);
                        self.tableView.reloadData();
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        searchController = UISearchController(searchResultsController: nil);
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.searchResultsUpdater = self;
        searchController.searchBar.placeholder = "Search for contacts";
        definesPresentationContext = true;
        searchController.searchBar.delegate = self;
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar;

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true;
        self.tableView.reloadData();
     
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false;
        tableView.reloadData();
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if( !shouldShowSearchResults)
        {
            shouldShowSearchResults = true;
        }
        
        searchController.searchBar.resignFirstResponder();
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString:String = searchController.searchBar.text!;
        findContactsWithName(name: searchString);
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return my_contacts.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contactsName: String;
        var numbers: String;
        if(indexPath.row < my_contacts.count)
        {
            contactsName = try my_contacts[indexPath.row].givenName ;
            if((my_contacts[indexPath.row].phoneNumbers.first) != nil)
            {
                numbers = (((my_contacts[indexPath.row].phoneNumbers.first)!.value) as CNPhoneNumber).stringValue;
            }
            else
            {
                numbers = ""
            }
        }
        else
        {
            contactsName = ""
            numbers = ""
            print("Index out of range")
        }
        var cell = ContactsTableViewCell()
        cell.textLabel!.text = contactsName + " : " + numbers;

//         Configure the cell...

        return cell
    }
    
    func saveName(name: String)->Void
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate;
        let managedObject = appdelegate.persistentContainer.viewContext;
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: managedObject);
        let contacts = NSManagedObject(entity: entity!, insertInto: managedObject);
        
        var detailArr = name.components(separatedBy: " : ")
        
        contacts.setValue(detailArr[0], forKey: "name");
        contacts.setValue(detailArr[1], forKey: "number")
        
        do
        {
            try managedObject.save();
            carouselContactArray.insert(contacts);
        }
        catch let error as NSError
        {
            print("error here")
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(carouselContactArray.count < 5)
        {
    
            saveName(name: (self.tableView.cellForRow(at: indexPath)!.textLabel!.text)!);
            let alert = UIAlertController(title: "Success", message: "Contact added", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil);
            
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "5 contacts already registered, delete before adding more!", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil);
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        delegate?.sendBack(set: carouselContactArray);
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//protocol sendBack:class {
//    func sendBack(set: Set<NSManagedObject>!) -> Void;
//}
