//
//  PaymentPageViewController.swift
//  Devent
//
//  Created by Erman Sefer on 04/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit
import PassKit

class PaymentPageViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var payButtonSon: UIButton!
    @IBOutlet weak var eventPictureForPayment: UIImageView!
    
    
    var groupId: String = ""
    var macthedEventObjectId: String = ""
    let backendChargeURLString = "https://deventpayment.herokuapp.com"
    var paymentTextField = STPPaymentCardTextField()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    

    func refreshLocalDataStoreFromServer() {
        
        let query = PFQuery(className: "Events")
            .whereKey("objectId", equalTo: groupId)
        query.findObjectsInBackgroundWithBlock({object, error in
            if (error == nil) {
            for action in object! {
                action.pinInBackground()
                self.eventName.text = action["Name"] as? String
                let amount = action["Price"] as? String
                self.eventPrice.text = ("$\(amount!)")
                
                let initialThumbnail = UIImage(named: "question")
                self.eventPictureForPayment.image = initialThumbnail
                if let thumbnail = action["Picture"] as? PFFile{
                    thumbnail.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            self.eventPictureForPayment.image = UIImage(data:imageData!)}
                    })}
                
            }
            }
        })
 
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.paymentTextField.frame = CGRectMake(screenSize.width*0.1, screenSize.height*0.7, screenSize.width*0.8, screenSize.height*0.1)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)

        self.refreshLocalDataStoreFromServer()
        
        let query = PFQuery(className: "Events")
        .whereKey("objectId", equalTo: groupId)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock({object, error in
            
            
            
            for action in object! {
            self.eventName.text = action["Name"] as? String
            let amount = action["Price"] as? String
            self.eventPrice.text = ("$\(amount!)")

                
            let initialThumbnail = UIImage(named: "question")
            self.eventPictureForPayment.image = initialThumbnail
            if let thumbnail = action["Picture"] as? PFFile{
                thumbnail.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.eventPictureForPayment.image = UIImage(data:imageData!)}
                    })}

           }
            
        })
        
       
     
    }

    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        payButtonSon.enabled = textField.valid

    }

    
    
    @IBAction func realPayment(sender: AnyObject) {
        STPAPIClient.sharedClient().createTokenWithCard(paymentTextField.card!, completion: { (token, error) -> Void in
            
            if error != nil {
                self.handleError(error!)
                return
            }
            
            print(token)
            self.createBackendChargeWithToken(token!, completion: { (result, error) -> Void in
                if result == STPBackendChargeResult.Success {
                    //completion(PKPaymentAuthorizationStatus.Success)
                }
                else {
                    //completion(PKPaymentAuthorizationStatus.Failure)
                }
            })
        })
    }
    
    
    
    
    func handleError(error: NSError) {
        UIAlertView(title: "Please Try Again",
            message: error.localizedDescription,
            delegate: nil,
            cancelButtonTitle: "OK").show()
        
    }
 
    func createBackendChargeWithToken(token: STPToken, completion: STPTokenSubmissionHandler) {
        if backendChargeURLString != "" {
            if let url = NSURL(string: backendChargeURLString  + "/charge") {
                
                let eventPriceValue = Int(eventPrice.text!) as Int?
                let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                let postBody = "stripeToken=\(token.tokenId)&amount=\(eventPriceValue!*100)"
                let postData = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                session.uploadTaskWithRequest(request, fromData: postData, completionHandler: { data, response, error in
                    let successfulResponse = (response as? NSHTTPURLResponse)?.statusCode == 200
                    if successfulResponse && error == nil {
                        completion(.Success, nil)
                        print("success")
                        print(self.macthedEventObjectId)
                        
                        let query = PFQuery(className: "MatchedEvent")
                            .whereKey("objectId", equalTo: self.macthedEventObjectId)
                        query.findObjectsInBackgroundWithBlock({object, error in
                            
                            for action in object! {
                                
                                if action["PaidUserId1"] == nil {
                                
                                action.setObject(PFUser.currentUser()!.objectId!, forKey: "PaidUserId1")
                                action.saveInBackground()
                                }
                                
                                else {
                                    
                                action.setObject(PFUser.currentUser()!.objectId!, forKey: "PaidUserId2")
                                action.saveInBackground()
                                }
                                
                            }
                            
                            self.performSegueWithIdentifier("successPaySeque", sender: self)
                            
                        })
                        
                        

                        
                        
                    } else {
                        if error != nil {
                            completion(.Failure, error)
                        } else {
                            completion(.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "There was an error communicating with your payment backend."]))
                        }
                        
                    }
                }).resume()
                
                return
            }
        }
        completion(STPBackendChargeResult.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "You created a token! Its value is \(token.tokenId). Now configure your backend to accept this token and complete a charge."]))
    }

}
