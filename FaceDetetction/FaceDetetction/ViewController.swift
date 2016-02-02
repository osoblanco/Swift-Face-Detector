//
//  ViewController.swift
//  FaceDetetction
//
//  Created by Erik Arakelyan on 1/29/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var celebImageView: UIImageView!
    
    
    override func viewDidLoad() {
        self.nameTextfield.delegate = self
        super.viewDidLoad()
        
        
        //try! WikiFaceDetector.detectFaces("Tim Cook", size: CGSize(width:200, height:200), completion:{ (image, imageFound) -> () in
        //})
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.nameTextfield.resignFirstResponder()
        if let textFieldContent = textField.text {
            do {
                try WikiFaceDetector.detectFaces(textFieldContent, size: CGSize(width: 200, height: 250), completion: { (image:UIImage?, imgFound:Bool!) -> () in
                    if imgFound == true {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.celebImageView.image = image
                            
                            WikiFaceDetector.detectFace(self.celebImageView)
                        })
                    }
                })
            }catch WikiFaceDetector.WikiFaceDetectorError.couldNotLoadImage{
                print("Could not access wikipedia for downloading an image")
            } catch {
                print(error)
            }
        }

        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

