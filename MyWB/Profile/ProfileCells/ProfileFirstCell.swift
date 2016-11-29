//
//  ProfileFirstCell.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/28.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileFirstCell: UITableViewCell {
    // MARK:- 约束属性
    @IBOutlet weak var headerView: UIButton!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var member: UIButton!
    @IBOutlet weak var weiboCount: UILabel!
    @IBOutlet weak var attentionCount: UILabel!
    @IBOutlet weak var fansCount: UILabel!
    
    // MARK:- 自定义属性
    var firstDict : [String : String]?{
        didSet{
            guard let firstDict = firstDict else {
                return
            }
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(firstDict["image"])
            headerView.setBackgroundImage(image, forState: .Normal)
            nickName.text = firstDict["nickName"]
            
            member.setImage(UIImage(named: "mine_icon_membership"), forState: .Normal)
            member.setTitle("会员", forState: .Normal)
        }
    }
    var countsModel : ProfileCountsModel? {
        didSet{
            //nil值校验
            guard let model = countsModel else {
                return
            }
            weiboCount.text = String(model.statuses_count)
            attentionCount.text = String(model.friends_count)
            fansCount.text = String(model.followers_count)
            instruction.text = "简介：" + String(model.desc!)
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
