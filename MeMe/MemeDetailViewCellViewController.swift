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
    var memeData:Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = index {
            memeData = meme[index]
            memeImageView.image = memeData.originlImage
        }
        //tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.hidden = false
        
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem){
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memeImageView.image = nil
        appDelegate.memes.removeAtIndex(index!)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func editMeme(){
        let object = UIStoryboard(name: "Main", bundle: nil)
        let memeEditor = object.instantiateViewControllerWithIdentifier("MeMeEditor") as! MemeEditorViewController
           // memeEditor.meme.append(memeData)
            presentViewController(memeEditor, animated: true, completion: nil)
    }
}
