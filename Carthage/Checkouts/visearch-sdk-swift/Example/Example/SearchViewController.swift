//
//  SearchViewController.swift
//  Example
//
//  Created by Hung on 7/10/16.
//  Copyright © 2016 ViSenze. All rights reserved.
//

import UIKit
import ViSearchSDK

class SearchViewController: UIViewController, UITextFieldDelegate, SwiftHUEColorPickerDelegate {
    
    public var demoApi : ViAPIEndPoints = ViAPIEndPoints.ID_SEARCH

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var paramLabel: UILabel!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    private var recentResponseData: ViResponseData?
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var saturationColorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var brightnessColorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var alphaColorPicker: SwiftHUEColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.delegate = self
        
        colorPicker.isHidden = true
        saturationColorPicker.isHidden = true
        brightnessColorPicker.isHidden = true
        alphaColorPicker.isHidden = true
        colorView.isHidden = true
        
        if demoApi == ViAPIEndPoints.ID_SEARCH || demoApi == ViAPIEndPoints.REC_SEARCH {
            paramLabel.text = "Existing image name (im_name):"
        }
        else if demoApi == ViAPIEndPoints.COLOR_SEARCH {
            
            colorView.isHidden = false
            textField.isEnabled = false
            paramLabel.text = "Color code (6 characters hex): "
            
            colorPicker.isHidden = false
            colorPicker.delegate = self
            colorPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
            colorPicker.type = SwiftHUEColorPicker.PickerType.color
            
            saturationColorPicker.isHidden = false
            saturationColorPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
            saturationColorPicker.delegate = self
            saturationColorPicker.type = SwiftHUEColorPicker.PickerType.saturation
            
            brightnessColorPicker.isHidden = false
            brightnessColorPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
            brightnessColorPicker.delegate = self
            brightnessColorPicker.type = SwiftHUEColorPicker.PickerType.brightness
            
            alphaColorPicker.isHidden = false
            alphaColorPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
            alphaColorPicker.delegate = self
            alphaColorPicker.type = SwiftHUEColorPicker.PickerType.alpha
            
            
        }
        
        checkValidParam()
        
        
    }
    
    func checkValidParam() {
        // Disable the Save button if the text field is empty.
        let text = textField.text!.trimmingCharacters(in: .whitespaces)
        searchBtn.isEnabled = !text.isEmpty
    }
    
    private func showHud(){
        KRProgressHUD.show()
    }
    
    private func dismissHud() {
        KRProgressHUD.dismiss()
    }

    @IBAction func searchBtnTap(_ sender: UIBarButtonItem) {
        
        if demoApi == ViAPIEndPoints.ID_SEARCH {
            findSimilar()
        }
        else if demoApi == ViAPIEndPoints.REC_SEARCH {
            recSearch()
        }
        else if demoApi == ViAPIEndPoints.COLOR_SEARCH {
            colorSearch()
        }
    }
    
    // MARK: color picker delegate
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        
        
        textField.text = color.hexString()
        
        colorView.backgroundColor = color
        
        switch type {
            case SwiftHUEColorPicker.PickerType.color:
                saturationColorPicker.currentColor = color
                brightnessColorPicker.currentColor = color
                alphaColorPicker.currentColor = color
                break
            case SwiftHUEColorPicker.PickerType.saturation:
                colorPicker.currentColor = color
                brightnessColorPicker.currentColor = color
                alphaColorPicker.currentColor = color
                break
            case SwiftHUEColorPicker.PickerType.brightness:
                colorPicker.currentColor = color
                saturationColorPicker.currentColor = color
                alphaColorPicker.currentColor = color
                break
            case SwiftHUEColorPicker.PickerType.alpha:
                colorPicker.currentColor = color
                saturationColorPicker.currentColor = color
                brightnessColorPicker.currentColor = color
                break
        }
        
        checkValidParam()
    }


    //MARK: API calls
    private func colorSearch() -> Void{
        showHud()
        
        let param = textField.text!.trimmingCharacters(in: .whitespaces)
        let params = ViColorSearchParams(color: param)
        params?.score = true // optional: display score in result
        params!.fl = ["im_url"] // retrieve image url. By default the API only return im_name if does not specify fl parameter
        params!.limit = 15 // display 15 results per page
        
        ViSearch.sharedInstance.colorSearch( params: params!,
                                             successHandler: {
                                                (data : ViResponseData?) -> Void in
                                                // Do something when request succeeds
                                                // preview by calling : dump(data)
                                                // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                                                if let data = data {
                                                    if data.hasError {
                                                        let errMsgs =  data.error.joined(separator: ",")
                                                        // error message from server e.g. invalid parameter
                                                        DispatchQueue.main.async {
                                                            self.alert(message: "API error: \(errMsgs)", title: "Error")
                                                        }
                                                    }
                                                    else {
                                                        // perform segue here
                                                        //dump(data)
                                                        self.recentResponseData = data
                                                        
                                                        DispatchQueue.main.async {
                                                            self.performSegue(withIdentifier: "showSearchResults", sender: self)
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
    
    private func findSimilar() -> Void{
        // show progress hud
        showHud()
        
        let param = textField.text!.trimmingCharacters(in: .whitespaces)
        let params = ViSearchParams(imName: param)
        params?.score = true // optional: display score in result
        params!.fl = ["im_url"] // retrieve image url. By default the API only return im_name if does not specify fl parameter
        params!.limit = 15 // display 15 results per page
        
        ViSearch.sharedInstance.findSimilar( params: params!,
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
                                                        //dump(data)
                                                        self.recentResponseData = data
                                                        
                                                        DispatchQueue.main.async {
                                                            self.performSegue(withIdentifier: "showSearchResults", sender: self)
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
    
    private func recSearch() -> Void{
        // show progress hud
        showHud()
    
        let param = textField.text!.trimmingCharacters(in: .whitespaces)
        
        let params = ViSearchParams(imName: param)
        params?.score = true // optional: display score in result
        params!.fl = ["im_url"] // retrieve image url. By default the API only return im_name if does not specify fl parameter
        params!.limit = 15 // display 15 results per page
        
        ViSearch.sharedInstance.recommendation( params: params!,
                                             successHandler: {
                                                (data : ViResponseData?) -> Void in
                                                // Do something when request succeeds
                                                // preview by calling : dump(data)
                                                // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                                                if let data = data {
                                                    if data.hasError {
                                                        let errMsgs =  data.error.joined(separator: ",")
                                                        // error message from server e.g. invalid parameter
                                                        DispatchQueue.main.async {
                                                            self.alert(message: "API error: \(errMsgs)", title: "Error")
                                                        }
                                                    }
                                                    else {
                                                        // perform segue here
                                                        //dump(data)
                                                        self.recentResponseData = data
                                                        
                                                        DispatchQueue.main.async {
                                                            self.performSegue(withIdentifier: "showSearchResults", sender: self)
                                                        }
                                                    }
                                                }
                                                
                                                self.dismissHud()
                                                
                                                
                                                
            },
                                             failureHandler: {
                                                (err) -> Void in
                                                // Do something when request fails e.g. due to network error
                                                DispatchQueue.main.async {
                                                    self.alert(message: "An error has occured: \(err.localizedDescription)", title: "Error")
                                                    self.dismissHud()
                                                }
                                                
        })
    }
    
    // MARK: text events
    @IBAction func textEditingChanged(_ sender: UITextField) {
        checkValidParam()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSearchResults" {
            if let recentResponseData = recentResponseData {
                let searchResultsController = segue.destination as! SearchResultsCollectionViewController
                searchResultsController.photoResults = recentResponseData.result
                searchResultsController.reqId = recentResponseData.reqId!
                
            }
        }
    }
    

}
