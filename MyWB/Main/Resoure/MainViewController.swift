//
//  MainViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    override func viewDidLoad() {
        super.viewDidLoad()
        ///  设置tabbar的titColor
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        setComposeButton()
    }
}

// MARK:- 设置UI界面
extension MainViewController {
    
    private func setComposeButton(){
        composeBtn.addTarget(self, action: #selector(MainViewController.clickComposeButton(_:)), forControlEvents: .TouchUpInside)
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        tabBar.addSubview(composeBtn)
    }
}

// MARK:-  事件监听
extension MainViewController {
    //  事件监听本质是发送消息，但是发送消息是OC的特性
    //  将方法包装成@SEL--> 类中查找方法列表 --> 根据@SEL找到imp指针(函数指针) --> 执行函数
    //  如果swift中将一个方法声明为private,那么该方法不会被添加到方法列表中
    //  如果在private前面加上@objc，那么该方法依然会被添加到方法列表中
    @objc private func clickComposeButton(sender : UIButton) {
        let composeVC = ComposeViewController()
        let composeNavi = UINavigationController(rootViewController: composeVC)
        presentViewController(composeNavi, animated: true, completion: nil)
    }

}
