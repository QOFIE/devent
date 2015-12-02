

import UIKit
import Foundation
import MediaPlayer

class MessageViewController: JSQMessagesViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var timer: NSTimer = NSTimer()
    var isLoading: Bool = false
    
    var groupId: String = ""
    var byUserIdForPicture = ""
    var toUserIdForPicture = ""
    var userImage1 = UIImage()
    var userImage2 = UIImage()
    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    
    var blankAvatarImage: JSQMessagesAvatarImage!
    
    var senderImageUrl: String!
    var batchMessages = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.currentUser()
        self.senderId = user!.objectId
        self.senderDisplayName = user?["firstName"] as! String
        
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "Erman"), diameter: 30)
        
        let user1PictureQuery = PFQuery(className: "_User").whereKey("objectId", equalTo: toUserIdForPicture)
        
        if (Reachability.isConnectedToNetwork() == false) {
            user1PictureQuery.fromLocalDatastore()
        }
        
        
        do {
            let abcd = try user1PictureQuery.findObjects()
            
            for action in abcd {
                action.pinInBackground()
                if let userPicture = action.valueForKey("profilePicture") as? PFFile {
                    userPicture.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error NSError) -> Void in
                        self.userImage1 = UIImage(data:imageData!)!
                        
                    })
                }
                
                
            }
            
            
            
        }
        catch{}
        
        
        /*
        user1PictureQuery.findObjectsInBackgroundWithBlock({object, error in
        
        for action in object! {
        action.pinInBackground()
        if let userPicture = action.valueForKey("profilePicture") as? PFFile {
        userPicture.getDataInBackgroundWithBlock({
        (imageData: NSData?, error NSError) -> Void in
        if (error == nil) {
        self.userImage1 = UIImage(data:imageData!)!
        }
        })
        }
        
        
        }
        
        })
        */
        
        let user2PictureQuery = PFQuery(className: "_User").whereKey("objectId", equalTo: byUserIdForPicture)
        
        if (Reachability.isConnectedToNetwork() == false) {
            user2PictureQuery.fromLocalDatastore()
        }
        
        do {
            let abcd = try user2PictureQuery.findObjects()
            
            for action in abcd {
                action.pinInBackground()
                if let userPicture = action.valueForKey("profilePicture") as? PFFile {
                    userPicture.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error NSError) -> Void in
                        self.userImage2 = UIImage(data:imageData!)!
                        
                    })
                }
                
                
            }
            
            
            
        }
        catch{}
        
        
        
        
        /*
        user2PictureQuery.findObjectsInBackgroundWithBlock({object, error in
        
        for action in object! {
        action.pinInBackground()
        if let userPicture = action.valueForKey("profilePicture") as? PFFile {
        userPicture.getDataInBackgroundWithBlock({
        (imageData: NSData?, error NSError) -> Void in
        if (error == nil) {
        self.userImage2 = UIImage(data:imageData!)!
        }
        })
        }
        
        
        }
        
        })
        */
        
        isLoading = false
        self.loadMessages()
        //Messages.clearMessageCounter(groupId);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView!.collectionViewLayout.springinessEnabled = false
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "loadMessages", userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    // Mark: - Backend methods
    
    
    func loadMessages() {
        if self.isLoading == false {
            self.isLoading = true
            let lastMessage = messages.last
            let query = PFQuery(className: "Messages")
            query.whereKey("eventId", equalTo: groupId)
            if lastMessage != nil {
                query.whereKey("createdAt", greaterThan: (lastMessage?.date)!)
            }
            query.orderByDescending("createdAt")
            query.limit = 50
            
            if (Reachability.isConnectedToNetwork() == false) {
                query.fromLocalDatastore()
            }
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.automaticallyScrollsToMostRecentMessage = false
                    for object in Array(Array((objects as [PFObject]!).reverse())) {
                        object.pinInBackground()
                        self.addMessage(object)
                    }
                    if objects!.count > 0 {
                        self.finishReceivingMessage()
                        self.scrollToBottomAnimated(false)
                    }
                    self.automaticallyScrollsToMostRecentMessage = true
                } else {
                    print("Network error")
                }
                self.isLoading = false;
            })
        }
    }
    
    func addMessage(object: PFObject) {
        
        var message: JSQMessage!
        let user = object["userID"] as! String
        let name = user
        
        let videoFile = object["videoMessage"] as? PFFile
        let pictureFile = object["pictureMessage"] as? PFFile
        
        if videoFile == nil && pictureFile == nil {
            message = JSQMessage(senderId: user, senderDisplayName: name, date: object.createdAt, text: (object["textMessage"] as? String))
        }
        
        if videoFile != nil {
            let mediaItem = JSQVideoMediaItem(fileURL: NSURL(string: videoFile!.url!), isReadyToPlay: true)
            message = JSQMessage(senderId: user, senderDisplayName: name, date: object.createdAt, media: mediaItem)
        }
        
        if pictureFile != nil {
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem.appliesMediaViewMaskAsOutgoing = (user == self.senderId)
            message = JSQMessage(senderId: user, senderDisplayName: name, date: object.createdAt, media: mediaItem)
            
            pictureFile!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    mediaItem.image = UIImage(data: imageData!)
                    self.collectionView!.reloadData()
                }
            })
        }
        
        messages.append(message)
    }
    
    func sendMessage(var text: String, video: NSURL?, picture: UIImage?) {
        var videoFile: PFFile!
        var pictureFile: PFFile!
        
        if let video = video {
            text = "[Video message]"
            videoFile = PFFile(name: "video.mp4", data: NSFileManager.defaultManager().contentsAtPath(video.path!)!)
            videoFile.saveInBackgroundWithBlock({ (succeeed: Bool, error: NSError?) -> Void in
                if error != nil {
                    print("Network error")
                }
            })
        }
        
        if let picture = picture {
            text = "[Picture message]"
            pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(picture, 0.6)!)
            pictureFile.saveInBackgroundWithBlock({ (suceeded: Bool, error: NSError?) -> Void in
                if error != nil {
                    print("Picture save error")
                }
            })
        }
        
        let object = PFObject(className: "Messages")
        object["userID"] = PFUser.currentUser()?.objectId
        object["eventId"] = self.groupId
        object["receiverID"] = self.toUserIdForPicture
        object["textMessage"] = text
        if let videoFile = videoFile {
            object["videoMessage"] = videoFile
        }
        if let pictureFile = pictureFile {
            object["pictureMessage"] = pictureFile
        }
        
        if (Reachability.isConnectedToNetwork() == false) {
            
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Please connect to internet to send a message!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
            
        else {
            
            object.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                    self.loadMessages()
                } else {
                    print("Network error")
                }
            }
            
            //PushNotication.sendPushNotification(groupId, text: text)
            //Messages.updateMessageCounter(groupId, lastMessage: text)
            
        }
        
        self.finishSendingMessage()
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        self.sendMessage(text, video: nil, picture: nil)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        let action = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take photo", "Choose existing photo", "Choose existing video")
        action.showInView(self.view)
    }
    
    // MARK: - JSQMessages CollectionView DataSource
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return JSQMessagesAvatarImageFactory.avatarImageWithImage(userImage2, diameter: 30)
        }
        return JSQMessagesAvatarImageFactory.avatarImageWithImage(userImage1, diameter: 30)
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = self.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return nil
            }
        }
        return NSAttributedString(string: "")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            cell.textView?.textColor = UIColor.whiteColor()
        } else {
            cell.textView?.textColor = UIColor.blackColor()
        }
        return cell
    }
    
    // MARK: - UICollectionView flow layout
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return 0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return 0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0
    }
    
    // MARK: - Responding to CollectionView tap events
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        print("didTapLoadEarlierMessagesButton", terminator: "")
    }
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        print("didTapAvatarImageview", terminator: "")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        let message = self.messages[indexPath.item]
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let moviePlayer = MPMoviePlayerViewController(contentURL: mediaItem.fileURL)
                self.presentMoviePlayerViewControllerAnimated(moviePlayer)
                moviePlayer.moviePlayer.play()
            }
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        print("didTapCellAtIndexPath", terminator: "")
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            if buttonIndex == 1 {
                Camera.shouldStartCamera(self, canEdit: true, frontFacing: true)
            } else if buttonIndex == 2 {
                Camera.shouldStartPhotoLibrary(self, canEdit: true)
            } else if buttonIndex == 3 {
                Camera.shouldStartVideoLibrary(self, canEdit: true)
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let video = info[UIImagePickerControllerMediaURL] as? NSURL
        let picture = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.sendMessage("", video: video, picture: picture)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}