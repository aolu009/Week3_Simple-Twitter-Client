//
//  RespondViewController.swift
//  Week3_Simple Twitter Client
//
//  Created by Lu Ao on 10/31/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class RespondViewController: UIViewController,UITextViewDelegate,TwittsViewControllerDelegate {
    @IBOutlet weak var wordcount: UILabel!
    
    @IBOutlet weak var replyText: UITextView!
    var replyingTweet : Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        replyText.delegate = self
        if let handle = replyingTweet?.screenname{
            replyText.text = "@\(handle)"
        }
        
    }

    @IBAction func replySend(_ sender: Any) {
        TweetClient.shareInstance?.compose(reply: true, postId: replyingTweet?.postId, tweetString: replyText.text, success: { (dictionary) in
            self.dismiss(animated: true, completion: nil)
        }, failure: { (Error) in
            print("Error replying tweet:\(Error)")
        })
        
    }

    @IBAction func retweeted(_ sender: Any) {
        TweetClient.shareInstance?.retweet(tweetId: (replyingTweet?.postId)!, success: { (dictionary) in
            self.dismiss(animated: true, completion: nil)
        }, failure: { (Error) in
            print("Error retweeting tweet:\(Error)")
        })
        
    }
    
    @IBAction func liked(_ sender: Any) {
        TweetClient.shareInstance?.favorite(tweetId: (replyingTweet?.postId)!, success: { (dictionary) in
            self.dismiss(animated: true, completion: nil)
        }, failure: { (Error) in
            print("Error Liking tweet:\(Error)")
        })
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func twittsViewController(TwittsViewController: TwittsViewController, tweet: Tweet) {
        replyingTweet = tweet
    }
    func textViewDidChange(_ textView: UITextView) {
        if self.replyText.text.characters.count == 141{
            self.replyText.deleteBackward()
        }
        let wordRemaining = 140 - self.replyText.text.characters.count
        self.wordcount.text = String(describing: wordRemaining )
    }
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
