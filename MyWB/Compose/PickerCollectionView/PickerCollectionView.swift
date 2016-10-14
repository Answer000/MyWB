//
//  PickerCollectionView.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/14.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

private let pickerViewCell = "pickerViewCell"
private let margin : CGFloat = 15

class PickerCollectionView: UICollectionView {

    
    // MARK:- 系统回调方法
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        //注册cell
        registerNib(UINib.init(nibName: "PickerCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: pickerViewCell)
        //设置PickerCollectionView的布局
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.mainScreen().bounds.width - 4 * margin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        //设置布局内边距
        contentInset = UIEdgeInsetsMake(margin, margin, 0, margin)
        
    }
}

extension PickerCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pickerViewCell, forIndexPath: indexPath)
        return cell
    }
}
