//
//  showController.swift
//  MovieCollectionCoreData
//  Copyright © 2016 Shweta Murthy.
//  The instuctor and the University are provided the right to build and evaluate the software package for
//  the purpose of determining grade and program assessment.
//  Created by Shweta Murthy on 4/4/16.mailto:smurthy3@asu.edu.

import Foundation
import UIKit
import CoreData

class showController: UIViewController {
    var dic: NSManagedObject!
    var ac:String!
    var poster:String!
    var filename: String!
    @IBOutlet weak var n: UITextField!
    @IBOutlet weak var g: UITextField!
    @IBOutlet weak var r: UITextField!
    @IBOutlet weak var re: UITextField!
    @IBOutlet weak var p: UITextView!
    @IBOutlet weak var a: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        n.text = dic.valueForKey("name") as? String
        g.text = dic.valueForKey("genre") as? String
        r.text = dic.valueForKey("rated") as? String
        re.text = dic.valueForKey("released") as? String
        p.text = dic.valueForKey("plot") as? String
        //a.text = dic.valueForKey("actors") as? String
        a.text = self.ac
        self.filename = dic.valueForKey("filename") as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("seque identifier is \(segue.identifier)")
        if segue.identifier == "poster" {
            let viewController: showPoster = segue.destinationViewController as! showPoster
            viewController.url = poster
        }
        if segue.identifier == "playSegue"{
            let viewController: playController = segue.destinationViewController as! playController
            if(self.filename != nil){
            print("in sending to playSegue filename is:",self.filename)
                viewController.filename = self.filename}
        }
    }
    

}
