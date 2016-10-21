//
//  SearchResultsCollectionViewController.swift
//  Example
//
//  Created by Hung on 7/10/16.
//  Copyright © 2016 ViSenze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "searchColViewCell"
import ViSearchSDK

class SearchResultsCollectionViewController: UICollectionViewController {

    public var photoResults: [ViImageResult] = []
    public var reqId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
//        collectionView?.reloadData()
        setupCollectionViewLayout()
    }

    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let column = 3
        let itemWidth = floor((view.bounds.size.width - CGFloat(column - 1)) / CGFloat(column))
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        layout.footerReferenceSize = CGSize(width: collectionView!.bounds.size.width, height: 100.0)
        collectionView!.collectionViewLayout = layout
    }
    
    //MARK: hud methods
    private func showHud(){
        KRProgressHUD.show()
    }
    
    private func dismissHud() {
        KRProgressHUD.dismiss()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImgCollectionViewCell
    
        // Configure the cell
        if let imageURL = photoResults[indexPath.row].im_url {
            cell.imgView.load(imageURL)
        }
        
        if let score = photoResults[indexPath.row].score {
            let percent = Int(score * 100)
            cell.similarityLabel.text = "Similarity: \(percent)%"
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showHud()
        
        let im_name = photoResults[indexPath.row].im_name
        
        // call tracking api here to register the click
        // alternately, you can present similar images or recommend them to users in the image detail page
        let params = ViTrackParams(reqId: self.reqId, action: "click")
        params?.imName = im_name
        
        ViSearch.sharedInstance.track(params: params!) { (success, error) in
            DispatchQueue.main.async {
                self.alert(message: "Click event sent!")
                self.dismissHud()
            }

        }
        
        
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
