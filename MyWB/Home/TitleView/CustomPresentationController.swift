//
//  CustomPresentationController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/8.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    // MARK:- 属性
    var presentedFrame : CGRect = CGRectZero
    private lazy var groundView = UIView()
    
    // MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        ///  设置弹出视图的Frame
        presentedView()?.frame = presentedFrame
        
        ///  设置蒙版
        setupGroundView()
    }
}
//MARK:-  设置UI
extension CustomPresentationController {
    ///  设置蒙版
    func setupGroundView() {
        //设置蒙版属性
        groundView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        //        groundView.frame = containerView?.bounds ?? CGRectZero
        groundView.frame = containerView!.bounds
        
        //添加蒙版
        containerView?.insertSubview(groundView, belowSubview: presentedView()!)
        
        //添加点击手势
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(CustomPresentationController.clickGroundView))
        groundView .addGestureRecognizer(tap)
    }
}

// MARK:-  事件监听
extension CustomPresentationController {
    ///  监听groundView手势点击事件
    @objc private func clickGroundView() {
        print(#function)
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
