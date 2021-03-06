//
//  PaymentPageViewController.swift
//  Devent
//
//  Created by Erman Sefer on 04/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit
import PassKit

class PaymentPageViewController: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {

    @IBOutlet weak var payButtonSon: UIButton!
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    
    var groupId: String = ""
    var macthedEventObjectId: String = ""
    let backendChargeURLString = "https://deventpayment.herokuapp.com"
    var paymentTextField = STPPaymentCardTextField()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var price: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingSign.hidden = true
        payButtonSon.enabled = false
        
        self.paymentTextField.frame = CGRectMake(screenSize.width*0.1, screenSize.height*0.4, screenSize.width*0.8, screenSize.height*0.15)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
        let query = PFQuery(className: "Events").whereKey("objectId", equalTo: groupId)
        query.findObjectsInBackgroundWithBlock({object, error in
            
            for action in object! {
            let amount = action["price"] as? Int
            self.price = amount!
            }
                    })
    }

    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        payButtonSon.enabled = textField.valid
    }

    @IBAction func realPayment(sender: AnyObject) {
        STPAPIClient.sharedClient().createTokenWithCard(paymentTextField.card!, completion: { (token, error) -> Void in
            
            if error != nil {
                let alertController = UIAlertController(title: "Error", message:
                    "Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            self.createBackendChargeWithToken(token!, completion: { (result, error) -> Void in
                if result == STPBackendChargeResult.Success {
                   
                }
                else {
                    
                }
            })
        })
    }
 
    func createBackendChargeWithToken(token: STPToken, completion: STPTokenSubmissionHandler) {
        if backendChargeURLString != "" {
            if let url = NSURL(string: backendChargeURLString  + "/charge") {
                self.loadingSign.hidden = false
                self.loadingSign.startAnimating()
                let eventPriceValue = self.price
                let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                let postBody = "stripeToken=\(token.tokenId)&amount=\(eventPriceValue*100)"
                let postData = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                session.uploadTaskWithRequest(request, fromData: postData, completionHandler: { data, response, error in
                    let successfulResponse = (response as? NSHTTPURLResponse)?.statusCode == 200
                    if successfulResponse && error == nil {
                        completion(.Success, nil)
                        print("successful payment")
                        
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
                            self.loadingSign.stopAnimating()
                            let alertController = UIAlertController(title: "Error", message:
                                "Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        } else {
                            self.loadingSign.stopAnimating()
                            completion(.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "There was an error communicating with your payment backend."]))
                        }
                        
                    }
                }).resume()
                
                return
            }
        }
        completion(STPBackendChargeResult.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "You created a token! Its value is \(token.tokenId). Now configure your backend to accept this token and complete a charge."]))
    }
    
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }


func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
    paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
}

func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
    let info = cardInfo
    let card: STPCardParams = STPCardParams()
    card.number = info.cardNumber
    card.expMonth = info.expiryMonth
    card.expYear = info.expiryYear
    card.cvc = info.cvv
    
    
    STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, error) -> Void in
        
        if error != nil {
            let alertController = UIAlertController(title: "Error", message:
                "Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        self.createBackendChargeWithToken(token!, completion: { (result, error) -> Void in
            if result == STPBackendChargeResult.Success {
                
            }
            else {
               
            }
        })
    })
    
    paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
}



}
