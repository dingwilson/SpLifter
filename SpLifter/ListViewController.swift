//
//  ListViewController.swift
//  SpLifter
//
//  Created by Wilson Ding on 4/2/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    var rowPressed : Int!

    @IBOutlet weak var tableView: UITableView!
    
    var listArray : [ListItem] = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.getData()
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let myDataRef = Firebase(url: "https://splifter.firebaseio.com/pairs")
        
        listArray = []
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        myDataRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let currentFullName = snapshot.value["currentFullName"] as! String
            let currentImageUrl = snapshot.value["currentImageUrl"] as! String
            let currentUserId = snapshot.value["currentUserId"] as! String
            let destinationLocationClosestLat = snapshot.value["destinationLocationClosestLat"] as! String
            let destinationLocationClosestLong = snapshot.value["destinationLocationClosestLong"] as! String
            let destinationLocationClosestName = snapshot.value["destinationLocationClosestName"] as! String
            let matchedFullName = snapshot.value["matchedFullName"] as! String
            let matchedImageUrl = snapshot.value["matchedImageUrl"] as! String
            let matchedUserId = snapshot.value["matchedUserId"] as! String
            let uberDistance = snapshot.value["uberDistance"] as! String
            let uberPrice = snapshot.value["uberPrice"] as! String
            let userLocationClosestLat = snapshot.value["userLocationClosestLat"] as! String
            let userLocationClosestLong = snapshot.value["userLocationClosestLong"] as! String
            let userLocationClosestName = snapshot.value["userLocationClosestName"] as! String
            
            if currentUserId == self.email || matchedUserId == self.email {
                if currentUserId != matchedUserId {
                    let listItem = ListItem(currentFullName: currentFullName, currentImageUrl: currentImageUrl, currentUserId: currentUserId, destinationLocationClosestLat: destinationLocationClosestLat, destinationLocationClosestLong: destinationLocationClosestLong, destinationLocationClosestName: destinationLocationClosestName, matchedFullName: matchedFullName, matchedImageUrl: matchedImageUrl, matchedUserId: matchedUserId, uberDistance: uberDistance, uberPrice: uberPrice, userLocationClosestLat: userLocationClosestLat, userLocationClosestLong: userLocationClosestLong, userLocationClosestName: userLocationClosestName)
                
                    self.listArray.append(listItem)
                }

            }
        
            self.tableView.reloadData()
        })
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
        
        let listItem = listArray[indexPath.row]
        
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
                    cell.riderImage.image = UIImage(data: data)
                }
            }
        }
        
        if listItem.currentUserId() == email {
            cell.name.text = listItem.matchedFullName()
            otherName = listItem.matchedFullName()
            
            otherImage = listItem.matchedImageUrl()
            
            if let checkedUrl = NSURL(string: listItem.matchedImageUrl()) {
                cell.riderImage.contentMode = .ScaleAspectFit
                downloadImage(checkedUrl)
            }
            
            cell.walkingDistance.text = "Distance: \(listItem.uberDistance()) miles"
            
            cell.cost.text = "Uber Cost: $\(listItem.uberPrice())"
        }
            
        else {
            cell.name.text = listItem.currentFullName()
            otherName = listItem.currentFullName()
            
            otherImage = listItem.matchedImageUrl()
            
            if let checkedUrl = NSURL(string: listItem.currentImageUrl()) {
                cell.riderImage.contentMode = .ScaleAspectFit
                downloadImage(checkedUrl)
            }
            
            cell.walkingDistance.text = "Distance: \(listItem.uberDistance()) miles"
            
            cell.cost.text = "Uber Cost: $\(listItem.uberPrice())"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowPressed = indexPath.row
        print(rowPressed)
        startName = listArray[rowPressed].userLocationClosestName()
        endName = listArray[rowPressed].destinationLocationClosestName()
        
        uberPrice = listArray[rowPressed].uberPrice()
        uberDistance = listArray[rowPressed].uberDistance()
        
        performSegueWithIdentifier("tableViewCellPressedSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "tableViewCellPressedSegue") {
            let sVC = segue.destinationViewController as! ConfirmationViewController
            
            sVC.firstName = firstName
            sVC.lastName = lastName
            sVC.email = email
            sVC.image = image
            sVC.startLat = startLat
            sVC.startLong = startLong
            sVC.startName = startName
            sVC.endLat = endLat
            sVC.endLong = endLong
            sVC.endName = endName
            sVC.uberPrice = uberPrice
            sVC.uberDistance = uberDistance
            sVC.otherName = otherName
            sVC.otherImage = otherImage
        }
    }

}
