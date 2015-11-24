//
//  PhotoGalleryViewController.swift
//  Devent
//
//  Created by Erman Sefer on 06/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UIViewController, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageDeleteButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var imagesForSection0: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photo Gallery"
        let nib = UINib(nibName: "verticalCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
                if let userPicture1Data = PFUser.currentUser()?.valueForKey("profilePicture") as? PFFile {
                    userPicture1Data.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error NSError) -> Void in
                        if (imageData != nil) {
                            //let userImage1 = UIImage(data:imageData!)!
                            self.imagesForSection0.append(UIImage(data:imageData!)!)
                        }
                    })
                }
                
                if let userPicture2Data = PFUser.currentUser()?.valueForKey("P2") as? PFFile {
                    userPicture2Data.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error NSError) -> Void in
                        if (imageData != nil) {
                            //let userImage2 = UIImage(data:imageData!)!
                            self.imagesForSection0.append(UIImage(data:imageData!)!)
                        }
                    })
                }
                
                if let userPicture3Data = PFUser.currentUser()?.valueForKey("P3") as? PFFile {
                    userPicture3Data.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error NSError) -> Void in
                        if (imageData != nil) {
                            //let userImage3 = UIImage(data:imageData!)!
                            self.imagesForSection0.append(UIImage(data:imageData!)!)
                            }
                    })
                }
                
                if let userPicture4Data = PFUser.currentUser()?.valueForKey("P4") as? PFFile {
                    userPicture4Data.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error NSError) -> Void in
                        if (imageData != nil) {
                            //let userImage4 = UIImage(data:imageData!)!
                            self.imagesForSection0.append(UIImage(data:imageData!)!)
                        }
                    })
                }
                
                if let userPicture5Data = PFUser.currentUser()?.valueForKey("P5") as? PFFile {
                    userPicture5Data.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error NSError) -> Void in
                        if (imageData != nil) {
                            //let userImage5 = UIImage(data:imageData!)!
                            self.imagesForSection0.append(UIImage(data:imageData!)!)
                        }
                    })
                }
                
       print(imagesForSection0.count)
       self.collectionView.reloadData()
       
    }

    
    override func viewDidAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0)
    }
    
    // RAReorderableLayout delegate datasource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let threePiecesWidth = floor(screenWidth / 3.0 - ((2.0 / 3) * 2))
        let twoPiecesWidth = floor(screenWidth / 2.0 - (2.0 / 2))
        if indexPath.section == 0 {
            return CGSizeMake(threePiecesWidth, threePiecesWidth)
        }else {
            return CGSizeMake(twoPiecesWidth, twoPiecesWidth)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
            return self.imagesForSection0.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath) as! RACollectionViewCell
        
            print(imagesForSection0.count)
        
            cell.imageView.image = self.imagesForSection0[indexPath.row]
        
            if self.imageDeleteButton.title == "Delete" {
            cell.deleteButton.hidden = true
            
            }   else {
        
                 cell.deleteButton.hidden = false
             }

        
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton.addTarget(self, action: "deletePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, allowMoveAtIndexPath indexPath: NSIndexPath) -> Bool {
        if collectionView.numberOfItemsInSection(indexPath.section) <= 1 {
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
        var photo: UIImage
     
            photo = self.imagesForSection0.removeAtIndex(atIndexPath.item)
            self.imagesForSection0.insert(photo, atIndex: toIndexPath.item)
       
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
    }
    
    func collectionView(collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
      
            return 0
        
    }
    
    func scrollTrigerPaddingInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.collectionView.contentInset.bottom, 0)
    }
    
    
    @IBAction func addPhoto(sender: AnyObject) {
        
        if imagesForSection0.count < 5 {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        }
        
        else {
            let alertController = UIAlertController(title: "Picture Limit", message:
                "You can't add more than 5 pictures", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
   
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        self.imagesForSection0.append((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
  
    @IBAction func deletePhotoAction(sender: AnyObject) {
        
        if self.imageDeleteButton.title == "Delete" {
        
            self.imageDeleteButton.title = "Done"
        
        } else {
        
        self.imageDeleteButton.title = "Delete"
        
        }
        
        self.collectionView.reloadData()
    }
    

    @IBAction func savePhoto(sender: AnyObject) {

        print(imagesForSection0.count)
        if imagesForSection0.count == 1 {
            let P1Imagedata = UIImageJPEGRepresentation(imagesForSection0[0], 1)
            
            if(P1Imagedata != nil) {
                let P1FileObject = PFFile(data:P1Imagedata!)
                PFUser.currentUser()!.setObject(P1FileObject!, forKey: "profilePicture")
                PFUser.currentUser()!.removeObjectForKey("P2")
                PFUser.currentUser()!.removeObjectForKey("P3")
                PFUser.currentUser()!.removeObjectForKey("P4")
                PFUser.currentUser()!.removeObjectForKey("P5")
                PFUser.currentUser()!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
            }
        }
        
        else if imagesForSection0.count == 2 {
            let P1Imagedata = UIImageJPEGRepresentation(imagesForSection0[0], 1)
            let P2Imagedata = UIImageJPEGRepresentation(imagesForSection0[1], 1)
            
            if(P1Imagedata != nil && P2Imagedata != nil) {
                let P1FileObject = PFFile(data:P1Imagedata!)
                let P2FileObject = PFFile(data:P2Imagedata!)
                PFUser.currentUser()!.setObject(P1FileObject!, forKey: "profilePicture")
                PFUser.currentUser()!.setObject(P2FileObject!, forKey: "P2")
                PFUser.currentUser()!.removeObjectForKey("P3")
                PFUser.currentUser()!.removeObjectForKey("P4")
                PFUser.currentUser()!.removeObjectForKey("P5")
                PFUser.currentUser()!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
            }
        }
        
        else if imagesForSection0.count == 3 {
            let P1Imagedata = UIImageJPEGRepresentation(imagesForSection0[0], 1)
            let P2Imagedata = UIImageJPEGRepresentation(imagesForSection0[1], 1)
            let P3Imagedata = UIImageJPEGRepresentation(imagesForSection0[2], 1)
            
            if(P1Imagedata != nil && P2Imagedata != nil && P3Imagedata != nil) {
                let P1FileObject = PFFile(data:P1Imagedata!)
                let P2FileObject = PFFile(data:P2Imagedata!)
                let P3FileObject = PFFile(data:P3Imagedata!)
                
                PFUser.currentUser()!.setObject(P1FileObject!, forKey: "profilePicture")
                PFUser.currentUser()!.setObject(P2FileObject!, forKey: "P2")
                PFUser.currentUser()!.setObject(P3FileObject!, forKey: "P3")
                PFUser.currentUser()!.removeObjectForKey("P4")
                PFUser.currentUser()!.removeObjectForKey("P5")
                PFUser.currentUser()!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
            }
        }
        
        else if imagesForSection0.count == 4 {
            let P1Imagedata = UIImageJPEGRepresentation(imagesForSection0[0], 1)
            let P2Imagedata = UIImageJPEGRepresentation(imagesForSection0[1], 1)
            let P3Imagedata = UIImageJPEGRepresentation(imagesForSection0[2], 1)
            let P4Imagedata = UIImageJPEGRepresentation(imagesForSection0[3], 1)
            
            if(P1Imagedata != nil && P2Imagedata != nil && P3Imagedata != nil && P4Imagedata != nil) {
                let P1FileObject = PFFile(data:P1Imagedata!)
                let P2FileObject = PFFile(data:P2Imagedata!)
                let P3FileObject = PFFile(data:P3Imagedata!)
                let P4FileObject = PFFile(data:P4Imagedata!)
                
                PFUser.currentUser()!.setObject(P1FileObject!, forKey: "profilePicture")
                PFUser.currentUser()!.setObject(P2FileObject!, forKey: "P2")
                PFUser.currentUser()!.setObject(P3FileObject!, forKey: "P3")
                PFUser.currentUser()!.setObject(P4FileObject!, forKey: "P4")
                PFUser.currentUser()!.removeObjectForKey("P5")
                PFUser.currentUser()!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
            }
        }
        
        else {
            let P1Imagedata = UIImageJPEGRepresentation(imagesForSection0[0], 1)
            let P2Imagedata = UIImageJPEGRepresentation(imagesForSection0[1], 1)
            let P3Imagedata = UIImageJPEGRepresentation(imagesForSection0[2], 1)
            let P4Imagedata = UIImageJPEGRepresentation(imagesForSection0[3], 1)
            let P5Imagedata = UIImageJPEGRepresentation(imagesForSection0[4], 1)
            
            if(P1Imagedata != nil && P2Imagedata != nil && P3Imagedata != nil && P4Imagedata != nil && P5Imagedata != nil) {
                let P1FileObject = PFFile(data:P1Imagedata!)
                let P2FileObject = PFFile(data:P2Imagedata!)
                let P3FileObject = PFFile(data:P3Imagedata!)
                let P4FileObject = PFFile(data:P4Imagedata!)
                let P5FileObject = PFFile(data:P5Imagedata!)
                
                PFUser.currentUser()!.setObject(P1FileObject!, forKey: "profilePicture")
                PFUser.currentUser()!.setObject(P2FileObject!, forKey: "P2")
                PFUser.currentUser()!.setObject(P3FileObject!, forKey: "P3")
                PFUser.currentUser()!.setObject(P4FileObject!, forKey: "P4")
                PFUser.currentUser()!.setObject(P5FileObject!, forKey: "P5")
                PFUser.currentUser()!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
            }
        }

        
    }
    
    
    func deletePhoto(sender:UIButton) {
        let i : Int = (sender.layer.valueForKey("index")) as! Int
        self.imagesForSection0.removeAtIndex(i)
        self.collectionView!.reloadData()
    }

}

class RACollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var deleteButton: UIButton!
    var gradientLayer: CAGradientLayer?
    var hilightedCover: UIView!
    override var highlighted: Bool {
        didSet {
            self.hilightedCover.hidden = !self.highlighted
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.hilightedCover.frame = self.bounds
        self.applyGradation(self.imageView)
    }
    
    private func configure() {
        self.imageView = UIImageView()
        self.imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView)
        
        self.deleteButton = UIButton()
        self.deleteButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.deleteButton.frame = CGRectMake(0, 0, 30, 30)
        //self.deleteButton.backgroundColor = UIColor.whiteColor()
        self.deleteButton.imageView?.contentMode = UIViewContentMode.ScaleToFill
        self.addSubview(deleteButton)
        
        self.hilightedCover = UIView()
        self.hilightedCover.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.hilightedCover.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.hilightedCover.hidden = true
        self.addSubview(self.hilightedCover)
        
    
        self.bringSubviewToFront(deleteButton)
        
    }
    
    private func applyGradation(gradientView: UIView!) {
        self.gradientLayer?.removeFromSuperlayer()
        self.gradientLayer = nil
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer!.frame = gradientView.bounds
        
        let mainColor = UIColor(white: 0, alpha: 0.3).CGColor
        let subColor = UIColor.clearColor().CGColor
        self.gradientLayer!.colors = [subColor, mainColor]
        self.gradientLayer!.locations = [0, 1]
        
        gradientView.layer.addSublayer(self.gradientLayer!)
    }
    
    
    
}

