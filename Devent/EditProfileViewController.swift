

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        
        var currentValue = Int(slider.value)
        ageLabel.text = "\(currentValue)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventMatch()
        
        print(PFUser.currentUser()?.objectForKey("firstName"))
        
        if(PFUser.currentUser()?.objectForKey("userAge") != nil)
        {
            let userAge = PFUser.currentUser()?.objectForKey("userAge") as! String
            ageLabel.text = userAge
        }
        
        
        if(PFUser.currentUser()?.objectForKey("firstName") != nil)
        {
        let userFirstName = PFUser.currentUser()?.objectForKey("firstName") as! String
        firstNameTextField.text = userFirstName
        }
        
        if(PFUser.currentUser()?.objectForKey("lastName") != nil)
        {
        let userLastName = PFUser.currentUser()?.objectForKey("lastName") as? String
        lastNameTextField.text = userLastName
        }
        
        if(PFUser.currentUser()?.objectForKey("profilePicture") != nil)
        {
        
        let userImageFile = PFUser.currentUser()?.objectForKey("profilePicture") as! PFFile
        
            userImageFile.getDataInBackgroundWithBlock(
                {(imageData: NSData?, error: NSError?) -> Void in
                    
                    if(imageData != nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                    }
            
            })
        
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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

    @IBAction func logOutaction(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logOutSeque", sender: self)
        
    }
    

    
}
