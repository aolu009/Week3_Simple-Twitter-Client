//
//  ViewController.swift
//  Week3_Simple Twitter Client
//
//  Created by Lu Ao on 10/28/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onLoginButtton(_ sender: AnyObject) {
        TweetClient.shareInstance?.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            print("Login Sucessfully")
        }, failure: { (Error) in
            print("Login Error:\(Error.localizedDescription)")
        })
        
    }
    
}

