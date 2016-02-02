//
//  WikiFaceDetector.swift
//  FaceDetetction
//
//  Created by Erik Arakelyan on 1/29/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import ImageIO

class WikiFaceDetector: NSObject {

    
    enum WikiFaceDetectorError:ErrorType
    {
        case couldNotLoadImage
        
    }
    
    class func detectFaces (person:String, size:CGSize , completion:(image:UIImage?, imgFound:Bool!) ->()) throws
    {
    
        let escapedString = person.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let pixelsForAPIRequest = Int(max(size.height, size.width)) * 2
        
        
        let preUrl = "https://en.wikipedia.org/w/api.php?action=query&titles=\(escapedString!)&prop=pageimages&format=json&pithumbsize=\(pixelsForAPIRequest)"
        
        // in the request we search for the the specific name with image size
        
        
        let url = NSURL(string: preUrl )
        
        
        guard let task: NSURLSessionTask? = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error==nil
            {
                let wikiDict = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                print(wikiDict)
                
                
                if let querry = wikiDict.objectForKey("query") as? NSDictionary {
                    if let pages = querry.objectForKey("pages") as? NSDictionary {
                        if let pageContent = pages.allValues.first as? NSDictionary {
                            if let thumbnail = pageContent.objectForKey("thumbnail") as? NSDictionary {
                                if let thumbURL = thumbnail.objectForKey("source") as? String {
                                    let faceImage = UIImage(data: NSData(contentsOfURL: NSURL(string: thumbURL)!)!)
                                    
                                    completion(image: faceImage, imgFound: true)
                                }
                            }else{
                                completion(image: nil, imgFound: false)
                            }
                        }
                    }
                }
                
                
            }
        })else{
            throw WikiFaceDetectorError.couldNotLoadImage
        }
        
        
        
        task!.resume()
    
    }
    
    
    class func detectFace (imageView: UIImageView?)
    {
        let context = CIContext(options: nil)
        let options = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
    
        let faceImage = imageView?.image
        let ciImage = CIImage(CGImage:faceImage!.CGImage!)
        
        let features =  detector.featuresInImage(ciImage)
        
        if features.count > 0
        {
            var face: CIFaceFeature!
            
            for rect in features
            {
                
            face = rect as! CIFaceFeature
            }
            
            var faceABitExtended = face.bounds
        
            faceABitExtended.origin.x -= 25
            faceABitExtended.origin.y -= 25
            
            faceABitExtended.size.width += 50
            faceABitExtended.size.height += 50
            
            let x = faceABitExtended.origin.x/faceImage!.size.width
            let y = (faceImage!.size.height - faceABitExtended.origin.y - faceABitExtended.size.height) / faceImage!.size.height
            
            let widthFace = faceABitExtended.size.width / faceImage!.size.width
            let heightFace = faceABitExtended.size.height  / faceImage!.size.height

            
            imageView?.layer.contentsRect = CGRectMake(x, y, widthFace, heightFace)
        }
        
        
    }
    
    
}
