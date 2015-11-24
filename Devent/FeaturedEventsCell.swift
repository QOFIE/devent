
import UIKit

class FeaturedEventsCell: PFTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var deneme: UICollectionView!
    var featuredEventsArray: [PFObject]?
    var featuredEventImageArray: [UIImage]?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 500
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("denemeCell", forIndexPath: indexPath) as! DenemeCollectionViewCell
        let defaultImage = UIImage(named: "default-event")
        cell.featuredEventImage.image = defaultImage
        
        let query = PFQuery(className: "Events").whereKey(EVENT.featured, equalTo: true)
        
        if (Reachability.isConnectedToNetwork() == false) {
        query.fromLocalDatastore()
        }
        
        query.findObjectsInBackgroundWithBlock {
            (events: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(events!.count) featured events!")
                // Do something with the found objects
                if events != nil {
                    
                    self.featuredEventsArray = events!
                    
                    PFObject.unpinAllInBackground(events, block: { (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {

                            PFObject.pinAllInBackground(events)
                            
                        }
                        else {
                            print("Failed to unpin objects")
                        }
                    })
                    
                
                    let defaultImage = UIImage(named: "default-event")
                    if let eventImage = self.featuredEventsArray![indexPath.row][EVENT.image] as? PFFile {
                        eventImage.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if (error == nil) {
                                cell.featuredEventImage.image = UIImage(data:imageData!)
                               
                                
                            } else {
                                print("Event image cannot be retrieved from the network")
                            }
                        }
                    } else {
                        cell.featuredEventImage.image = defaultImage
                    }
   
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }


        let delay = 8.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if(indexPath.row < 3) {
            var newIndexPath: NSIndexPath = NSIndexPath(forItem: indexPath.row + 1, inSection: 0)
            self.deneme.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            }
            else {
                self.deneme.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.row - 3, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left , animated: false)
            }
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width * 1) 
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }

    
}
