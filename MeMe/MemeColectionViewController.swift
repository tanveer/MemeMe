//
//  MemeColectionViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 11/30/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit
private let cellIdentifier = "CollectionViewCell"

class MemeColectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var meme: [Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var images = ["cheetah","leopard", "lion", "tiger", "zoo" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let space: CGFloat = 3.0
//        let dimension = ( self.view.frame.size.width - (3 * space) ) / 2.0
//        //flowLayout.estimatedItemSize = CGSize(width: 0 , height: 0)
//        flowLayout.minimumInteritemSpacing = space
//        flowLayout.minimumLineSpacing = 2
//        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
          collectionView.reloadData()
    }
    
    @IBAction func unwindSegueCollectionView(segue:UIStoryboardSegue){
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //delete it from final version
        return images.count
        //return meme.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
          //cell.memeImage.image = meme[indexPath.row].memeImage!
         //cell.infoLabel.text = meme[indexPath.row].topText!
        
        //delete it from final version
        cell.memeImage.image = UIImage(named: "\(images[indexPath.row])")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyBoard.instantiateViewControllerWithIdentifier("detailViewController") as! MemeDetailViewCellViewController
         dvc.index = indexPath.row
        navigationController!.pushViewController(dvc, animated: true)
   }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
}
