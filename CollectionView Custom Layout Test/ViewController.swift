//
//  ViewController.swift
//  CollectionView Custom Layout Test
//
//  Created by Tim Even on 05-03-16.
//  Copyright © 2016 evenwerk. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension CollectionViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 53
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        if indexPath.section % 2 == 0 {
            cell!.backgroundColor = UIColor.blackColor()
        }
        else {
            cell!.backgroundColor = UIColor.lightGrayColor()
        }
        
        return cell!
    }
}

extension CollectionViewController {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
    }
}