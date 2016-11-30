//
//  ViFilterViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

private let reuseDefaultIdentifer = "ViFilterItemCell"
private let reuseCategoryIdentifer = "ViFilterItemCategoryCell"
private let reuseRangeIdentifer = "ViFilterItemRangeCell"

// TODO: need to passed in the options
public protocol ViFilterViewControllerDelegate: class {
    func applyFilter()
    func resetFilter()
}

// make the delegate optional
public extension ViFilterViewControllerDelegate{
    func applyFilter(){}
    func resetFilter(){}
}

open class ViFilterViewController: UITableViewController , ViFilterCategoryViewControllerDelegate {

    open var filterItems : [ViFilterItem] = []
    
    public var delegate: ViFilterViewControllerDelegate? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let resetBarItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetBtnTap(sender:)))
        self.navigationItem.leftBarButtonItem = resetBarItem
        
        let applyBtnItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(applyBtnTap(sender:)) )
        self.navigationItem.rightBarButtonItem = applyBtnItem
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseDefaultIdentifer)
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCategoryIdentifer)
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseRangeIdentifer)
        
        
    }
    
    open func resetBtnTap(sender: UIBarButtonItem) {
        // reset filter
        for item in self.filterItems {
            item.reset()
        }
        
        self.tableView.reloadData()
        
        delegate?.resetFilter()
    }
    
    open func applyBtnTap(sender: UIBarButtonItem) {
        delegate?.applyFilter()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterItems.count
    }

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 44.0
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.filterItems[indexPath.row]
        
        let reuseIdentifer : String = {
            if(item.filterType == ViFilterItemType.CATEGORY) {
                return reuseCategoryIdentifer
            }
            
            if(item.filterType == ViFilterItemType.RANGE) {
                return reuseRangeIdentifer
            }
            
            return reuseDefaultIdentifer
            
        }()
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer)
        
        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifer)
        }
        
        if let cell = cell {
            cell.textLabel?.text = item.title
            
            if(item.filterType == ViFilterItemType.CATEGORY) {
                if let catItem = item as? ViFilterItemCategory {
                    cell.detailTextLabel?.text = catItem.isAllSelected() ? "All" : catItem.getSelectedString()
                }
                
            }
            
            
            if(item.filterType == ViFilterItemType.CATEGORY) {
                cell.accessoryType = .disclosureIndicator
            }
            else {
                cell.accessoryType = .none
            }
        }

        return cell!
    }
    
    override open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        let item = self.filterItems[indexPath.row]
        
        // only if item is category filter, allow user to select
        if(item.filterType == ViFilterItemType.CATEGORY) {
            return indexPath
        }
        
        return nil
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item = self.filterItems[indexPath.row]
        if(item.filterType == ViFilterItemType.CATEGORY) {
            // go to category filter
            let controller = ViFilterCategoryViewController()
            controller.filterItem = item as? ViFilterItemCategory
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: category filter delegate
    open func categoryFilterDone(filterItem: ViFilterItemCategory?) {
        self.navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
    }
    
    open func categoryFilterReset(filterItem: ViFilterItemCategory?) {
        
    }
    

}
