//
//  AlbumsLayout.swift
//  CollectionView Custom Layout Test
//
//  Created by Tim Even on 05-03-16.
//  Copyright © 2016 evenwerk. All rights reserved.
//

import UIKit

//MARK: - Local Variables
    @IBDesignable class AlbumsLayout: UICollectionViewLayout {
        
        //IBInspectables
            @IBInspectable var numberOfColumns:CGFloat = 6
        
            @IBInspectable var leftPadding:CGFloat = 20
            @IBInspectable var rightPadding:CGFloat = 20
        
            @IBInspectable var cellSpacing:CGFloat = 24
            @IBInspectable var lineSpacing:CGFloat = 10
        
        //Cache
            var cache = NSMutableArray()
        
        //Calculated variables
            var contentWidth: CGFloat {
                return CGRectGetWidth(collectionView!.bounds) - (leftPadding + rightPadding)
            }
        var contentHeight:CGFloat = 0
        
            var cell:CGSize {
                let width = (contentWidth - (cellSpacing * (numberOfColumns - 1))) / (numberOfColumns)
                let ratio:CGFloat = 1.4027777778
                let height = width * ratio

                return CGSizeMake(width, height)
            }
        
        //Transition variables
            var indexPathsToAnimate = NSMutableArray()
}

//MARK: - Layout Process
    extension AlbumsLayout {
        //Step 1.
            override func prepareLayout() {
                
                if cache.count == 0 {
                    
                    //Fill the xOffset array with the positions in a column.
                        var xOffset = [CGFloat]()
                        
                        for var columns:CGFloat = 0; columns < numberOfColumns; columns++ {
                            xOffset.append(((CGFloat(columns) * (cell.width + cellSpacing))) + leftPadding)
                        }
                        
                    //Create a column index to loop through.
                        var column:CGFloat = 0
                        var row:CGFloat = 0
                        
                    //Get the number of sections in the CollectionView...
                        let numberOfSections = collectionView?.numberOfSections()
                        
                    //Go through each section.
                        for var section = 0; section < numberOfSections; section++ {
                            
                            //Get the number of items in the current section.
                                let numberOfItemsInSection = collectionView?.numberOfItemsInSection(section)
                                cache.addObject(NSMutableArray())
                            
                            //And go through each item.
                                for var item = 0; item < numberOfItemsInSection; item++ {
                                    //Create an NSIndexPath for easy indexation.
                                        let indexPath = NSIndexPath(forItem: item, inSection: section)
                                    
                                    //Create a frame for the cell.
                                        let frame = CGRectMake(xOffset[Int(column)], row, cell.width, cell.height)
                                    
                                    //Create an instance of UICollectionViewLayoutAttribute and set its frame.
                                        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                                        attributes.frame = frame
                                        cache[section].addObject(attributes)
                                    
                                    //Set the contentHeight.
                                        contentHeight = row + cell.height
                                    
                                    //Check to see if the end of a row has been reached and go to the new row if needed.
                                        column++
                                        
                                        if column >= (numberOfColumns) {
                                            column = 0
                                            row += (cell.height + lineSpacing)
                                        }
                                }
                        }
                }
            }
        
        //Step 2.
            override func collectionViewContentSize() -> CGSize {
                return CGSizeMake(contentWidth, contentHeight)
            }
        
        //Step 3.
            override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
                //Iterate through the cache and check if their frames intersect with the rect.
                var layoutAttributes = [UICollectionViewLayoutAttributes]()
                
                for sections in cache {
                    let attributes = sections as! [UICollectionViewLayoutAttributes]
                    
                    for attribute in attributes {
                        if CGRectIntersectsRect(attribute.frame, rect) {
                            layoutAttributes.append(attribute)
                        }
                    }
                }
                return layoutAttributes
            }
    }

//MARK: - Re-Layout Process.
extension AlbumsLayout {
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = cache[indexPath.section].objectAtIndex(indexPath.row)
        
        return attributes as? UICollectionViewLayoutAttributes
    }
    
        override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
            
            //Get the bounds of the CollectionView.
                let oldBounds: CGRect = self.collectionView!.bounds
            
            //Check if the size doesn't match with the CollectionView and perform the recalculations for the layout.
                if !CGSizeEqualToSize(oldBounds.size, newBounds.size) {
                    cache.removeAllObjects()
                    return true
                    
                }
                
                return false
        }
    
        override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
            
            //Get the attributes at the indexPath.
                let attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)

                attributes!.alpha = 1.0
            
                return attributes
        }
    
        override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
            
            let attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)

            attributes!.alpha = 1.0
            
            return attributes
        }
}