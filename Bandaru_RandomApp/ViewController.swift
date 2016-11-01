//
//  ViewController.swift
//  Bandaru_RandomApp
//
//  Created by Bandaru,Sreekanth on 10/31/16.
//  Copyright © 2016 Bandaru Sreekanth. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    //Connecting tableView in storyBoard to the code
    @IBOutlet weak var tableViewC: UITableView!
    //Stores the length of the array
    @IBOutlet weak var arrayLengthTF: UITextField!
    //Stores the type of data to be retrived
    var range:String = "uint8"
    //Stores the data after parsing JSON data
    var processedData:[UInt] = []
    
    @IBAction func dataTypeSegmentedControl(sender: AnyObject) {
        range = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!
    }
    
    //Triggered when generate button is clicked and makes API calls to the given url
    @IBAction func generate(sender: AnyObject) {
        var url:String!
        if let length = UInt(arrayLengthTF.text!) {
            if length != 0 {
                if range == "uint8" {
                    url = "https://qrng.anu.edu.au/API/jsonI.php?length=\(arrayLengthTF.text!)&type=\(range)"
                }
                else{
                    url = "https://qrng.anu.edu.au/API/jsonI.php?length=\(arrayLengthTF.text!)&type=\(range)"
                }
                let session:NSURLSession = NSURLSession.sharedSession()
                session.dataTaskWithURL( NSURL(string: url)!, completionHandler: processResults).resume()
            }
            else{
                displayMessage("Enter valid array length")
            }
        }
        else{
            displayMessage("Enter valid array length")
        }
    }
    //Handler that is called after data is fetched from url and parses the Json to dictionary
    func processResults( data:NSData?,response:NSURLResponse?,error:NSError?)->Void {
        var randomJSON:AnyObject!
        do {
            try randomJSON =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! AnyObject
            let data = randomJSON["data"]! as! [UInt]
            self.processedData = data
            dispatch_async(dispatch_get_main_queue()){
                NSNotificationCenter.defaultCenter().postNotificationName("Data Delivered", object: nil) // so as to execute on main thread
                self.tableViewC.reloadData()
            }
            
        }
        catch {
            print("Something has gone wrong")
            
        }
    }
    
    //Returns number of sections in table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    //Returns number of rows in a table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return processedData.count
    }
    //Generates data that is to be displayed in each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("random", forIndexPath: indexPath)
        cell.textLabel?.text = String(processedData[indexPath.row])
        
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Pass in a String and it will be displayed in an alert view
    func displayMessage(message:String) {
        let alert = UIAlertController(title: "", message: message,
                                      
                                      preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title:"OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert,animated:true, completion:nil)
    }
}

