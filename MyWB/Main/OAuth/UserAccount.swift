//
//  UserAccount.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/11.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit


class UserAccount: NSObject,NSCoding{
    /// 用户授权唯一票据
    var access_token : String?
    /// 过期时间-->秒
    var expires_in : NSTimeInterval = 0 {
        //监听属性发生改变
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expires_date : NSDate?
    /// 授权用户的ID
    var uid : String?
    /// 用户头像地址
    var avatar_large : String?
    /// 用户昵称
    var screen_name : String?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // MARK:- 重写description属性
    override var description : String {
        return dictionaryWithValuesForKeys(["access_token","expires_date","uid","avatar_large","screen_name"]).description
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    // MARK:- 实现归档协议方法:必须遵守NSCoding协议，实现代理方法
    ///归档方法
    func encodeWithCoder(aCoder : NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    ///解档方法
     required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as?String
        uid = aDecoder.decodeObjectForKey("uid") as?String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as?NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as?String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as?String
    }

}