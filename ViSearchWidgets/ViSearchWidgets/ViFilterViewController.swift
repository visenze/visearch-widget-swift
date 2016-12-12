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

/// delegate for filter actions
public protocol ViFilterViewControllerDelegate: class {
    func applyFilter(_ filterItems : [ViFilterItem])
    func resetFilter()
}

// make the delegate optional
public extension ViFilterViewControllerDelegate{
    func applyFilter(_ filterItems : [ViFilterItem]){}
    func resetFilter(){}
}


/// Filter controller that shows list of filter items in a table view
open class ViFilterViewController: UIViewController , UITableViewDelegate, UITableViewDataSource ,ViFilterCategoryViewControllerDelegate {

    /// table view that shows list of filters
    public var tableView : UITableView {
        let resultsView = self.view as! ViFilterTableView
        return resultsView.tableView!
    }
    
    // show/hide Power by Visenze image
    public var showPowerByViSenze : Bool = true
    
    /// list of filter items
    open var filterItems : [ViFilterItem] = []
    
    /// list of original filter items
    open var initFilterItems : [ViFilterItem] = [] {
        didSet {
            self.filterItems.removeAll()
            
            // clone list of filter items and put into filter items
            for item in initFilterItems {
                self.filterItems.append(item.clone())
            }
        }
    }
    
    /// delegate
    public var delegate: ViFilterViewControllerDelegate? = nil
    
    open override func loadView() {
        self.view = ViFilterTableView(frame: .zero)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let filterTableView = self.view as! ViFilterTableView
        filterTableView.powerImgView.isHidden = !self.showPowerByViSenze
        
        if #available(iOS 9.0, *) {
            self.tableView.cellLayoutMarginsFollowReadableWidth = false
        }
        

//        filterTableView.okBtn.addTarget(self, action: #selector(self.okBtnTap(sender:forEvent:) ), for: .touchUpInside)
        
        let resetBarItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(resetBtnTap(sender:)))
        self.navigationItem.leftBarButtonItem = resetBarItem
        
        let applyBtnItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(applyBtnTap(sender:)) )
        self.navigationItem.rightBarButtonItem = applyBtnItem
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseDefaultIdentifer)
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCategoryIdentifer)
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseRangeIdentifer)
        
        
    }
    
    public func okBtnTap(sender: UIButton, forEvent event: UIEvent) {
       
        delegate?.applyFilter(self.filterItems)
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
        delegate?.applyFilter(self.filterItems)
    }
    
    // MARK: - Table view data source

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterItems.count
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let item = self.filterItems[indexPath.row]
        
        if(item.filterType == .RANGE ) {
            return 84.0
        }
        
        return 44.0
        
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            if(item.filterType == .RANGE) {
                let rangeCell : ViRangeTableViewCell = ViRangeTableViewCell(style: .default, reuseIdentifier: reuseIdentifer)
                rangeCell.rangeSlider?.trackHighlightTintColor = ViTheme.sharedInstance.default_filter_track_color
                
                // configure thumb as square
                rangeCell.rangeSlider?.curvaceousness = 0.0
                
                cell = rangeCell
            }
            else {
                cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifer)
                cell!.textLabel?.font = ViTheme.sharedInstance.default_filter_row_title_font
                cell!.detailTextLabel?.font = ViTheme.sharedInstance.default_filter_row_desc_font
            }
        }
        
        if let cell = cell {
            
            if(item.filterType == .RANGE ) {
                
                let rangeCell = cell as! ViRangeTableViewCell
                let rangeItem = item as! ViFilterItemRange
                
                rangeCell.filterItem = rangeItem
                
            }
            else {
                cell.textLabel?.text = item.title
            }
        
            if(item.filterType == ViFilterItemType.CATEGORY) {
                if let catItem = item as? ViFilterItemCategory {
                    cell.detailTextLabel?.text = catItem.isAllSelected() ? "All" : catItem.getSelectedString()
                }
                
                cell.accessoryType = .disclosureIndicator
            }
            else {
                cell.accessoryType = .none
            }
        }

        return cell!
    }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        let item = self.filterItems[indexPath.row]
        
        // only if item is category filter, allow user to select
        if(item.filterType == ViFilterItemType.CATEGORY) {
            return indexPath
        }
        
        return nil
    }
    
    
    /// If the selected row is a category filter item, we will open up the category filter view controller
    ///
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item = self.filterItems[indexPath.row]
        if(item.filterType == ViFilterItemType.CATEGORY) {
            // go to category filter
            let controller = ViFilterCategoryViewController()
            controller.showPowerByViSenze = self.showPowerByViSenze
            controller.filterItem = item as? ViFilterItemCategory
            controller.title = "Select \(item.title)"
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
