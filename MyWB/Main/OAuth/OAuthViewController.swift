//
//  OAuthViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/11.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupWebView()
    }
}

// MARK:- 设置UI
extension OAuthViewController {
    /// 设置导航栏外观
    private func setupNavigationBar() {

        /// 返回按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OAuthViewController.backItem))
        /// 填充按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OAuthViewController.fillItem))
    }
    /// 设置webVeiw
    private func setupWebView(){
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(app_Key)&redirect_uri=\(app_redirect_uri)")!))

    }
}

// MARK:- 事件监听
extension OAuthViewController {
    /// 隐藏该控制器
    @objc private func backItem(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /// 填充登录信息
    @objc private func fillItem(){
        // 书写js代码
        let jsCode = "document.getElementById('userId').value='18890677012';document.getElementById('passwd').value='ZB18890677012';"
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK:- UIWebViewDelegate代理方法监听
extension OAuthViewController:UIWebViewDelegate{
    /// 开始加载
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    /// 加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    /// 加载失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        SVProgressHUD.dismiss()
    }
    /// 
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let url = request.URL else {
            return true
        }
        let urlStr = url.absoluteString
        guard urlStr!.containsString("code=") else {
            return true
        }
        //截取字符串
        let code = urlStr!.componentsSeparatedByString("code=").last
        //发送获取access_token的网络请求
        NetworkTools.shareInstance.requestAccessToken(code!) { (result, error) -> () in
            if error != nil {
                print(error)
                return
            }
            //将字典封装成模型
            let account = UserAccount(dict: result!)
            //发送获取用户信息的请求
            self.loadUserInfo(account)
        }
        return false
    }
    ///请求用户信息
    private func loadUserInfo(account : UserAccount){
        //Access_token
        guard let accessToken = account.access_token else{
            return
        }
        //uid
        guard let uid = account.uid else{
            return
        }
        //发送获取用户信息的网络请求
        NetworkTools.shareInstance.requestUserInfo(accessToken, uid: uid) { (result, error) -> () in
            //1.错误校验
            if error != nil {
                print(error)
                return
            }
            //2.拿到用户信息的结果
            guard let userInfoDict = result else{
                return;
            }
            //3.将用户头像和昵称保存到模型中
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            //4.利用归档将用户模型进行本地持久化存储
            //4.1.获取沙盒路径
            let accountPath = UserAccountViewModel.shareInstan.accountPath
            //4.2.保存模型对象
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
            
            // 保存到单利对象中
            UserAccountViewModel.shareInstan.account = account
            
            //6.退出当前控制器
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                //7.完成退出后弹出欢迎界面
                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
            })
        }
    }
}
