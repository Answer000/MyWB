//
//  PicCollectionView.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/10.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    // MARK:- 自定义属性
    var pic_urls : [NSURL]? {
        didSet{
            self.reloadData()
        }
    }
    
    // MARK:- 系统回调方法
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK:- 设置代理
        dataSource = self
        delegate = self
    }
}

// MARK:- CollectionView数据代理方法
extension PicCollectionView : UICollectionViewDataSource ,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = pic_urls?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as! PicCollectionViewCell
        cell.pic_url = pic_urls?[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(showPhotoBrowserNote, object: self, userInfo: ["pic_urls" : pic_urls!,"indexPath" : indexPath])
    }
}

// MARK:- PhotoBrowserAnimatorPresentDelegate代理方法
extension PicCollectionView : PhotoBrowserAnimatorPresentDelegate{
    func imageViewForPresent(indexPath: NSIndexPath) -> UIImageView {
        let imageView = UIImageView()
        let pic_url = pic_urls![indexPath.item]
        let bigPic_url = pic_url.absoluteString?.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(bigPic_url)
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func startRectForPresent(indexPath: NSIndexPath) -> CGRect {
        let cell = cellForItemAtIndexPath(indexPath) as! PicCollectionViewCell
        let startRect = self.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        return startRect
    }
    func endRectForPresent(indexPath: NSIndexPath) -> CGRect {
        let pic_url = pic_urls![indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(pic_url.absoluteString)
        let width : CGFloat = UIScreen.mainScreen().bounds.width
        let heigth : CGFloat = width / image.size.width * image.size.height
        var y : CGFloat = 0.0
        if heigth > UIScreen.mainScreen().bounds.height {
            y = 0.0
        }else{
            y = (UIScreen.mainScreen().bounds.height - heigth) * 0.5
        }
        return CGRect(x: 0, y: y, width: width, height: heigth)
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!

    // MARK:- 自定义属性
    var pic_url : NSURL? {
        didSet{
            guard let picURL = pic_url else {
                return
            }
            let bigPicURL = NSURL(string: (picURL.absoluteString?.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle"))!)
            picImageView.sd_setImageWithURL(bigPicURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
}


