//
//  ComposeTableViewCell.swift
//  Week3_Simple Twitter Client
//
//  Created by Lu Ao on 10/30/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

protocol ComposeTableViewCellDelegate {
    func composeTableViewCell(ComposeTableViewCell:ComposeTableViewCell)
}

class ComposeTableViewCell: UITableViewCell,UITextViewDelegate{

    @IBOutlet weak var remainingWordCount: UILabel!
    
    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var userProfilePic: UIImageView!
    var delegate : ComposeTableViewCellDelegate?
    var originalHeight : CGFloat?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        originalHeight = self.frame.height
        self.tweetButton.setImage(UIImage(named:"TweetButtonOnSelected"), for: .selected)
        self.remainingWordCount.isHidden = true
        tweetTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin editing")
        self.tweetTextField.text = ""
        self.tweetButton.isHidden = false
        self.remainingWordCount.isHidden = false

    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.tweetTextField.text != ""{
            self.tweetButton.isEnabled = true
            self.tweetButton.setImage(UIImage(named: "TweetButtonOn"), for: .normal)
            if self.tweetTextField.text.characters.count == 141{
                self.tweetTextField.deleteBackward()
            }
            let wordRemaining = 140 - self.tweetTextField.text.characters.count
            self.remainingWordCount.text = String(describing: wordRemaining )
        }
        else{
            tweetButton.setImage(UIImage(named: "TweetButtonOff"), for: .disabled)
            self.tweetButton.isEnabled = false
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.tweetTextField.text = ""
        self.tweetButton.isHidden = false
        return true
    }
    
    
    @IBAction func sendTweet(_ sender: Any) {
        TweetClient.shareInstance?.compose(reply: false, postId: nil, tweetString: tweetTextField.text!, success: { (dictionary) in
            self.delegate?.composeTableViewCell(ComposeTableViewCell: self)
            self.tweetTextField.text = ""
            print("Tweet send successful!!!")
        }, failure: { (Error) in
            print("Tweet send Error:\(Error)")
        })
    }
    
    
    
    
    
}
