//
//  MessageViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.setupVisitorViewInfo(iconName:"visitordiscover_image_message", tip: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }
}
