//
//  EditProfileTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 30/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: GENERAL PROPERTIES
    
    let user = PFUser.currentUser()
    
    // MARK: GENERAL ACTIONS
    
    
    private func startKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil) //WillShow and not Did ;) The View will run animated and smooth
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func stopKeyboardObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize =    userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.tableView.contentInset = contentInset
                self.tableView.scrollIndicatorInsets = contentInset
                
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, 0 + keyboardSize.height)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize =  userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsZero;
                self.tableView.contentInset = contentInset
                self.tableView.scrollIndicatorInsets = contentInset
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y)
            }
        }
    }
    
    //yenilikleri unutma

    
    @IBAction func saveChanges(sender: UIBarButtonItem) {
        
        // Save the OpenTo preferences
        var openToArray: [String] = []
        if relationshipButtonSelected { openToArray.append(OpenTo.relationship) }
        if datingButtonSelected { openToArray.append(OpenTo.dating) }
        if casualButtonSelected { openToArray.append(OpenTo.casual) }
        if friendshipButtonSelected { openToArray.append(OpenTo.friendship) }
        user?.setObject(openToArray, forKey: USER.openTo)
        
        // Save the height
        if let height = heightLabel.text {
            user?.setObject(height, forKey: USER.height)
        }
        
        user?.saveInBackground()
        
    }
    
    // MARK: DISCOVERY SETTINGS
    
    @IBAction func genderButton(sender: UIButton) {
        let actionSheet = UIAlertController(title: "I am a", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        addGenderAction("Man", actionSheet: actionSheet, sender: sender)
        addGenderAction("Woman", actionSheet: actionSheet, sender: sender)
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel) {
                (action: UIAlertAction) -> Void in
                // do nothing
            }
        )
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func genderInterestedInButton(sender: UIButton) {
        let actionSheet = UIAlertController(title: "Interested in", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        addGenderAction("Man", actionSheet: actionSheet, sender: sender)
        addGenderAction("Woman", actionSheet: actionSheet, sender: sender)
        addGenderAction("Woman", actionSheet: actionSheet, sender: sender)
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel) {
                (action: UIAlertAction) -> Void in
                // do nothing
            }
        )
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    private func addGenderAction(gender: String, actionSheet: UIAlertController, sender: UIButton) {
        actionSheet.addAction(UIAlertAction(
            title: gender,
            style: UIAlertActionStyle.Default) {
                (action: UIAlertAction) -> Void in
                sender.setTitle(gender, forState: UIControlState.Normal)
            }
        )
    }
    
    // MARK: PHOTO SETTINGS
    
    var profilePicture: UIImage!
    
    @IBOutlet weak var profilePictureImageView: UIImageView! {
        didSet {
            if let profilePictureFile = self.user?.objectForKey(USER.profilePicture) as! PFFile? {
                profilePictureFile.getDataInBackgroundWithBlock(){ (imageData: NSData?, error: NSError?) -> Void in
                    if let validImageData = imageData {
                        if let profilePictureFetched = UIImage(data: validImageData) {
                            self.profilePictureImageView.image = squareImage(profilePictureFetched)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: HEIGHT SETTINGS
    
    var currentHeight: String? {
        get {
            return user?.objectForKey(USER.height) as? String
        }
        set {
            heightLabel.text = newValue
        }
    }
    
    @IBOutlet weak var heightLabel: UILabel! {
        didSet {
            heightLabel.text = currentHeight
        }
    }
    
    @IBAction func editHeightButton(sender: UIButton) {
    }
    
    // MARK: ABOUT ME SETTINGS

    @IBOutlet weak var aboutMeTextField: UITextField! {
        didSet {
            if let aboutMe = user?.objectForKey(USER.about) as? String {
                aboutMeTextField.text = aboutMe
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        var newLength = string.characters.count - range.length
        if let currentLength = textField.text?.characters.count {
            newLength += currentLength
        }
        return (newLength <= maxLength) ? true : false
    }

    // MARK: OPEN TO SETTINGS
    
    var relationshipButtonSelected = false
    var datingButtonSelected = false
    var casualButtonSelected = false
    var friendshipButtonSelected = false
    
    let selectedBackgroundColor = UIColor.whiteColor()
    let deselectedBackgroundColor = UIColor.lightGrayColor()
    
    @IBOutlet var openToButtons: [UIButton]! {
        didSet {
            //Initialize the openTo buttons when they are set
            initializeOpenToButtons()
        }
    }
    
    @IBAction func relationshipButton(sender: UIButton) {
        if !relationshipButtonSelected {
            setButtonState(sender, selection: true)
            relationshipButtonSelected = true
        } else {
            setButtonState(sender, selection: false)
            relationshipButtonSelected = false
        }
    }
    @IBAction func datingButton(sender: UIButton) {
        if !datingButtonSelected {
            setButtonState(sender, selection: true)
            datingButtonSelected = true
        } else {
            setButtonState(sender, selection: false)
            datingButtonSelected = false
        }
    }
    @IBAction func casualButton(sender: UIButton) {
        if !casualButtonSelected {
            setButtonState(sender, selection: true)
            casualButtonSelected = true
        } else {
            setButtonState(sender, selection: false)
            casualButtonSelected = false
        }
    }
    @IBAction func friendshipButton(sender: UIButton) {
        if !friendshipButtonSelected {
            setButtonState(sender, selection: true)
            friendshipButtonSelected = true
        } else {
            setButtonState(sender, selection: false)
            friendshipButtonSelected = false
        }
    }
    
    private func fetchOpenToArray() -> [String]? {
        if let openToArrayFetched = user?.objectForKey(USER.openTo) as? [String] {
            return openToArrayFetched
        } else { return nil }
    }
    
    private func initializeOpenToButtons() {
        if let openToArray = fetchOpenToArray() {
            for item in openToArray {
                print("In the openTo switch")
                var i = 100
                switch (item) {
                case OpenTo.casual:
                    casualButtonSelected = true
                    i = 2
                case OpenTo.dating:
                    datingButtonSelected = true
                    i = 1
                case OpenTo.friendship:
                    friendshipButtonSelected = true
                    i = 3
                case OpenTo.relationship:
                    relationshipButtonSelected = true
                    i = 0
                default: break
                }
                if (i < 5) {
                    setButtonState(openToButtons[i], selection: true)
                }
            }
        }
    }
    
    private func setButtonState(button: UIButton, selection: Bool) {
        button.selected = selection
        button.backgroundColor = selection ? selectedBackgroundColor : deselectedBackgroundColor
    }
    
    
    @IBAction func unwindToEditProfileVC(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: VC LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutMeTextField.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        self.startKeyboardObserver()
    }
    override func viewWillDisappear(animated: Bool) {
        self.stopKeyboardObserver()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 { return 3 } else { return 1 }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
