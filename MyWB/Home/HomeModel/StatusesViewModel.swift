//
//  StatusesViewModel.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/9.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class StatusesViewModel: NSObject {
    
    var status : StatusesModel?
    // MARK:- 自定义属性
    var sourceText : String?         //数据来源
    var created_atText : String?     //创建时间
    var verifiedImage : UIImage?     //用户认证图标
    var vipImage : UIImage?          //用户等级图标
    var profileImageUrl : NSURL?     //用户头像链接
    var nickNameTextColor : UIColor? = UIColor.blackColor() //用户昵称字体颜色
    var pic_urlArray : [NSURL]? = [NSURL]() //用户配图链接
    
    init(statuses : StatusesModel) {
        self.status = statuses
        // MARK:- 处理来源
        if let source = statuses.source where source != ""{
            // 2.对来源的字符串进行处理
            // 2.1获取起始位置和截取的长度
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - startIndex
            //2.2 截取字符串
            sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
        // MARK:- 处理时间
        if let created_at = statuses.created_at{
            created_atText = NSDate.creatDate(created_at)
        }
        // MARK:- 处理用户认证图标
        let verifiedType = statuses.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // MARK:- 处理用户等级图标
        let mbrank = statuses.user?.mbrank ?? 0
        if mbrank <= 6 && mbrank > 0 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            nickNameTextColor = UIColor.orangeColor()
        }
        
        // MARK:- 处理用户头像链接
        if let profile_image_url = status?.user?.profile_image_url {
            profileImageUrl = NSURL(string: profile_image_url)
        }
        
        // MARK:- 处理用户配图
        //如果用户原创配图有则显示原创配图，否则展示转发配图
        let picURLs = status?.pic_urls?.count > 0 ? status?.pic_urls : status?.retweeted_status?.pic_urls
        if let pic_urls = picURLs {
            for pic_url_dict in pic_urls {
                if let pic_url_str = pic_url_dict["thumbnail_pic"] {
                    if let pic_url = NSURL(string: pic_url_str){
                        pic_urlArray?.append(pic_url)
                    }
                }
            }
        }
    }
}
