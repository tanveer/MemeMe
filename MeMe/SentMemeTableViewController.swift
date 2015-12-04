//
//  MemeTableViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 11/30/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit
private let cellIdentifier = "MemeTableViewCell"

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var meme:[Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    //MARK:- Table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meme.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CustomTableCellTableViewCell
        let memes = meme[indexPath.row]
        cell.memeTextLalbel.text = "\(memes.topText!) \(memes.bottomText!)"
        if let image = memes.memeImage {
            cell.memeImage.image = image
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let object = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = object.instantiateViewControllerWithIdentifier("detailViewController") as! MemeDetailViewCellViewController
        detailVC.index = index
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //Delete item from tableView
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        let object = UIStoryboard(name: "Main", bundle: nil)
        let memeEditor = object.instantiateViewControllerWithIdentifier("MeMeEditor")
        navigationController?.presentViewController(memeEditor, animated: true, completion: nil)
    }
}
