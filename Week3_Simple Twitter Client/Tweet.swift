//
//  Tweet.swift
//  Week3_Simple Twitter Client
//
//  Created by Lu Ao on 10/29/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text : String?
    var timeStamp : NSDate?
    var retwittCount : Int? = 0
    var favoriteCount: Int? = 0
    var user : NSDictionary?
    var postId : String?
    var screenname : String!

    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        favoriteCount = dictionary["favourites_count"] as? Int
        retwittCount = dictionary["retweet_count"] as? Int
        user = dictionary["user"] as? NSDictionary
        screenname = user?["screen_name"] as! String!
        postId = dictionary["id_str"] as? String
        let timeString = dictionary["created_at"] as? String
        if let timeString = timeString{
            let formatter = DateFormatter()
            //Tue Aug 28 21:16:23 +0000 2012
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeString) as NSDate?
            
        }
    }
    
    class func twittWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
