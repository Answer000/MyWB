//
//  PickerCollectionViewCell.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/14.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class PickerCollectionViewCell: UICollectionViewCell {
// MARK:- 约束属性
    
    @IBOutlet weak var delectBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var photoImgView: UIImageView!
    @IBAction func addBtnClick(sender: UIButton) {
        //发送跳转到照片选择控制器的通知
        NSNotificationCenter.defaultCenter().postNotificationName(pickerAddPhotoNote, object: nil)
    }
    @IBAction func delectBtnClick(sender: UIButton) {
        //发送删除照片的通知
        NSNotificationCenter.defaultCenter().postNotificationName(pickerdelectPhotoNote, object: photoImgView.image)
    }
    
    // MARK:- 自定义属性
    var image : UIImage? {
        didSet{
            if image != nil {
                photoImgView.image = image
                addBtn.userInteractionEnabled = false
                delectBtn.hidden = false
            }else{
                photoImgView.image = nil
                addBtn.userInteractionEnabled = true
                delectBtn.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


