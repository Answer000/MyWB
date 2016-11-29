//
//  HomeTableViewCell.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/9.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10
private let screenWidth : CGFloat = UIScreen.mainScreen().bounds.width

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var contents_Width_constraints: NSLayoutConstraint!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var creatAtLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var verifiedTypeImageView: UIImageView!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var bottomToolsView: UIView!
    @IBOutlet weak var bottomBgView: UIView!
    // MARK:- 约束属性
    @IBOutlet weak var picView_width_constraints: NSLayoutConstraint!
    @IBOutlet weak var picView_heiht_constraints: NSLayoutConstraint!
    @IBOutlet weak var picView_top_constraints: NSLayoutConstraint!
    @IBOutlet weak var retweetedLabel_top_constraints: NSLayoutConstraint!
    var viewModel : StatusesViewModel? {
        didSet{
            //nil值校验
            guard let viewModel = viewModel else {
                return
            }
            //设置头像
            userIconImageView.sd_setImageWithURL(viewModel.profileImageUrl, placeholderImage: UIImage(named: "radar_card_head_occupying"))
            //设置昵称
            nickNameLabel.text = viewModel.status?.user?.screen_name
            nickNameLabel.textColor = viewModel.nickNameTextColor
            //设置发布时间
            creatAtLabel.text = viewModel.created_atText
            //设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 " + sourceText
            }else{
                sourceLabel.text = nil
            }
            
            //设置认证图标
            verifiedTypeImageView.image = viewModel.verifiedImage;
            //设置会员等级图标
            vipImageView.image = viewModel.vipImage
            
            //设置微博正文
            contentLabel.attributedText = FindEmotionHelper.shareInstance.findEmotion(viewModel.status?.text, font: contentLabel.font)
            //设置picView的宽高约束
            let picViewSize = calculatePicViewWH((viewModel.pic_urlArray?.count)!)
            picView_width_constraints.constant = picViewSize.width
            picView_heiht_constraints.constant = picViewSize.height
            //设置配图
            picView.pic_urls = viewModel.pic_urlArray
            
            //设置转发正文
            if let retweetedText = viewModel.status?.retweeted_status?.text ,
               let screenName = viewModel.status?.retweeted_status?.user?.screen_name {
                //设置转发Label的内容
                retweetedLabel.attributedText = FindEmotionHelper.shareInstance.findEmotion("@\(screenName)：" + retweetedText, font: retweetedLabel.font)
                //设置转发Label的顶部约束
                retweetedLabel_top_constraints.constant = 15
            }else{
                //设置转发Label的内容为nil
                retweetedLabel.text = nil
                //设置转发Label的顶部约束
                retweetedLabel_top_constraints.constant = 0
            }
            //cell强制布局
            layoutIfNeeded()
            //计算cell的高度
            viewModel.status?.cellHeight = CGRectGetMaxY(bottomToolsView.frame)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文Label的约束宽度
        contents_Width_constraints.constant = screenWidth - edgeMargin * 2
    }
}

// MARK:- 计算方法
extension HomeTableViewCell {
    private func calculatePicViewWH(count : Int) ->CGSize {
        //1: 0张图片的情况
        if count == 0 {
            //设置picView的顶部约束
            picView_top_constraints.constant = 0
            //隐藏bottomBgView
            bottomBgView.hidden = true
            return CGSizeZero
        }
        //设置picView的顶部约束
        picView_top_constraints.constant = 10
        //显示bottomBgView
        bottomBgView.hidden = false

        //设置picView的布局
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        picView.collectionViewLayout = layout
        //2: 单张图片的情况
        if count == 1 {
            //获取缓存图片
            let urlString = viewModel?.pic_urlArray?.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString)
            if (image != nil) {
                if image.size.height/image.size.width > 3 {
                    layout.itemSize = CGSize(width: (screenWidth - 2*edgeMargin - 2*itemMargin) / 3, height: (screenWidth - 2*edgeMargin - 2*itemMargin) / 2)
                }else{
                    layout.itemSize = CGSize(width: image.size.width, height: image.size.height)
                }
                return layout.itemSize
            }
            return CGSizeZero
        }
        let imageWH = (screenWidth - 2*edgeMargin - 2*itemMargin) / 3
        layout.itemSize = CGSize(width: imageWH, height: imageWH)

        //2: 4张图片的情况
        if count == 4 {
            return CGSize(width: imageWH * 2 + itemMargin, height: imageWH * 2 + itemMargin)
        }
        //3: 其他情况
        //3.1 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        return CGSize(width: screenWidth - 2*edgeMargin, height: rows * imageWH + (rows - 1) * itemMargin)
    }
}
