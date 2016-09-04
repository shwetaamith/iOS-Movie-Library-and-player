//
//  playController.swift
//  MovieCollectionCoreData
//
//  Created by Shweta Murthy on 4/18/16.
//  Created by Shweta Murthy on 4/18/16.
//  Copyright © 2016 Shweta Murthy.
//  The instuctor and the University are provided the right to build and evaluate the software package for
//  the purpose of determining grade and program assessment.
//  Created by Shweta Murthy on 4/4/16.mailto:smurthy3@asu.edu.

import UIKit
import AVKit
import AVFoundation


class playController: UIViewController, NSURLSessionDelegate {
    var streamer_host:String?
    var streamer_port:String?
    var filename: String = ""
    let playCont = AVPlayerViewController()
    var player : AVPlayer!

    //var downloadBG:NSURLSessionTask!
    //var backSess:NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // get the host and port from Info.plist
        if(filename != ""){
        if let path = NSBundle.mainBundle().pathForResource("Server", ofType: "plist"){
            if let dict = NSDictionary(contentsOfFile: path) as? [String:AnyObject] {
                streamer_host = dict["streamer_host"] as? String
                streamer_port = dict["streamer_port"] as? String
            }
            let urlString:String = "http://\(streamer_host!):\(streamer_port!)/\(filename)"
            NSLog("viewDidLoad using url: \(urlString)")
            // download the video to a file (completely) before playing
            downloadVideo(urlString)}
            
        }
        else{
            let message = "Movie not available!"
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // download the video in the background using NSURLSession.
    func downloadVideo(urlString: String){
        let bgConf = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("bgSession")
        let backSess = NSURLSession(configuration: bgConf, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
        let aUrl = NSURL(string: urlString)!
        let downloadBG = backSess.downloadTaskWithURL(aUrl)
        downloadBG.resume()
        
    }
    
    // play the movie from a file url
    func playMovieAtURL(fileURL: NSURL){
        print("in playMovieAtURL")
        
        self.player = AVPlayer(URL: fileURL)
        playCont.player = self.player
        self.addChildViewController(playCont)
        self.view.addSubview(playCont.view)
        playCont.view.frame = self.view.frame
        print("setup done, playing now..")
        self.player.play()
        print("done")
        
    }
    
    // functions for NSURLSessionDelegate
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL){
            
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let fileMgr = NSFileManager()
            let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("/\(filename)"))
            
            if fileMgr.fileExistsAtPath(destinationURLForFile.path!) {
                NSLog("destination file url: \(destinationURLForFile.path!) exists. Deleting")
                do {
                    try fileMgr.removeItemAtURL(destinationURLForFile)
                }catch{
                    NSLog("error removing file at: \(destinationURLForFile)")
                }
            }
            do {
                try fileMgr.moveItemAtURL(location, toURL: destinationURLForFile)
                // show file
                NSLog("download and save completed: \(destinationURLForFile.path!)")
                session.invalidateAndCancel()
                playMovieAtURL(destinationURLForFile)
            }catch{
                NSLog("An error occurred while moving file to destination url")
            }
    }
    
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64){
            NSLog("did write portion of file: \(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))")
    }
    
    override func viewWillDisappear(animated: Bool){
        if let status:AVPlayerStatus = self.player?.status {
            NSLog("viewWillDisappear \(((status==AVPlayerStatus.ReadyToPlay) ? "Ready":"unknown")))")
        }else{
            NSLog("viewWillDisappear player not initialized")
        }
        if self.player != nil {
            self.player?.pause()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("In view will appear")
        print(self.playCont.player?.rate)
        
    }
    
    
}

