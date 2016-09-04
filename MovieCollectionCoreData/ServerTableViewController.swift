//
//  ServerTableViewController.swift
//  MovieCollectionCoreData
//
//  Created by Shweta Murthy on 4/18/16.
//  Copyright © 2016 Shweta Murthy. All rights reserved.
//  Created by Shweta Murthy on 4/18/16.
//  Copyright © 2016 Shweta Murthy.
//  The instuctor and the University are provided the right to build and evaluate the software package for
//  the purpose of determining grade and program assessment.
//  Created by Shweta Murthy on 4/4/16.mailto:smurthy3@asu.edu.

import Foundation
import UIKit
class ServerTableViewController: UITableViewController {
    var parent: MovieColTabController!
    let urlString:String = "http://localhost:8080"
    var movies:[String]=[String]()
    var newMovie: String = ""
    var m1: Movie = Movie()
    override func viewDidLoad() {
        super.viewDidLoad()
        let aConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
        print("callGetNamesUpdateStudentsPicker called")
        let result1Names:Bool = aConnect.resetFromJsonFile({ (res: String, err: String?)-> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                print("reset done")
                let resutNames:Bool = aConnect.getTitles({ (res: String, err: String?) -> Void in
                    if err != nil {
                        NSLog(err!)
                    }else{
                        NSLog(res)
                        print("result printed")
                        if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                            do{
                                let dict = try NSJSONSerialization.JSONObjectWithData(data,options:.MutableContainers) as?[String:AnyObject]
                                self.movies = (dict!["result"] as? [String])!
                                print(self.movies)
                                self.tableView.reloadData()
                            }
                            catch {
                                print("unable to convert to dictionary")
                            }
                        }
                        
                    }
                })
                
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NSLog("viewDidLoad in movie view controller")
        
        navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        self.title = "Movie List"
        /* let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "insertMovie")
        self.navigationItem.rightBarButtonItem = addButton
        newyork = Waypoint(name:"New York", comment:"The Big Apple", lat: 40.7127, lon: -74.0059)
        poly = Waypoint(name:"ASU-Poly", comment:"Polytechnic campus", lat:33.3056, lon: -111.6788)
        tempe = Waypoint(name:"ASU-Tempe", comment:"The Brickyard", lat:33.4235, lon: -111.9389)
        waypoints = ["New York":newyork, "ASU-Poly":poly, "ASU-Tempe":tempe]
        names = ["New York", "ASU-Poly", "ASU-Tempe"]
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "insertWaypoint")
        self.navigationItem.rightBarButtonItem = addButton
        
        }
        */
    }
    
    func insertMovie(){
        NSLog("insertMovie called")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(movies.count)
        return movies.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("serverCell", forIndexPath: indexPath)
        //let title: [String: MovieDescription] = l.get()
        //var name: [String] = [String]()
        //for names in title.keys{
        //  name.append(names)
        //}
        
        
        //let aWaypoint = waypoints[names[indexPath.row]]! as Waypoint
        //cell.textLabel?.text = name[indexPath.row]
        //print(indexPath.row)
        //cell.detailTextLabel?.text = aWaypoint.comment
        NSLog("in tableview")
        cell.textLabel?.text = movies[indexPath.row]
        print("The row being returned is " ,movies[indexPath.row])
        //cell.detailTextLabel?.text = aWaypoint.comment
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
   /* override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete the row from the data source
            NSLog("Delete called")
            /*for names in list.keys{
            name.append(names)
            }
            l.remove(name[indexPath.row])*/
            var removeMovie: String = movies[indexPath.row]
            
            let aConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
            print("remove is being called")
            let resultNames:Bool = aConnect.remove(removeMovie, callback:{ (res: String, err: String?)-> Void in
                if err != nil {
                    NSLog(err!)
                }else{
                    NSLog(res)
                    print("remove done")
                    print("calling reset")
                    self.movies.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                }
            })
            
            
            
        } else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }*/
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }
    
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        NSLog("seque identifier is \(segue.identifier)")
        if segue.identifier == "serverShow" {
            let viewController: serverShowController = segue.destinationViewController as! serverShowController
            print(segue.destinationViewController)
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.movie = movies[indexPath.row]
            viewController.pparent = self.parent
            print("done till here")
            
            /*let list = l.get()
            var name: [String] = [String]()
            for names in list.keys{
            name.append(names)
            }
            print("sending values"+name[indexPath.row])
            print(segue.destinationViewController)
            viewController.selected = list
            viewController.index = name[indexPath.row]*/
        }
        /*else if segue.identifier == "addSegue" {
            print("in addsegue")
            let viewController: AddMe = segue.destinationViewController as! AddMe
            print(viewController.description)
            viewController.parent = self
            //viewController.movies = self.movies
            
        }*/
        
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
        
        // Pull any data from the view controller which initiated the unwind segue.
        print("OK clicked")
        //print(l.get().keys)
        let aConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
        let resGet:Bool = aConnect.add(m1, callback:{ (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                print("Result for Adding")
                
                let resultNames:Bool = aConnect.getTitles({ (res: String, err: String?) -> Void in
                    if err != nil {
                        NSLog(err!)
                    }else{
                        NSLog(res)
                        print("result printed")
                        if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                            do{
                                let dict = try NSJSONSerialization.JSONObjectWithData(data,options:.MutableContainers) as?[String:AnyObject]
                                self.movies = (dict!["result"] as? [String])!
                                print(self.movies)
                                self.tableView.reloadData()
                            }
                            catch {
                                print("unable to convert to dictionary")
                            }
                        }
                        
                    }
                })
                
                
            }
        })
        
        
        
        
    }
    
    @IBAction func unwindFromCancel(sender: UIStoryboardSegue)
    {
        
        // Pull any data from the view controller which initiated the unwind segue.
        print("Cancel clicked")
    }
  
    

}