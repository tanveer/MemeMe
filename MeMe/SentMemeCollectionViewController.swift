//
//  SentMemeCollectionViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 12/3/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemeCollectionViewController: UICollectionViewController {
    
    var memes:[Meme]!{
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var layout:UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat =  3.0
        let dimension = ( self.view.frame.size.width - ( 3 * space) ) / 2.0
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = 2
        layout.sectionInset.left = 2
        layout.sectionInset.right = 2
        layout.sectionInset.top = 2
        layout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    //MARK:- Action
    
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        let object = UIStoryboard(name: "Main", bundle: nil)
        let memeEditor = object.instantiateViewControllerWithIdentifier("MeMeEditor")
        navigationController?.presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        let memeData = memes[indexPath.row]
        cell.memeImage.image = memeData.memeImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyBoard.instantiateViewControllerWithIdentifier("detailViewController") as! MemeDetailViewCellViewController
        dvc.index = indexPath.row
        navigationController!.pushViewController(dvc, animated: true)
    }
}
