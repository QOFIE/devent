//
//  FetchFacebookProfileFile.swift
//  Devent
//
//  Created by Erman Sefer on 29/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

public class FetchFacebookProfileData {
    
    class func getDetails() {
        
        var requestParameters = ["fields": "id, email, first_name, last_name, gender, about, locale, work, birthday, location, education"]
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
            
            if(error != nil)
            {
                print("\(error.localizedDescription)")
                return
            }
            
            if(result != nil)
            {
                //deneme
                let userId:String = result["id"] as! String
                let userFirstName:String? = result["first_name"] as? String
                let userLastName:String? = result["last_name"] as? String
                let userEmail:String? = result["email"] as? String
                let userGender:String? = result["gender"] as? String
                let userAboutMe:String? = result["about"] as? String
                let userLocale:String? = result["locale"] as? String
                let userWork1: NSArray? = result["work"] as? NSArray
                let userWork2 = userWork1?.valueForKey("employer")
                let userWork3 = userWork2?.valueForKey("name") as? NSArray
                let userBDay:String? = result["birthday"] as? String
                let calendar : NSCalendar = NSCalendar.currentCalendar()
                let now = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let dateFromString = dateFormatter.dateFromString(userBDay!)
                let ageComponents = calendar.components(.Year,
                    fromDate: dateFromString!,
                    toDate: now,
                    options: [])
                
                let userAge = String(ageComponents.year)
                let location = result.objectForKey("location")
                let city = location?.objectForKey("name")
                let delimiter = ","
                let userCity = city!.componentsSeparatedByString(delimiter)
                
                let userSchool1: NSArray? = result["education"] as? NSArray
                let userSchool2 = userSchool1?.lastObject
                let userSchool3 = userSchool2?.valueForKey("school")
                let userSchool4 = userSchool3?.valueForKey("name") as? String
                
                let myUser:PFUser = PFUser.currentUser()!
                
                // Save school
                if(userSchool4 != nil)
                {
                    myUser.setObject(userSchool4!, forKey: "education")
                    
                }
                
                // Save location
                if(userCity.isEmpty == false)
                {
                    myUser.setObject(userCity[0], forKey: "locationCity")
                    
                }
                
                // Save age
                if(ageComponents.year != 0)
                {
                    myUser.setObject(userAge, forKey: "userAge")
                    
                }
                
                // Save work
                if(userWork3 != nil)
                {
                    myUser.setObject(userWork3![0], forKey: "work")
                    
                }
                
                
                // Save about_me
                if(userAboutMe != nil)
                {
                    myUser.setObject(userAboutMe!, forKey: "about")
                    
                }
                
                // Save gender
                if(userGender != nil)
                {
                    myUser.setObject(userGender!, forKey: "gender")
                    
                }
                
                
                // Save first name
                if(userFirstName != nil)
                {
                    myUser.setObject(userFirstName!, forKey: "firstName")
                    
                }
                
                //Save last name
                if(userLastName != nil)
                {
                    myUser.setObject(userLastName!, forKey: "lastName")
                }
                
                // Save email address
                if(userEmail != nil)
                {
                    myUser.setObject(userEmail!, forKey: "email")
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    // Get Facebook profile picture
                    var userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    
                    let profilePictureUrl = NSURL(string: userProfile)
                    
                    let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                    
                    if(profilePictureData != nil)
                    {
                        let profileFileObject = PFFile(data:profilePictureData!)
                        myUser.setObject(profileFileObject!, forKey: "profilePicture")
                    }
                    
                    
                    myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        
                        if(success)
                        {
                            print("User details are now updated")
                        }
                        
                    })
                    
                }
                
            }
            
        }
        
        
        
    }
    
    
}