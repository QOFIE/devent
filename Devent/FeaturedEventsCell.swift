
import UIKit

class FeaturedEventsCell: PFTableViewCell, UIScrollViewDelegate  {
    
    
    @IBOutlet weak var featuredEventScrollvIEW: UIScrollView!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1
        
        let query = PFQuery(className: "Events").whereKey(EVENT.featured, equalTo: true)
        do {
            let featuredEventsArray = try query.findObjects()
            for i in 0..<3 {
            if let eventImage = featuredEventsArray[i][EVENT.image] as? PFFile {
                eventImage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.pageImages.append(UIImage(data:imageData!)!)
                    } else {
                        print("Event image cannot be retrieved from the network")
                    }
                }
                print(pageImages)
                }}} catch {}
        
        let pageCount = pageImages.count
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = featuredEventScrollvIEW.frame.size
        featuredEventScrollvIEW.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = featuredEventScrollvIEW.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            featuredEventScrollvIEW.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = featuredEventScrollvIEW.frame.size.width
        let page = Int(floor((featuredEventScrollvIEW.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
}
