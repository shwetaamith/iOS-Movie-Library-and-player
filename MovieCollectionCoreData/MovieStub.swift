//
//  MovieStub.swift
//  MovieCollectionCoreData
//

//  Copyright © 2016 Shweta Murthy.
//  The instuctor and the University are provided the right to build and evaluate the software package for
//  the purpose of determining grade and program assessment.
//  Created by Shweta Murthy on 4/4/16.mailto:smurthy3@asu.edu.

import UIKit
import Foundation


public class MovieStub {
    
    static var id:Int = 0
    
    var url:String
    var title:String
    var year:String
    var plot:String
    var result:String
    var request: NSMutableURLRequest
    var parent: ViewController
    
    init(urlString: String, title:String,year:String, plot:String, result:String, s: ViewController){
        self.url = urlString
        let newString = title.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        NSLog(newString)
        self.title = newString
        self.year = year
        self.plot = plot
        self.result = result
        self.parent = s
        let url = urlString+"t=\(self.title)&y=&plot=\(plot)&r=\(result)"
        let myUrl = NSURL(string: url);
        self.request = NSMutableURLRequest(URL:myUrl!);
        self.request.HTTPMethod = "POST"
        //sendHttpRequest (request, callback: callback)
    }
    
    
    
    // sendHttpRequest
    func sendHttpRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            // task.resume causes the shared session http request to be posted in the background (non-UI Thread)
            // the use of the dispatch_async on the main queue causes the callback to be performed on the UI Thread
            // after the result of the post is received.
            //var name: String
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                if (error != nil) {
                    callback("", error!.localizedDescription)
                } else {
                    dispatch_async(dispatch_get_main_queue(),
                        {callback(NSString(data: data!,
                            encoding: NSUTF8StringEncoding)! as String, nil)})
                        }
            }
            task.resume()
    }
    
    
}
