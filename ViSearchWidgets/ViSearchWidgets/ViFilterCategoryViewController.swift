//
//  ViFilterCategoryViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ViFilterCategoryViewControllerCell"

/// delegate
public protocol ViFilterCategoryViewControllerDelegate : class {
    func categoryFilterDone(filterItem: ViFilterItemCategory?)
    func categoryFilterReset(filterItem: ViFilterItemCategory?)
}

/// Filter category view controller which allows multiple selection
open class ViFilterCategoryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {

    /// table view which shows list of category options
    public var tableView : UITableView {
        let resultsView = self.view as! ViFilterTableView
        return resultsView.tableView!
    }
    
    /// show/hide Power by Visenze image
    public var showPowerByViSenze : Bool = true
    
    /// Filter item configuration and selected items
    open var filterItem : ViFilterItemCategory? = nil {
        didSet {
            // copy the selected options over
            // we only want to keep the selected options once it is confirmed i.e. click on Done button
            if let item = self.filterItem {
                var arr : [ViFilterItemCategoryOption] = []
                
                for option in item.selectedOptions {
                    arr.append(option)
                }
                
                self.selectedOptions = arr
            }
        }
    }
    
    /// store selected options
    open var selectedOptions : [ViFilterItemCategoryOption] = []
    
    
    /// delegate
    open var delegate : ViFilterCategoryViewControllerDelegate? = nil
    
    open override func loadView() {
        self.view = ViFilterTableView(frame: .zero)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let filterTableView = self.view as! ViFilterTableView
        filterTableView.powerImgView.isHidden = !self.showPowerByViSenze
        
//        filterTableView.okBtn.addTarget(self, action: #selector(self.okBtnTap(sender:forEvent:) ), for: .touchUpInside)
        
        let resetBarItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(resetBtnTap(sender:)))
        self.navigationItem.leftBarButtonItem = resetBarItem
        
        let doneBtnItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnTap(sender:)) )
        self.navigationItem.rightBarButtonItem = doneBtnItem
    }
    
    // MARK: Buttons events
    
    public func okBtnTap(sender: UIButton, forEvent event: UIEvent) {
        self.doneTap()
    }
    
    open func resetBtnTap(sender: UIBarButtonItem) {
        // clear all selection
        self.selectedOptions.removeAll()
        self.tableView.reloadData()
        
        delegate?.categoryFilterReset(filterItem: self.filterItem)
    }
    
    private func doneTap(){
        self.filterItem?.selectedOptions.removeAll()
        
        // set selected
        var arr : [ViFilterItemCategoryOption] = []
        
        for option in self.selectedOptions {
            arr.append(option)
        }
        
        self.filterItem?.selectedOptions = arr
        
        delegate?.categoryFilterDone(filterItem: self.filterItem)
    }
    
    open func doneBtnTap(sender: UIBarButtonItem) {
        self.doneTap()
    }

    // MARK: - Table view data source

    open func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.filterItem {
            return 1
        }
        
        return 0
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let item = self.filterItem {
            return item.options.count
        }
        
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let filterItem = self.filterItem {
            
            let item = filterItem.options[indexPath.row]
            
            let (selected , selectedIndex ) = self.isSelected(item, filterItem)
            
            if selected {
                // remove from option
                if (selectedIndex >= 0 && selectedIndex < self.selectedOptions.count) {
                    self.selectedOptions.remove(at: selectedIndex)
                }
            }
            else {
                self.selectedOptions.append(item)
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    // MARK: Helper methods
    
    // check whether this option is currently selected
    private func isSelected(_ curOption : ViFilterItemCategoryOption  , _ filterItem: ViFilterItemCategory) -> (Bool , Int) {
        var selected : Bool = false
        var selectedIndex : Int = -1
        
        for (index, selectedOption) in self.selectedOptions.enumerated() {
            if selectedOption.value == curOption.value {
                selected = true
                selectedIndex = index
                break
            }
        }
        
        return (selected , selectedIndex )
    }
    

}
