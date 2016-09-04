//
//  ViewController.swift
//  MovieCollectionCoreData
//
//  Copyright © 2016 Shweta Murthy. 
//  The instuctor and the University are provided the right to build and evaluate the software package for
//  the purpose of determining grade and program assessment.
//  Created by Shweta Murthy on 4/4/16.mailto:smurthy3@asu.edu.



import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTitle: UITextField!
    @IBOutlet weak var actualTitle: UITextField!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var rated: UITextField!
    @IBOutlet weak var released: UITextField!
    @IBOutlet weak var plot: UITextView!
    @IBOutlet weak var actors: UITextView!
    var parent: MovieColTabController!
    var dict: NSDictionary = NSDictionary()
    @IBAction func search(sender: AnyObject) {
        
        let movie: MovieStub = MovieStub(urlString: "http://www.omdbapi.com/?",title:searchTitle.text!,year:"",plot:"short",result: "json", s: self)
        
        movie.sendHttpRequest(movie.request, callback:{ (res: String, err: String?)-> Void in
            if err != nil {
                NSLog(err!)
            }else{
                
                NSLog(res)
               
                print("call done")
                //print(self.dict["Title"] as! String)
                if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                    do{
                        self.dict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                        if((self.dict["Response"] as? String)! == "False"){
                            let message = (self.dict["Error"] as? String)!
                            let alertController = UIAlertController(title: "Sorry", message: message, preferredStyle: .Alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
                            alertController.addAction(okAction)
                            
                            // Present the controller
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        else{
                        self.actualTitle.text = (self.dict["Title"] as? String)!
                        self.plot.text = (self.dict["Plot"] as? String)!
                        self.genre.text = (self.dict["Genre"] as? String)!
                        self.rated.text = (self.dict["Rated"] as? String)!
                        self.released.text = (self.dict["Released"] as? String)!
                        self.actors.text = (self.dict["Actors"] as? String)!
                        self.parent.dict = self.dict
                        }}
                    catch {
                        print("unable to convert to dictionary")
                    }
                }
                }
            })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTitle.delegate = self
        searchTitle.placeholder = "Enter search title here"
        plot.layer.borderWidth = 1.0
        actors.layer.borderWidth = 1.0
        plot.layer.cornerRadius = 8.0
        actors.layer.cornerRadius = 8.0
        plot.layer.borderColor = UIColor.lightGrayColor().CGColor
        actors.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        search(self)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("seque identifier is \(segue.identifier)")
        if segue.identifier == "searchPoster" {
            let viewController: showPoster = segue.destinationViewController as! showPoster
            viewController.url = (self.dict["Poster"] as? String)!
        }
    }
    


}

