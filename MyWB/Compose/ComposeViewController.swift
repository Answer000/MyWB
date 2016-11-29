//
//  ComposeViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/12.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SVProgressHUD

private let screen_width = UIScreen.mainScreen().bounds.width
private let screen_height = UIScreen.mainScreen().bounds.height

class ComposeViewController: UIViewController {
    
    // MARK:- 约束属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var toolBar_bottom_cons: NSLayoutConstraint!
    @IBOutlet weak var pickerCollectionView_height_cons: NSLayoutConstraint!
    @IBOutlet weak var pickerCollectionView: PickerCollectionView!
    
    @IBAction func pictureButtonClick(sender: AnyObject) {
        textView.resignFirstResponder()
        pickerCollectionView_height_cons.constant = screen_width + 44
    }
    @IBAction func emojiButtonClick(sender: AnyObject) {
        //1.textView放弃第一响应者
        textView.resignFirstResponder()
        //2.将默认键盘替换成表情键盘:inputView为nil时恢复为默认键盘
        textView.inputView = textView.inputView != nil ? nil : emojiVC.view
        //3.textView成为第一响应者
        textView.becomeFirstResponder()
    }
    
    // MARK:- 自定义属性
    private lazy var cpTitleView : ComposeTitleView = ComposeTitleView()
    private lazy var images : [UIImage] = [UIImage]()
    private lazy var emojiVC : EmojiViewController = EmojiViewController { [weak self] (emoji) in
        //获取传递的表情
        self!.textView.insertEmojiToTextView(emoji)
        
        //隐藏提示文字
        self!.textView.placeHolderLabel.hidden = true
        self!.navigationItem.rightBarButtonItem?.enabled = true
    }
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
        //监听照片选择控制器通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.pickerAddPhotoNotificationClick(_:)), name: pickerAddPhotoNote, object: nil)
        //监听删除照片通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.pickerDelectPhotoNotificationClick(_:)), name: pickerdelectPhotoNote, object: nil)
    }
}

// MARK:- 照片选择控制器监听方法
extension ComposeViewController {
    @objc private func pickerAddPhotoNotificationClick(info : NSNotification) {
        //1.判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        //2.初始化照片选择控制器
        let pickerVC = UIImagePickerController()
        //3.设置照片源
        pickerVC.sourceType = .PhotoLibrary
        //4.设置代理
        pickerVC.delegate = self
        //跳转到照片选择控制器
        presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    @objc private func pickerDelectPhotoNotificationClick(info : NSNotification) {
        //1.校验
        guard let delectImage = info.object as? UIImage else {
            return
        }
        //2.获取图片
        guard let index = images.indexOf(delectImage) else {
            return
        }
        //3.删除图片
        images.removeAtIndex(index)
        //4.将图片数组传到PickerCollectionView
        pickerCollectionView.images = images
    }
}

// MARK:- UIImagePickerControllerDelegate代理方法
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //1.获取选择的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //2.存放到数组
        images.append(image)
        //将照片数组传到PickerCollectionView
        pickerCollectionView.images = images
        //退出照片选择控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK:- 事件监听
extension ComposeViewController {
    //取消按钮监听事件
    @objc private func cancleItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //发送按钮监听事件
    @objc private func sendItemClick() {
        //隐藏键盘
        self.textView.resignFirstResponder()
        
        let closureBack = {(isSuccess : Bool) in
            if !isSuccess {
                SVProgressHUD.showErrorWithStatus("发送失败")
                return
            }
            SVProgressHUD.showSuccessWithStatus("发送成功")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        //获取发送的图片
        if let image = images.first {
            //发送微博且附带图片
            NetworkTools.shareInstance.sendStatus(self.textView.getEmojiString(), image: image, isSuccess: closureBack)
        }else{
            //发送微博（不带图片）
            NetworkTools.shareInstance.sendStatus(self.textView.getEmojiString(), isSuccess: closureBack)
        }
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
        
        //3.计算工具栏距离底部的距离
        let space = screen_height - y
        toolBar_bottom_cons.constant = space
        //4.执行动画
        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
    }
}
