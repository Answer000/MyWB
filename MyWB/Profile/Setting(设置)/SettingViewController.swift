//
//  SettingViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/27.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

private let settingCell = "settingCell"
class SettingViewController: UIViewController {

    // MARK:- 自定义属性
    private lazy var tableView : UITableView = UITableView(frame: CGRectZero, style: .Plain)
    private lazy var sectionArr : [[String]] = [["账号管理","账号安全"],["通知","隐私","通用设置"],["清理缓存","意见反馈","关于微博"],["退出当前账号"]]
    
    // MARK:- 系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        setupUI()
    }
}

// MARK:- 设置UI
extension SettingViewController {
    private func setupUI() {
        //添加子控件
        view.addSubview(tableView)
        //设置frame
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        //设置代理
        tableView.dataSource = self
        tableView.delegate = self
        //取消分割线
        tableView.separatorStyle = .None
        //注册cell
        tableView.registerClass(SettingCell.self, forCellReuseIdentifier: settingCell)
    }
}

// MARK:- 数据源代理方法
extension SettingViewController : UITableViewDataSource ,UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionArr.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArr[section].count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(settingCell) as! SettingCell
        cell.mainText = sectionArr[indexPath.section][indexPath.row]
        cell.selectionStyle = .None
        if indexPath.section == (sectionArr.count - 1) {
            cell.mainTextLabel.textAlignment = .Center
            cell.mainTextLabel.textColor = UIColor.redColor()
        }else if indexPath.section == 2 && indexPath.row == 0 {
            cell.deputyTextLabel.text = getCacheSize()
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                print("账号管理")
            }else if(indexPath.row == 1){
                print("账号安全")
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                print("通知")
            }else if indexPath.row == 1 {
                print("隐私")
            }else if indexPath.row == 2{
                print("通用设置")
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                setupclearCacheAlertAction(indexPath)
            }else if indexPath.row == 1 {
                print("意见反馈")
            }else if indexPath.row == 2 {
                print("关于微博")
            }
        }else if indexPath.section == 3 {
            setupExitLoginAlertAction()
        }
    }
}
// MARK:- 清理缓存
extension SettingViewController  {
    private func setupclearCacheAlertAction(indexPath: NSIndexPath) {
        let alertVC = UIAlertController(title: "清理缓存", message: nil, preferredStyle: .Alert)
        let clearAction = UIAlertAction(title: "清理", style: .Default, handler: { (action) in
            self.clearCache()
            //刷新表格
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SettingCell
            cell.deputyTextLabel.text = self.getCacheSize()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Destructive, handler: nil)
        alertVC.addAction(cancelAction)
        alertVC.addAction(clearAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    private func getCacheSize() -> String {
        let cacheSize = String(format: "%.2f",CGFloat(SDWebImageManager.sharedManager().imageCache.getSize())/1024/1024)
        return cacheSize + "M"
    }
    private func clearCache() {
        SDWebImageManager.sharedManager().imageCache.clearDisk()
    }
}

// MARK:- 退出登录
extension SettingViewController  {
    private func setupExitLoginAlertAction() {
        let alertVC = UIAlertController(title: "退出登录", message: nil, preferredStyle: .Alert)
        let sureAction = UIAlertAction(title: "确定", style: .Default, handler: { (action) in
            let account = UserAccount(dict: [:])
            UserAccountViewModel.shareInstan.account = account
            print(UserAccountViewModel.shareInstan.isLogin)
            self.navigationController?.popToRootViewControllerAnimated(false)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Destructive, handler: nil)
        alertVC.addAction(cancelAction)
        alertVC.addAction(sureAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
}
