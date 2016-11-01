//
//  TweetClient.swift
//  Week3_Simple Twitter Client
//
//  Created by Lu Ao on 10/29/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TweetClient: BDBOAuth1SessionManager {
    static let userDidlogOutNotification = "UserDidLogout"
    static let shareInstance = TweetClient(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "HOw0nZewokDyySsxB0gJs8NGz", consumerSecret: "e0lmcmhgLeCfRletsS38gCVyYi1dNPccpZI56aRlFtX0yPZioT")

    func verifyCredential( success: @escaping (User) -> Void, failure:@escaping (Error) -> Void ) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            //print("Success with response:",reponse)
            let userDictionary = response as! NSDictionary
            let user = User.init(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, Error) -> Void in
            failure(Error)
        })
    }
    
    // Timeline method
    func timeline( success: @escaping ([Tweet]) -> Void, failure:@escaping (Error) -> Void ) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            //print("Success with response:",response)
            let twittDictionary = response as! [NSDictionary]
            let tweets = Tweet.twittWithArray(dictionaries: twittDictionary)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, Error) -> Void in
            failure(Error)
        })
    }
    //log out method
    func logout(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TweetClient.userDidlogOutNotification), object: nil)
        User.currentUser = nil
        deauthorize()
    }
    
    //login method
    var loginSuccess : (()->())?
    var loginFailure : ((Error)->())?
    func login(success:@escaping ()->(),failure:@escaping (Error)->()){
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterdemo://oauth"), scope: nil, success: {
            (requestToken) -> Void in
            print("Request token success!!")
            let autherizeUrl = URL(string:"https://api.twitter.com/oauth/authorize?oauth_token="+(requestToken?.token)!)
            print("URL:",autherizeUrl!)
            print("Token",requestToken?.token! ?? "Tooken Value Missing, while not getting error")
            UIApplication.shared.open(autherizeUrl!, options: [:], completionHandler: nil)
            
        }, failure: { (Error) -> Void in
            print("Request token Fails!! :", Error?.localizedDescription ?? "Getting error without error description")
            self.loginFailure?(Error!)
        })
    }
    // Compose method regular post and reply with post ID
    func compose( reply: Bool, postId:String?, tweetString: String, success: @escaping (NSDictionary) -> Void, failure: @escaping (Error) -> Void ) {
        var message : [String:String]
        if reply == true{
            message = ["status": tweetString,"in_reply_to_status_id":postId!]
        }
        else{
            message = ["status": tweetString]
        }
        post("1.1/statuses/update.json", parameters: message, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            //print("Success with response:",response)
            let tweet = response as! NSDictionary
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, Error) -> Void in
            failure(Error)
        })
    }
    
    //Retweet method
    func retweet( tweetId: String, success: @escaping (NSDictionary) -> Void, failure: @escaping (Error) -> Void ) {
        //let validTweetString = TweetValidator().validTween(tweetString)
        let parameters = ["id": tweetId]
        post("1.1/statuses/retweet/\(tweetId).json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            //print("Success with response:",response)
            let tweet = response as! NSDictionary
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, Error) -> Void in
            failure(Error)
        })
    }
    // Favorite a tweet
    func favorite( tweetId: String, success: @escaping (NSDictionary) -> Void, failure: @escaping (Error) -> Void ) {
        //let validTweetString = TweetValidator().validTween(tweetString)
        let parameters = ["id": tweetId]
        post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            //print("Success with response:",response)
            let tweet = response as! NSDictionary
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, Error) -> Void in
            failure(Error)
        })
    }
    
    
    func handleOpenUrl(url:URL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            print("Access Token:",accessToken!)
            self.verifyCredential(success: { (user) in //may have error
                self.loginSuccess?()
                User.currentUser = user//get back here if error
                print("User name:", user.name!)
                print("User screenname:", user.screenname!)
                print("User tagline:", user.tagline!)
            }, failure: { (Error) in
                print("Error:",Error.localizedDescription)
            })
        }, failure: { (Error) in
            self.loginFailure!(Error!)
            print("Error:",Error?.localizedDescription ?? "Default Error")
        })
    }
}
