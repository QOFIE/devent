
import UIKit

class FeaturedEventsCell: PFTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("denemeCell", forIndexPath: indexPath) as! DenemeCollectionViewCell
        /*
        var featuredEventsArray: [PFObject]?
        let query = PFQuery(className: "Events").whereKey(EVENT.featured, equalTo: true)
        query.findObjectsInBackgroundWithBlock {
            (events: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(events!.count) featured events!")
                // Do something with the found objects
                if events != nil {
                    featuredEventsArray = events!
                    
                    let defaultImage = UIImage(named: "default-event")
                    if let eventImage = featuredEventsArray![indexPath.row][EVENT.image] as? PFFile {
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
        */
        let query = PFQuery(className: "Events").whereKey(EVENT.featured, equalTo: true)
        do {let featuredEventsArray = try query.findObjects()
            let defaultImage = UIImage(named: "default-event")
            if let eventImage = featuredEventsArray[indexPath.row][EVENT.image] as? PFFile {
                eventImage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        cell.featuredEventImage.image = UIImage(data:imageData!)
                    } else {
                        print("Event image cannot be retrieved from the network")
                    }
                }
            
            }} catch {}
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width * 0.8) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }

    
}
