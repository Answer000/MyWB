//
//  ComposeViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/12.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

private let screen_width = UIScreen.mainScreen().bounds.width
private let screen_height = UIScreen.mainScreen().bounds.height

class ComposeViewController: UIViewController {
    
    // MARK:- 约束属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var toolBar_bottom_cons: NSLayoutConstraint!
    @IBOutlet weak var pickerCollectionView_height_cons: NSLayoutConstraint!
    
    @IBAction func pictureButtonClick(sender: AnyObject) {
        textView.resignFirstResponder()
        pickerCollectionView_height_cons.constant = screen_width + 44
    }
    // MARK:- 自定义属性
    private lazy var cpTitleView : ComposeTitleView = ComposeTitleView()
    
    // MARK:- 系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI界面
        setupNavigationItem()
        //监听键盘弹出
        setupNotification()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    deinit {
        //移除键盘
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
}

// MARK:- 设置UI界面
extension ComposeViewController {
    private func setupNavigationItem() {
        //取消itme
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(ComposeViewController.cancleItemClick))
        //发送item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.enabled = false
        //设置titleView
        cpTitleView.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        navigationItem.titleView = cpTitleView
    }
    private func setupNotification() {
        //监听键盘
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
}

// MARK:- 事件监听
extension ComposeViewController {
    @objc private func cancleItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick() {
        print("点击发送")
    }
}

// MARK:- UITextView代理方法
extension ComposeViewController : UITextViewDelegate {
    //内容改变监听
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    //滚动监听
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
}

// MARK:-  键盘监听方法
extension ComposeViewController {
    @objc private func keyboardDidChangeFrame(info : NSNotification) {
        //1.获取动画执行时间
        let duration = info.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        //2.获取键盘最终Y值
        let endFrame = (info.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = endFrame.origin.y
        
//        pickerCollectionView_height_cons.constant = y == screen_height ? screen_width + 44 : 0
        //3.计算工具栏距离底部的距离
        let space = screen_height - y
        toolBar_bottom_cons.constant = space
        //4.执行动画
        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
    }
}
