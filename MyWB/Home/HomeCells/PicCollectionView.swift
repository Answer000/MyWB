//
//  PicCollectionView.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/10.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

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
    }
}

// MARK:- CollectionView数据代理方法
extension PicCollectionView : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = pic_urls?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as! PicCollectionViewCell
        cell.pic_url = pic_urls![indexPath.row]
        return cell
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
            picImageView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
}
