//
//  view.swift
//  soscore
//
//  Created by Rohit Jenveja on 6/21/14.
//  Copyright (c) 2014 Rohit Jenveja. All rights reserved.
//

import Foundation

import UIKit

// temporary until we have a proper backend.
var users : String[] = ["rohitj"]


// put this in a separate file, once xcode beta is not buggy.
class DetailedView : UIView {
    
    @IBOutlet var user: UILabel!
    
    @IBOutlet var view: DetailedView!
    func populateUser (user : String) {
        self.user.text = user
    }
}

// put this in a separate file
class CustomCellView : UITableViewCell, UITextFieldDelegate {
    
    let medOrange:UIColor = UIColor(red: 0.973, green: 0.338, blue: 0.173, alpha: 1)

    @IBOutlet var view : UIView!
    @IBOutlet var customCell : UITextField!
    
    override func layoutSubviews()  {
       self.customCell.delegate = self
       self.customCell.returnKeyType = UIReturnKeyType.Done
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func canBecomeFirstResponder() -> Bool  {
        println("boom")
        return true
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        println("test-touchesbegan")
        self.customCell.endEditing(false)
    }
    
     func textFieldShouldReturn() -> Bool {
        return false
    }
}

// look in to having a helper file for utility functions like this?
func getData(temp_users : String[]) -> Array<Array<String>> {
    
    var urls : NSURL[] = []
    var table = Array<Array<String>>()
    
    for user in temp_users {
        var temp = "http://api.stackexchange.com/2.2/users?order=desc&sort=reputation&inname=\(user)&site=stackoverflow";
        var url: NSURL = NSURL(string: temp)
        urls.append(url)
    }
    
    
    
    for url in urls {
        // var tempResult : NSDictionary = getDataFromStack(url) as
        table += parseResult(getDataFromStack(url))
    }
    
    return table
    
}

func getDataFromStack (url: NSURL) -> NSDictionary {
    var request1: NSURLRequest = NSURLRequest(URL: url)
    var response: AutoreleasingUnsafePointer<NSURLResponse?
    >=nil
    
    var error: AutoreleasingUnsafePointer<NSErrorPointer?>=nil
    
    var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)
    
    var err: NSError
    var data = NSDictionary()

    data = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, Any>
    return data
}

// function is ugly as hell. refactor.
func parseResult(result : NSDictionary) -> Array<String> {
    var table = Array<String>()

    if let items = result["items"] as? Array<Dictionary<String, AnyObject
        >> {
            for memberItem in items {
                if let displayObj : AnyObject? = memberItem["display_name"]  {
                    if let displayString = displayObj as? String {
                        for user in users {
                            if user == displayString.lowercaseString {
                                if let scoreObj : AnyObject? = memberItem["reputation"] {
                                    if let scoreString = scoreObj as? Int {
                                        table += [user, String(scoreString)]
                                        println(user)
                                        println(scoreString)
                                    }
                                }
                                break
                            }
                        }
                    }
                }
            }
    }
    return table
}

class ViewController: UITableViewController, UITableViewDataSource {
 
    var table : Array<Array<String>> = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        table = getData(users);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(style: .Plain)
        self.title = "Plain Table"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return table.count + 1
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        if (indexPath?.row == table.count) {
            return false;
        }
        return true;
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        if (indexPath.row > 0) {
    let customNib:Array=NSBundle.mainBundle().loadNibNamed("DetailedView", owner: self, options: nil)
            var detailedView : DetailedView = customNib[0] as DetailedView
            detailedView.tag = 11
            detailedView.populateUser(table[indexPath.row-1][0])
            tableView.addSubview(detailedView)
        }
    }
        
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //table.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
     }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var number = table.count
        
        if indexPath?.row == 0 {
            var cell : CustomCellView! = tableView.dequeueReusableCellWithIdentifier("CustomCellView") as? CustomCellView
            if (cell == nil) {
                let customNib:Array=NSBundle.mainBundle().loadNibNamed("CustomCellView", owner: self, options: nil)
                cell = customNib[0] as? CustomCellView
            }
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CELL")
            }
            let row = indexPath.row - 1
            println(table)
            cell!.textLabel.text = table[row][0]
            //cell!.textLabel.text = table[row][0]
            cell!.detailTextLabel.text = table[row][1]
            
            
            let url = NSURL.URLWithString("http://graph.facebook.com/2201571/picture?type=large");
            var err: NSError?
            var imageData :NSData = NSData.dataWithContentsOfURL(url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            
            var image : UIImage = UIImage(data:imageData)
            cell.imageView.image = image
            return cell
        }
    }
}