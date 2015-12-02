//
//  MemeTableViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 11/30/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit
private let cellIdentifier = "MemeTableViewCell"

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var meme:[Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    //MARK:- Pop viewController
    @IBAction func unwindToTableView(segue: UIStoryboardSegue){        
    }
    
    
    //MARK:- Table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meme.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        let memes = meme[indexPath.row]
        cell.textLabel?.text = memes.topText!
        cell.detailTextLabel?.text = memes.bottomText!
        if let image = memes.memeImage {
            cell.imageView?.image = image
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        
        let object = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = object.instantiateViewControllerWithIdentifier("detailViewController") as! MemeDetailViewCellViewController
        detailVC.index = index

        navigationController?.presentViewController(detailVC, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
