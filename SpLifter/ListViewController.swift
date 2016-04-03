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

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
        /*
        let foodItem = foodArray[indexPath.row]
        
        cell.name.text = "\(foodItem.name())"
        
        cell.count.text = "Count: \(foodItem.count())"
        
        let url = NSURL(string:"\(foodItem.imageURL())")
        
        let data = NSData(contentsOfURL:url!)
        
        if data != nil {
            cell.photo.image = UIImage(data:data!)
        }*/
        
        return cell
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
