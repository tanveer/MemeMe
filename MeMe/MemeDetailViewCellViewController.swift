//
//  MemeDetailViewCellViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 12/1/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit

class MemeDetailViewCellViewController: UIViewController {

    var meme:[Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var index:Int?
    @IBOutlet weak var memeImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = index{
            let memeData = meme[index]
            memeImageView.image = memeData.memeImage
        }
        
    }
    
    @IBAction func dismissPresentingViewController(sender: UIBarButtonItem){
    }
}
