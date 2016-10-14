//
//  UIButton+image_Extension.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit


extension UIButton {
    
    ///  添加分类方法
    // swift中类方法是以class开头的方法，类似OC中+号开头的方法
    class func initButton(title : String,bgImage : String) ->UIButton {
        
        let button = UIButton()
        
        button.setTitle(title, forState: .Normal)
        button.setBackgroundImage(UIImage(named: bgImage), forState: .Normal)
        button.setBackgroundImage(UIImage(named: bgImage + "_highlighted"), forState: .Highlighted)
        
        return button
    }
    
    ///  添加遍历构造函数
    // convernience :便利，使用convenience修饰的构造函数叫做便利函数
    // 便利构造函数通常用在对系统的类进行构造函数的扩充时使用
    // 便利构造函数的特点：
    //  1.便利构造函数通常都是写在extension里面
    //  2.便利构造函数init前面需要加convenience进行修饰
    //  3.在便利构造函数中需要明确的调用self.init()方法
    convenience init(imageName : String, bgImageName : String) {
        self.init()
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Highlighted)
        sizeToFit()
    }
}