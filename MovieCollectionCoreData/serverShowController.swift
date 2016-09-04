//
//  serverShowController.swift
//  MovieCollectionCoreData
//
//  Created by Shweta Murthy on 4/18/16.
//  Created by Shweta Murthy on 4/18/16.
//  Copyright © 2016 Shweta Murthy.
//  The instuctor and the University are provided the right to build and evaluate the software package for
//  the purpose of determining grade and program assessment.
//  Created by Shweta Murthy on 4/4/16.mailto:smurthy3@asu.edu.

import Foundation
import UIKit

class serverShowController: UIViewController{
    var pparent: MovieColTabController!
    var movie: String = ""
    let urlString:String = "http://localhost:8080"
    var filename: String = ""
    var poster: String = ""
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var rated: UITextField!
    @IBOutlet weak var released: UITextField!
    @IBOutlet weak var plot: UITextView!
    @IBOutlet weak var actor: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("reached viewcontroller from segue")
        print("movie is:",movie)
        let aConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
        let resGet:Bool = aConnect.get(movie, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                print("Result for populating")
                if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                    do{
                        let dict = try NSJSONSerialization.JSONObjectWithData(data,options:.MutableContainers) as?[String:AnyObject]
                        let aDict:[String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        let aStud:Movie = Movie(dict: aDict)
                        self.name.text = aStud.name
                        self.actor.text = aStud.actors
                        self.plot.text = aStud.plot
                        self.genre.text = aStud.genre
                        self.released.text = aStud.released
                        self.rated.text = aStud.rated
                        //self.year.text = aStud.year
                        self.filename = aStud.filename
                        self.poster = aStud.poster
                        self.pparent.m1 = aStud
                    } catch {
                        NSLog("unable to convert to dictionary")
                    }
                }
            }
        })
        print("you")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        NSLog("seque identifier is \(segue.identifier)")
        if segue.identifier == "serverPlaySegue" {
            let plController: playController = segue.destinationViewController as! playController
            print(segue.destinationViewController)
            plController.filename = self.filename
            print(self.filename)
        }
        if segue.identifier == "serverPoster" {
            let vController: showPoster = segue.destinationViewController as! showPoster
            print(segue.destinationViewController)
            vController.url = self.poster
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.reloadInputViews()
    }

}
