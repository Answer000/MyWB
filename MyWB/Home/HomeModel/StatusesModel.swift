//
//  StatusesModel.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/8.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class StatusesModel: NSObject {
    // MARK:- 属性
    var created_at : String?        //微博创建时间
    var source : String?            //微博来源
    var text : String?              //微博的正文
    var mid : Int = 0               //微博的ID
    var user : UserModel?           //用户信息
    var pic_urls : [[String : String]]? //用户配图
    var retweeted_status : StatusesModel? //转发微博
    var cellHeight : CGFloat = 0  //保存cell的高度
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict);
        
        //1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = UserModel(dict : userDict)
        }
        //2.将用户转发微博转换为用户原生微博模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = StatusesModel(dict: retweetedStatusDict)
        }
    }
    // MARK:- 重写系统方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    
    }
}
