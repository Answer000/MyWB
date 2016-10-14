//
//  ProfileViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ///  打开滚动属性
        visitorView.scrollEnabled = true
        ///  设置访客视图信息
        visitorView.setupVisitorViewInfo(iconName:"visitordiscover_image_profile", tip: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人" ,isHide_bgImgView: false)
    }
}
