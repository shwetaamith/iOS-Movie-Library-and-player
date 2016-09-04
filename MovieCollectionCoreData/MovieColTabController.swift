//
//  MovieColTabController.swift
//  MovieCollectionCoreData
//  Copyright © 2016 Shweta Murthy.
//  The instuctor and the University are provided the right to build and evaluate the software package for
//  the purpose of determining grade and program assessment.
//  Created by Shweta Murthy on 4/4/16.mailto:smurthy3@asu.edu.


import Foundation
import UIKit
import CoreData


class MovieColTabController: UITableViewController{
    var dict: NSDictionary = NSDictionary()
    var movies = [NSManagedObject]()
    var firstNameValue: String = String()
    var m1:Movie = Movie()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialize()
        updateData()
        NSLog("In movietable viewdidload")
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return movies.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("ReuseIdentifier")
            
            let movie = movies[indexPath.row]
            
            cell!.textLabel!.text =
                movie.valueForKey("name") as? String
            
            return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        NSLog("seque identifier is \(segue.identifier)")
        if segue.identifier == "searchSegue" {
            let viewController: ViewController = segue.destinationViewController as! ViewController
            viewController.parent = self
        }
        else if segue.identifier == "showSegue" {
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let viewController: showController = segue.destinationViewController as! showController
            let indexPath = self.tableView.indexPathForSelectedRow!
            let mov1 = movies[indexPath.row]
            let ac = mov1.valueForKey("hasActor") as! NSManagedObject
            let url = mov1.valueForKey("poster") as! String
            let acName = ac.valueForKey("name") as! String
            viewController.ac = acName
            viewController.poster = url
            viewController.dic = movies[indexPath.row]
        }
        if segue.identifier == "serverSearch" {
            let viewController: ServerTableViewController = segue.destinationViewController as! ServerTableViewController
            viewController.parent = self
        }

    }
    
    @IBAction func unwindFromSearchServer(sender: UIStoryboardSegue){
        saveName(self.dict)
    }
    
    @IBAction func unwindFromAdd(sender: UIStoryboardSegue){
        saveName(self.dict)
    }
    
    
    @IBAction func unwindFromOk(sender: UIStoryboardSegue)
    {
        
        // Pull any data from the view controller which initiated the unwind segue.
        print("Ok clicked")
    }
    @IBAction func unwindFromAddServer(sender: UIStoryboardSegue){
        print("here from servershow")
        let dict = m1.toJson() as! NSDictionary
        print(dict["Title"])
        print("in unwind from addserver filename is:",dict["Filename"])
        saveName(dict)
    }
    
    
    func saveName(m: NSDictionary) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entityForName("Movie",
            inManagedObjectContext:managedContext)
        
        let mov = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        mov.setValue(m["Title"], forKey: "name")
        mov.setValue(m["Plot"], forKey: "plot")
        //mov.setValue(m["Actors"], forKey: "actors")
        mov.setValue(m["Plot"], forKey: "plot")
        mov.setValue(m["Rated"], forKey: "rated")
        mov.setValue(m["Released"], forKey: "released")
        mov.setValue(m["Genre"], forKey: "genre")
        mov.setValue(m["Poster"], forKey: "poster")
        mov.setValue(m["Filename"], forKey: "filename")
        let ac = m["Actors"] as! String
        
        
        let selectRequest = NSFetchRequest(entityName: "Actors")
        var actor:NSManagedObject?
        do{
            var results = try managedContext.executeFetchRequest(selectRequest)
            // aCourse is not already saved, so save it
            let entity = NSEntityDescription.entityForName("Actors", inManagedObjectContext: managedContext)
            actor = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            actor!.setValue(ac, forKey:"name")
        } catch let error as NSError{
            print("Could not execute \(error), \(error.userInfo)")
        }
        
        let movieRequest = NSFetchRequest(entityName: "Movie")
        movieRequest.predicate = NSPredicate(format: "name == %@",m["Title"] as! String)
        do{
            let resultMovie = try managedContext.executeFetchRequest(movieRequest)
                // add the course managed object to the takes relationship set
            resultMovie[0].setValue(actor!, forKey: "hasActor")
                try managedContext.save()
        }catch let error as NSError{
            NSLog("Error adding actors \(m["Actors"] as! String). Error is \(error)")
        }
        
        do {
            try managedContext.save()
            movies.append(mov)
            updateData()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func updateData(){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Movie")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            movies = results as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func initialize(){
        if self.movies.count == 0{
        
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete the row from the data source
            NSLog("Delete called")
            /*for names in list.keys{
            name.append(names)
            }
            l.remove(name[indexPath.row])*/
            let removeMovie = movies[indexPath.row]
            let ac = removeMovie.valueForKey("hasActor") as! NSManagedObject
            print("remove is being called")
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext

            self.movies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            managedContext.deleteObject(removeMovie)
            managedContext.deleteObject(ac)
            do {
                try managedContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
            self.tableView.reloadData()
        } /*else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }

    
}