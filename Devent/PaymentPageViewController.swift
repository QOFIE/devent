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
    
    var groupId: String = ""
    var macthedEventObjectId: String = ""
    let backendChargeURLString = "https://deventpayment.herokuapp.com"
    var paymentTextField = STPPaymentCardTextField()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentTextField.frame = CGRectMake(50, 50, 250, 100)
        paymentTextField.center = view.center
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
        let query = PFQuery(className: "Events")
        .whereKey("objectId", equalTo: groupId)
        query.findObjectsInBackgroundWithBlock({object, error in
            
            for action in object! {
            self.eventName.text = action["Name"] as? String
            self.eventPrice.text = action["Price"] as? String

           }
            
        })
        

    }

    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        payButtonSon.enabled = textField.valid
        print(textField.valid)
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
