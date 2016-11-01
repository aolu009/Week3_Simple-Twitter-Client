//
//  TweetsViewController.swift
//  Week3_Simple Twitter Client
//
//  Created by Lu Ao on 10/29/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

protocol TwittsViewControllerDelegate {
    func twittsViewController(TwittsViewController:TwittsViewController, tweet:Tweet)
}

class TwittsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ComposeTableViewCellDelegate {
    

    
    @IBOutlet weak var tweetsTable: UITableView!
    
    var tweets : [Tweet]?
    var tweetSelected: Tweet?
    var user : User?
    var delegate : TwittsViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tweetsTable.insertSubview(refreshControl, at: 0)
        tweetsTable.estimatedRowHeight = 300
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        TweetClient.shareInstance?.timeline(success: { (tweets) in
            self.tweets = tweets
            self.tweetsTable.reloadData()
        }, failure: { (Error) in
            print("Error retrieving tweet:\(Error)")
        })
        
        TweetClient.shareInstance?.verifyCredential(success: { (User) in
            self.user = User
        }, failure: { (Error) in
            print("Fetch User Info Error:",Error)
        })
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else{
            if self.tweets != nil{
                return (self.tweets?.count)!
            }
            else{
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComposeCell") as! ComposeTableViewCell
            cell.delegate = self
            if let picurl = self.user?.profileUrl{
                cell.userProfilePic.setImageWith(picurl)
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetcell") as! TweetTableViewCell
            cell.postText.text = self.tweets?[indexPath.row].text
            let urlString = self.tweets?[indexPath.row].user?["profile_image_url_https"]
            cell.userProfilePic.setImageWith(URL(string:urlString as! String)!)
            var timeinterval : String?
            if Int((self.tweets?[indexPath.row].timeStamp!.timeIntervalSinceNow)!) < -21600{
                timeinterval = String(describing: Int((self.tweets?[indexPath.row].timeStamp!.timeIntervalSinceNow.divided(by: -21600))!)) + "d"
            }
            else if Int((self.tweets?[indexPath.row].timeStamp!.timeIntervalSinceNow)!) < -3600 {
                timeinterval = String(describing: Int((self.tweets?[indexPath.row].timeStamp!.timeIntervalSinceNow.divided(by: -21600))!)) + "h"
            }
            else{
                timeinterval = String(describing: Int((self.tweets?[indexPath.row].timeStamp!.timeIntervalSinceNow.divided(by: -60))!)) + "m"
            }
            cell.timeStamp.text =  timeinterval! + " ago"
            cell.name.text = self.tweets?[indexPath.row].user?["name"] as? String
            cell.screen_name.text = "@" + (self.tweets?[indexPath.row].user?["screen_name"] as? String)!
            return cell
            
        }
    }
    // On Logout
    @IBAction func onLogout(_ sender: Any) {
        TweetClient.shareInstance?.logout()
    }
    
    // On Tabbing a tweet
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        self.tweetSelected = self.tweets?[indexPath.row]
        self.delegate?.twittsViewController(TwittsViewController:self, tweet:self.tweetSelected!)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        print("Reloading")
        TweetClient.shareInstance?.timeline(success: { (tweets) in
            self.tweets = tweets
            self.tweetsTable.reloadData()
        }, failure: { (Error) in
            print("Error retrieving tweet:\(Error)")
        })
    }
    // Delegate
    func composeTableViewCell(ComposeTableViewCell:ComposeTableViewCell){
        TweetClient.shareInstance?.timeline(success: { (tweets) in
            self.tweets = tweets
            self.tweetsTable.reloadData()
        }, failure: { (Error) in
            print("Error retrieving tweet:\(Error)")
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNvc = segue.destination as! UINavigationController
        let destinationVC = destinationNvc.topViewController as! RespondViewController
        let indexPath = tweetsTable.indexPath(for: sender as! TweetTableViewCell)
        //print("Selected tweet:",self.tweetSelected?.text!)
        
        destinationVC.replyingTweet = self.tweets?[(indexPath?.row)!]
    }
    
}
