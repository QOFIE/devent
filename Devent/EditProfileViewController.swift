

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
/*
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

*/
/*
    

    @IBAction func chooseProfilePictureButton(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profilePicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    @IBAction func saveButton(sender: AnyObject) {
        
        let myUser = PFUser.currentUser()!
        let profileImagedata = UIImageJPEGRepresentation(profilePicture.image!, 1)
        
        let userFirstName = firstNameTextField.text
        let userLastName = lastNameTextField.text
        let userAge = ageLabel.text
        
        myUser.setObject(userFirstName!, forKey: "firstName")
        myUser.setObject(userLastName!, forKey: "lastName")
        myUser.setObject(userAge!, forKey: "userAge")
        
         if(profileImagedata != nil) {
            let profileFileObject = PFFile(data:profileImagedata!)
            myUser.setObject(profileFileObject!, forKey: "profilePicture")
        
        }
        
        myUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        
        }
        
        self.performSegueWithIdentifier("eventsSeque", sender: self)
        
    }

*/


    
}
