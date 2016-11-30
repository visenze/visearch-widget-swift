//
//  ViFilterCategoryViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ViFilterCategoryViewControllerCell"

public protocol ViFilterCategoryViewControllerDelegate : class {
    func categoryFilterDone(filterItem: ViFilterItemCategory?)
    func categoryFilterReset(filterItem: ViFilterItemCategory?)
}

open class ViFilterCategoryViewController: UITableViewController {

    open var filterItem : ViFilterItemCategory? = nil
    
    open var delegate : ViFilterCategoryViewControllerDelegate? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let resetBarItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(resetBtnTap(sender:)))
        self.navigationItem.leftBarButtonItem = resetBarItem
        
        let doneBtnItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnTap(sender:)) )
        self.navigationItem.rightBarButtonItem = doneBtnItem
    }
    
    open func resetBtnTap(sender: UIBarButtonItem) {
        // clear all selection
        filterItem?.selectedOptions.removeAll()
        self.tableView.reloadData()
        
        delegate?.categoryFilterReset(filterItem: self.filterItem)
    }
    
    open func doneBtnTap(sender: UIBarButtonItem) {
        
        delegate?.categoryFilterDone(filterItem: self.filterItem)
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.filterItem {
            return 1
        }
        
        return 0
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let item = self.filterItem {
            return item.options.count
        }
        
        return 0
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let filterItem = self.filterItem {
        
            let item = filterItem.options[indexPath.row]
            
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
            
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
            }
            
            if let cell = cell {
                cell.textLabel?.text = item.option
                
                // check whether selected
                let (selected , _ ) = self.isSelected(item, filterItem)
                
                cell.accessoryType = selected ? .checkmark : .none
                
            }
            
            return cell!
        }
        
        // this should never happen
        return UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let filterItem = self.filterItem {
            
            let item = filterItem.options[indexPath.row]
            
            let (selected , selectedIndex ) = self.isSelected(item, filterItem)
            
            if selected {
                // remove from option
                if (selectedIndex >= 0 && selectedIndex < filterItem.selectedOptions.count) {
                    filterItem.selectedOptions.remove(at: selectedIndex)
                }
            }
            else {
                filterItem.selectedOptions.append(item)
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    // check whether this option is currently selected
    private func isSelected(_ curOption : ViFilterItemCategoryOption  , _ filterItem: ViFilterItemCategory) -> (Bool , Int) {
        var selected : Bool = false
        var selectedIndex : Int = -1
        
        for (index, selectedOption) in filterItem.selectedOptions.enumerated() {
            if selectedOption.value == curOption.value {
                selected = true
                selectedIndex = index
                break
            }
        }
        
        return (selected , selectedIndex )
    }
    

}
