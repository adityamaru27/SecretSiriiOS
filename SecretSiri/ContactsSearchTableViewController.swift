//
//  ContactsSearchTableViewController.swift
//  SecretSiri
//
//  Created by Aditya Maru on 2016-10-13.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import Contacts

class ContactsSearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var contactStore = CNContactStore();
    var my_contacts:[CNContact] = [];
    var shouldShowSearchResults = false;
    var searchController:UISearchController!;
    

    func findContactsWithName(name: String)
    {
        AppDelegate.sharedDelegate().checkAccessStatus { (access) in
            if(access)
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name);
                        let keysToFetch = [CNContactGivenNameKey, CNContactPhoneNumbersKey];
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
        var my_string = my_contacts[indexPath.row].givenName;
        var cell = ContactsTableViewCell()
        print(my_string);
//         Configure the cell...

        return cell
    }

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
