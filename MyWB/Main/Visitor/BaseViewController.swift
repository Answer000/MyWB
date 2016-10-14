//
//  BaseViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    var isLogin = UserAccountViewModel.shareInstan.isLogin
    lazy var visitorView : VisitorView = VisitorView.initVisitorView()
    
    override func loadView() {

        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

// MARK:-  设置UI
extension BaseViewController {
    private func setupVisitorView() {
        view = visitorView
        ///  设置导航栏按钮
        visitorView.registBtn.addTarget(self, action: #selector(BaseViewController.registButtonClick(_:)), forControlEvents: .TouchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginButtonClick(_:)), forControlEvents: .TouchUpInside)
    }
}

// MARK:- 事件监听
extension BaseViewController {
    ///  注册按钮监听事件
    func registButtonClick(sender: AnyObject) {
        print(#function)
    }
    ///   登录按钮监听事件
    func loginButtonClick(sender: AnyObject) {
        let oauthVC = OAuthViewController()
        oauthVC.title = "授权登录"
        let oauthNavi = UINavigationController(rootViewController: oauthVC)
        self.presentViewController(oauthNavi, animated: true, completion: nil)
    }
}
