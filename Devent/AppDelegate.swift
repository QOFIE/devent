//
//  AppDelegate.swift
//  Devent
//
//  Created by Erman Sefer on 16/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("PfsCpWJ98VU24gkNi0kLG7Mzp2rswH0RAxzWTVXb", clientKey: "ngNO5sZZaOFlziDKG0UyVjx6LAW9kaTN7OZhzTb8")
            PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        
        Stripe.setDefaultPublishableKey("pk_test_tXBn3ZaMxvMcbkr8jzwhL1Sk")
        
                return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
}

