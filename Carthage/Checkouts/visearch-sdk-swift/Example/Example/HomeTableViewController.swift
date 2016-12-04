//
//  HomeTableViewController.swift
//  Example
//
//  Created by Hung on 7/10/16.
//  Copyright © 2016 ViSenze. All rights reserved.
//

import UIKit
import ViSearchSDK

class HomeTableViewController: UITableViewController {
    
    static let COLOR_SEARCH: String = "Search by Color"
    static let FIND_SIMILAR_SEARCH: String = "Find Similar"
    static let YOU_MAY_ALSO_LIKE_SEARCH: String = "You May Also Like"
    static let IMAGE_SEARCH: String = "Search by Image"
    
    let demoItems : [String] = [FIND_SIMILAR_SEARCH , YOU_MAY_ALSO_LIKE_SEARCH, IMAGE_SEARCH , COLOR_SEARCH ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check if client setup properly
        if !ViSearch.sharedInstance.isClientSetup() {
            alert(message: "Please setup the API client with access and secret key", title: "Error")
        }
        
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "solutionTableViewCell", for: indexPath)

        cell.textLabel?.text = demoItems[indexPath.row]
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if demoItems[indexPath.row] == HomeTableViewController.IMAGE_SEARCH {
            self.performSegue(withIdentifier: "showImageSearch", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "startDemoSegue", sender: tableView.cellForRow(at: indexPath) )
        }
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "startDemoSegue" {
            let searchController = segue.destination as! SearchViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? UITableViewCell {
                
                let indexPath = tableView.indexPath(for: selectedCell)!
                let demoItem = demoItems[indexPath.row]
                if demoItem == HomeTableViewController.COLOR_SEARCH {
                    searchController.demoApi = ViAPIEndPoints.COLOR_SEARCH
                }
                else if demoItem == HomeTableViewController.FIND_SIMILAR_SEARCH {
                    searchController.demoApi = ViAPIEndPoints.ID_SEARCH
                }
                else if demoItem == HomeTableViewController.YOU_MAY_ALSO_LIKE_SEARCH {
                    searchController.demoApi = ViAPIEndPoints.REC_SEARCH
                }
                
                searchController.navigationItem.title = demoItem
              
            }
        }

        // hide the back label in the next controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        
    }
    

}
