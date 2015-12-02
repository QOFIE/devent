//
//  ProfileLocationViewController.swift
//  Devent
//
//  Created by Erman Sefer on 30/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ProfileLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

  
    @IBOutlet weak var map: MKMapView!
    
    var user = PFUser.currentUser()
    
    let locationManager = CLLocationManager()
    var finalAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let uilgr = UITapGestureRecognizer(target: self, action: "addAnnotation:")
        uilgr.numberOfTapsRequired = 1
        uilgr.numberOfTouchesRequired = 1
        map.addGestureRecognizer(uilgr)
        
    }
    
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        let annotationsToRemove = map.annotations.filter { $0 !== map.userLocation }
        map.removeAnnotations(annotationsToRemove )
        let touchPoint = gestureRecognizer.locationInView(map)
        let newCoordinates = map.convertPoint(touchPoint, toCoordinateFromView: map)
        finalAnnotation.coordinate = newCoordinates
        self.map.addAnnotation(finalAnnotation)
        self.setUsersClosestCity()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.map.setRegion(region, animated: true)
        finalAnnotation.coordinate = center
        self.setUsersClosestCity()
        self.map.addAnnotation(finalAnnotation)
        self.locationManager.stopUpdatingLocation()
    }
    
    func setUsersClosestCity()
    {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: finalAnnotation.coordinate.latitude, longitude: finalAnnotation.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            if let placemarks = placemarks as [CLPlacemark]! where placemarks.count > 0 {
                let placemark = placemarks[0]
                print(placemark)
                if (placemark.addressDictionary?["State"] != nil) {
                let state = placemark.addressDictionary?["State"] as! String
                self.user!.setObject(state, forKey: "locationCity")
                self.user!.setObject(self.finalAnnotation.coordinate.latitude.description, forKey: "latitude")
                self.user!.setObject(self.finalAnnotation.coordinate.longitude.description, forKey: "longtitude")
                self.user!.saveInBackground()
                }
            }
        }
    }


   

}
