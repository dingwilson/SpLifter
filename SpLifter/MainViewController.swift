//
//  MainViewController.swift
//  SpLifter
//
//  Created by Wilson Ding on 4/2/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var locationPin: UIImageView!
    
    var geoCoder : CLGeocoder!
    var locationManager : CLLocationManager!
    var previousAddress : String!
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var image = ""
    var startLat = ""
    var startLong = ""
    var endLat = ""
    var endLong = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        geoCoder = CLGeocoder()
        self.mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    func sendToFirebase() {
        let myDataRef = Firebase(url: "https://splifter.firebaseio.com/")
        let usersRef = myDataRef.childByAppendingPath("users")
        
        let post = ["userId": email, "fullName": "\(firstName) \(lastName)", "imageUrl": image, "userLocation": ["lat": startLat, "long": startLong ], "destinationLocation": ["lat": endLat, "long": endLong]]
        
        let postRef = usersRef.childByAutoId()
        postRef.setValue(post)
    }
    
    func geoCode(location : CLLocation!){
        /* Only one reverse geocoding can be in progress at a time hence we need to cancel existing
         one if we are getting location updates */
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            let address =  addrList.joinWithSeparator(", ")
            self.address.text = address
            self.previousAddress = address
        })
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        self.mapView.centerCoordinate = location.coordinate
        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        self.mapView.setRegion(reg, animated: true)
        geoCode(location)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geoCode(location)
    }
    
    @IBAction func requestButton(sender: AnyObject) {
        if requestButton.titleLabel!.text == "Choose Your Start Location" {
            requestButton.setTitle("Choose Your Destination", forState: UIControlState.Normal)
            
            locationPin.image = UIImage(named: "EndLocationPin")
            
            self.startLat = "\(self.mapView.centerCoordinate.latitude)"
            self.startLong = "\(self.mapView.centerCoordinate.longitude)"
        }

        else {
            self.endLat = "\(self.mapView.centerCoordinate.latitude)"
            self.endLong = "\(self.mapView.centerCoordinate.longitude)"
            
            sendToFirebase()
            
            performSegueWithIdentifier("segueToList", sender: self)
        }
        
    }
    
     // MARK: - Navigation
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToList" {
            let navVC = segue.destinationViewController as! UINavigationController
            
            let sVC = navVC.topViewController as! ListViewController
            
            sVC.firstName = firstName
            sVC.lastName = lastName
            sVC.email = email
            sVC.image = image
            sVC.startLat = startLat
            sVC.startLong = startLong
            sVC.endLat = endLat
            sVC.endLong = endLong
        }
        
     }
    
}