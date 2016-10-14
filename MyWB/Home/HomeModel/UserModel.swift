//
//  UserModel.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/9.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    // MARK:- 属性
    var profile_image_url : String?  //用户头像
    var screen_name : String?        //用户昵称
    var verified_type : Int = -1     //用户的认证类型
    var mbrank : Int = 0             //用户的会员等级
    
    // MARK:- 重写构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
