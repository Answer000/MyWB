//
//  ProfileCountsModel.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/28.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class ProfileCountsModel: NSObject {
    var followers_count : Int = 0 //粉丝数
    var friends_count : Int = 0  //关注数
    var statuses_count : Int = 0 //微博数
    var desc : String?
    
    //自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        var newDict = [String : AnyObject]()
        newDict = dict
        newDict.removeValueForKey("description")
        newDict["desc"] = dict["description"]
        setValuesForKeysWithDictionary(newDict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
