//
//  SearchByImageViewController.swift
//  Example
//
//  Created by Hung on 8/10/16.
//  Copyright © 2016 ViSenze. All rights reserved.
//

import UIKit
import ViSearchSDK

class SearchByImageViewController: UIViewController {
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var imgView: UIImageView!
    private var recentResponseData: ViResponseData?
    
    @IBAction func searchClick(_ sender: AnyObject) {
        if let img = self.imgView.image {
            
            showHud()
            
            let params = ViUploadSearchParams(image: img)
            params.score = true // optional: display score in result
            params.fl = ["im_url"] // retrieve image url. By default the API only return im_name if does not specify fl parameter
            params.limit = 15 // display 15 results per page
            
            // set this if you want to get all meta-data of the image
//            params.getAllFl = true
            
            // set this for automatic object recognition
//            params.detection = "all"
            
            // example for filtering if category and price are defined in the schema
//            params.fq["category"] = "furniture"
//            params.fq["price"] = "200.0,250.0"
            
            /*
            // EXAMPLE for search image by url
            let params = ViUploadSearchParams(im_url: "http://somesite.com/sample_image.png")
            
            // example for search image by id
            let params = ViUploadSearchParams(im_id: "im_id_example")
             
            // example to configure box
            let box = ViBox(x1: 5, y1: 5, x2: 5, y2: 5)
            params?.box = box
             
            // example for setting image quality
            params?.img_settings = ViImageSettings(size: CGSize(width: 800, height: 800), quality: 0.9)
            */
            
            ViSearch.sharedInstance.uploadSearch( params: params,
                                                 successHandler: {
                                                    (data : ViResponseData?) -> Void in
                                                    // Do something when request succeeds
                                                    // preview by calling : dump(data)
                                                    // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                                                    if let data = data {
                                                        if data.hasError {
                                                            let errMsgs =  data.error.joined(separator: ",")
                                                            
                                                            DispatchQueue.main.async {
                                                                // error message from server e.g. invalid parameter
                                                                self.alert(message: "API error: \(errMsgs)", title: "Error")
                                                            }
                                                        }
                                                        else {
                                                            // perform segue here
                                                            
                                                            // for debuging, dump all data from server
                                                            dump(data)
                                                            self.recentResponseData = data
                                                            
                                                            DispatchQueue.main.async {
                                                                self.performSegue(withIdentifier: "showResultsFromImage", sender: self)
                                                            }
                                                        }
                                                    }
                                                    
                                                    self.dismissHud()
                                                    
                                                    
                                                    
                },
                                                 failureHandler: {
                                                    (err) -> Void in
                                                    
                                                    DispatchQueue.main.async {
                                                        // Do something when request fails e.g. due to network error
                                                        self.alert(message: "An error has occured: \(err.localizedDescription)", title: "Error")
                                                        self.dismissHud()
                                                    }
                                                    
            })

        }
        else {
            alert(message: "Please take a photo or choose one from gallery", title: "Error")
        }
    }
    
    
    
    //MARK: hud methods
    private func showHud(){
        KRProgressHUD.show()
    }
    
    private func dismissHud() {
        KRProgressHUD.dismiss()
    }

    
    //MARK: choose photo methods
    @IBAction func takePhotoClick(_ sender: AnyObject) {
        let cameraViewController = CameraViewController(croppingEnabled: false, allowsLibraryAccess: true) { [weak self] image, asset in
            self?.imgView.image = image
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func chooseFromGallery(_ sender: UIButton) {
        let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled: false) { image, asset in
            self.imgView.image = image
            self.dismiss(animated: true, completion: nil)
        }
        
        present(libraryViewController, animated: true, completion: nil)
        
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showResultsFromImage" {
            if let recentResponseData = recentResponseData {
                let searchResultsController = segue.destination as! SearchResultsCollectionViewController
                searchResultsController.photoResults = recentResponseData.result
                searchResultsController.reqId = recentResponseData.reqId!
                
            }
        }
    }


}
