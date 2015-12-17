//
//  EditProfileTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 30/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

// TO DO:
// 1) Add Events
// 2) Add Tags


class EditProfileTableViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: GENERAL PROPERTIES //
    
    let user = PFUser.currentUser()
    var gender: String?
    var genderInterestedIn: String?
    
    // MARK: GENERAL ACTIONS //
    
    @IBAction func unwindToEditProfileVC(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    private func startKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
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
        
        // Save the about me text
        if aboutMeDidChange {
            user?.setObject(aboutMeTextView.text, forKey: USER.about)
        }
        
        // Save the gender
        if let genderInput = self.gender {
            user?.setObject(genderInput, forKey: "gender")
        }
        
        // Save the gender interested in 
        if let genderInterestedInInput = self.genderInterestedIn {
            user?.setObject(genderInterestedInInput, forKey: "genderInterestedIn")
        }
        
        user?.saveInBackground()
        
    }
    
    // MARK: DISCOVERY SETTINGS //
    
    @IBAction func genderButton(sender: UIButton) {
        let actionSheet = UIAlertController(title: "I am a", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        addGenderAction(Gender.man, actionSheet: actionSheet, sender: sender)
        addGenderAction(Gender.woman, actionSheet: actionSheet, sender: sender)
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
        addGenderAction(Gender.man, actionSheet: actionSheet, sender: sender)
        addGenderAction(Gender.woman, actionSheet: actionSheet, sender: sender)
        addGenderAction(Gender.both, actionSheet: actionSheet, sender: sender)
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
                if actionSheet.title == "I am a" {
                    self.gender = gender
                } else if actionSheet.title == "Interested in" {
                    self.genderInterestedIn = gender
                }
            }
        )
    }
    
    // MARK: PHOTO SETTINGS //
    
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
    
    
    // MARK: LOCATION EDIT BUTTON
    
    
    
    
    
    
    // MARK: HEIGHT SETTINGS //
    
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
            if let height = currentHeight {
                heightLabel.text = height
            } else {
                heightLabel.text = "Not specified"
            }
        }
    }
    
    @IBAction func editHeightButton(sender: UIButton) {
    }
    
    // MARK: ABOUT ME SETTINGS //
    
    var aboutMeDidChange = false
    var characterLimit = 140
    
    @IBOutlet weak var aboutMeTextView: UITextView! {
        didSet {
            if let aboutMe = user?.objectForKey(USER.about) as? String {
                print("About me \(aboutMe)")
                if aboutMe.characters.count <= characterLimit {
                    aboutMeTextView.text = aboutMe
                }
            }
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        // do nothing
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        aboutMeDidChange = true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newLength = text.characters.count - range.length
        if let currentLength = textView.text?.characters.count {
            newLength += currentLength
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return (newLength <= characterLimit) ? true : false
    }
    
    // MARK: OPEN TO SETTINGS //
    
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
    
    
    // MARK: VC LIFECYCLE //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutMeTextView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
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

        let cell = tableView.dequeueReusableCellWithIdentifier("AgeRange", forIndexPath: indexPath) as! AgeRangeTableViewCell
        if let maxAge = user?.objectForKey(USER.maxAge) as? Int{
            if let minAge = user?.objectForKey(USER.minAge) as? Int {
                cell.maxAge = maxAge
                cell.minAge = minAge
            }
        }
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
