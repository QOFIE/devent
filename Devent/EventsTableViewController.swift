import UIKit

class EventsTableViewController: PFQueryTableViewController, SortingCellDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: PROPOERTIES
    
    // Load featured events separetely into an array (there are only 5 of them!)
    var featuredEvents: [PFObject]?
    var sortType: String?
    var selectedEvent: AnyObject?
    var localStore = [PFObject]()
    var shouldUpdateFromServer:Bool = true
    var locManager = CLLocationManager()
    var categories: [String] {
        get {
            let user = PFUser.currentUser()
            if let selectedCategories = user?.objectForKey(USER.categoryChoices) as? [String] {
                return selectedCategories
            } else {
                return eventCategories
            }
        }
    }
    
    // MARK: ACTIONS
    
    // Define the query that will provide the data for the table view
    
    func baseQuery() -> PFQuery {
        let query = PFQuery(className: "Events")
        query.whereKey(EVENT.featured, equalTo: false)
        query.whereKey(EVENT.type, containedIn: categories)
        query.whereKey(EVENT.date, greaterThanOrEqualTo: NSDate())
        if let sortBy = sortType {
            return query.orderByAscending(sortBy)
        } else {
            return query.orderByAscending(EVENT.popularity)
        }
        
    }
    
    override func queryForTable() -> PFQuery {
        return self.baseQuery().fromLocalDatastore()
    }
    
    func refreshLocalDataStoreFromServer() {
        
        self.baseQuery().findObjectsInBackgroundWithBlock({
            object, error in
            
            PFObject.unpinAllInBackground(self.objects as? [PFObject], block: { (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    
                    if(object != nil) {
                    for action in object! {
                        self.localStore.append(action) }
                    
                    PFObject.pinAllInBackground(self.localStore, block: { (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            // Once we've updated the local datastore, update the view with local datastore
                            self.shouldUpdateFromServer = false
                            self.loadObjects()
                        } else {
                            print("Failed to pin objects")
                        }
                    })
                    
                }
                }
                else {
                    print("Failed to unpin objects")
                }
            })
        })
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        // If we just updated from the server, do nothing, otherwise update from server.
        if self.shouldUpdateFromServer {
            self.refreshLocalDataStoreFromServer()
        } else {
            self.shouldUpdateFromServer = true
        }
    }
    
    func getSortType (sender: PFTableViewCell) -> String {
        var sorting = SortBy.popularity
        if self.sortType != nil {
            sorting = self.sortType!
            loadObjects()
            self.tableView.reloadData()
        }
        return sorting
    }
    
    /*
    override func objectsDidLoad(error: NSError?) {
    // Do any setup when table query objects load
    }
    */
    
    @IBAction func unwindToEventsTableVC (segue: UIStoryboardSegue) {
        // do nothing
    }
    
    // To understand if the user is viewing this page for the first time ever. If yes, set up the event category preferences to default all from viewDidLoad
    
    func isFirstLaunch() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let virgin = defaults.objectForKey("EventsTableVCVirginity") as? Bool {
            if virgin {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    // MARK: TABLEVIEW METHODS
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: PFTableViewCell?
        
        if indexPath.row == 0 {
            if let featuredEventsCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.featured) as? FeaturedEventsCell {
                featuredEventsCell.showDetailDelegate = self
                return featuredEventsCell
            }
        }
            
        else if indexPath.row == 1 {
            if let sortingCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.sorting) as? SortingCell {
                sortingCell.delegate = self
                return sortingCell
            }
        }
            
        else {
            if let eventCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.event) as? EventCell {
                // Extract values from the PFObject to display in the table cell
                if let eventName = object?[EVENT.name] as? String {
                    eventCell.eventTitleLabel.text = eventName
                }
                if let eventDate = object?[EVENT.date] as? String {
                    eventCell.eventDateLabel.text = eventDate
                }
                if let eventAddress = object?[EVENT.address] as? String {
                    eventCell.eventLocationLabel.text = eventAddress
                }
                let defaultImage = UIImage(named: "default-event")
                if let eventImage = object?[EVENT.image] as? PFFile {
                    eventImage.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            let squaredImage = squareImage(UIImage(data:imageData!)!)
                            eventCell.eventImageView.image = squaredImage
                        } else {
                            print("Event image cannot be retrieved from the network")
                        }
                    }
                } else {
                    eventCell.eventImageView.image = defaultImage
                }
                return eventCell
            }
        }
        
        return cell!
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        var obj: PFObject?
        if let index = indexPath?.row, let count = self.objects?.count {
            if (index > 1) && (index < count + 2) {
                obj = self.objects?[(index - 2)] as? PFObject
            }
            
        }
        return obj
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.objects?.count)! + 2)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = self.view.bounds.size.width
        let featuredEventImageAspectRatio: CGFloat = 600 / 328
        switch indexPath.row {
        case 0:
            return width / featuredEventImageAspectRatio
        case 1:
            return UITableViewAutomaticDimension
        default:
            return 80
        }
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row > 1 {
            if let eventToPass = objectAtIndexPath(indexPath) {
                selectedEvent = eventToPass
            }
            performSegueWithIdentifier("EventDetailsSegue", sender: self.navigationController)
        }
    }
    
    
    // MARK: VC LIFECYCLE
    
    override func viewWillAppear(animated: Bool) {
        self.loadObjects()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortType = SortBy.popularity
        
        //initilialize the user
        
        let start = NSDate()
        let enddt = PFUser.currentUser()?.valueForKey("createdAt") as? NSDate
        let calendar = NSCalendar.currentCalendar()
        let datecomponenets = calendar.components(NSCalendarUnit.Second, fromDate: enddt!, toDate: start, options: [])
        let seconds = datecomponenets.second
        
        if(seconds < 60) {
            FetchFacebookProfileData.getDetails()
        }
        
        PFCloud.callFunctionInBackground("hello", withParameters: nil) { results, error in
            if error != nil {
                // Your error handling here
            } else {
                print(results)
            }
        }
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setObject(PFUser.currentUser()!.objectId!, forKey: "userID")
        currentInstallation.saveInBackground()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        
        // Initialize category choices for the first time launch
        
        if isFirstLaunch() {
            let defaults = NSUserDefaults.standardUserDefaults()
            for category in eventCategories {
                defaults.setObject(true, forKey: category)
            }
            defaults.setObject(false, forKey: "EventsTableVCVirginity")
        }
        
    }
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "Events"
        self.textKey = EVENT.name
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        if(PFUser.currentUser()?.objectForKey("locationCity") as? String == nil) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location!) {
                (placemarks, error) -> Void in
                if let placemarks = placemarks as [CLPlacemark]! where placemarks.count > 0 {
                    let placemark = placemarks[0]
                    if (placemark.addressDictionary?["State"] != nil) {
                        let state = placemark.addressDictionary?["State"] as! String
                        if (PFUser.currentUser() != nil) {
                            PFUser.currentUser()!.setObject(state, forKey: "locationCity")
                            PFUser.currentUser()!.setObject((location?.coordinate.latitude.description)!, forKey: "latitude")
                            PFUser.currentUser()!.setObject((location?.coordinate.longitude.description)!, forKey: "longtitude")
                            PFUser.currentUser()!.saveInBackground()
                        }
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    // MARK: NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let edvc = segue.destinationViewController as? EventDetailsTableViewController {

            if(selectedEvent == nil) {
                let event = sender
                edvc.event = event
                
            }
            else {
                
                if let event = selectedEvent {
                    edvc.event = event
                    print ("set the event")
                }
                else {print("patates")}
            }
        }
    }
    
    func fillCollectionView() {
        
        
    
    
    }
    
    
    
}

extension EventsTableViewController: ShowDetailDelegate {
    func showDetail(event: AnyObject){
        print(event)
        selectedEvent = nil
        performSegueWithIdentifier("EventDetailsSegue", sender: event)
    }
}

