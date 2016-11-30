//
//  ViDefaultTrackingAction.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit


/// List of default tracking actions
///
/// - CLICK: user clicks on a product after search
/// - ADD_TO_CART: user clicks on add to cart button to add a product to shopping cart
/// - ADD_TO_WISHLIST: user clicks on favorite button to add to wishlist
public enum ViDefaultTrackingAction : String {
    
    case CLICK = "click"
    
    case ADD_TO_CART = "add_to_cart"
    
    case ADD_TO_WISHLIST = "add_to_wishlist"
    
}

/// These actions are tracked automatically when calling various API calls
/// Custom actions should not used these
public enum ViReservedTrackingAction : String {
    /// trigger when calling find similar API
    case SEARCH = "search"
    
    /// trigger when call you may like API
    case RECOMMENDATION = "recommendation"
    
    /// trigger when call color search API
    case COLOR_SEARCH  = "colorsearch"
    
    /// trigger when call search by image API
    case UPLOAD_SEARCH = "uploadsearch"


}
