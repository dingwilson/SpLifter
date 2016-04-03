//
//  ConfirmationViewController.swift
//  SpLifter
//
//  Created by Wilson Ding on 4/3/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UberRides

class ConfirmationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var image = ""
    var startLat = ""
    var startLong = ""
    var startName = ""
    var endLat = ""
    var endLong = ""
    var endName = ""
    var uberPrice = ""
    var uberDistance = ""
    var otherName = ""
    var otherImage = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    var myRoute : MKRoute!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        let request = MKDirectionsRequest()
        let locationSource = MKPlacemark(coordinate: CLLocationCoordinate2DMake(Double(startLat)!, Double(startLong)!), addressDictionary: nil)
        request.source = MKMapItem(placemark: locationSource)
        let locationDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(Double(endLat)!, Double(endLong)!), addressDictionary: nil)
        request.destination = MKMapItem(placemark: locationDestination)
        request.transportType = MKDirectionsTransportType.Automobile
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        self.mapView.delegate = self
        
        if let checkedUrl = NSURL(string: otherImage) {
            imageView.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl)
        }
        
        name.text = "Name: \(otherName)"
        price.text = "Price: $\(uberPrice)"
        distance.text = "Distance: \(uberDistance) miles"
        
        let button = RequestButton()
        button.setPickupLocation(latitude: Double(startLat)!, longitude: Double(startLong)!, nickname: startName)
        button.setDropoffLocation(latitude: Double(endLat)!, longitude: Double(endLong)!, nickname: endName)
        
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let myLineRenderer = MKPolylineRenderer(polyline: (self.myRoute?.polyline)!)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        self.mapView.centerCoordinate = location.coordinate
        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        self.mapView.setRegion(reg, animated: true)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
