//
//  UserAccountViewModel.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/12.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class UserAccountViewModel{
    
    ///单例
    static let shareInstan = UserAccountViewModel()
    
    var account : UserAccount?
    // MARK:- 计算属性
    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        return (accountPath as NSString).stringByAppendingPathComponent("account.plist")
    }
    var isLogin : Bool {
        
        if let account = account {
            //取出过期日期 ： 当前日期
            if account.expires_date?.compare(NSDate()) == .OrderedDescending {
                return true
            }
        }
        return false
    }
    // MARK:- 重写init方法
    init(){
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }

}
