//
//  HomeViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
import SVProgressHUD

//https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.0069Ds3DR2cBwDebc36ab0744diShD

private let screen_Width : CGFloat = UIScreen.mainScreen().bounds.width

class HomeViewController: BaseViewController {
    
    // MARK:- 属性
    private var isPresented = false
    private lazy var titleButton = TitleButton(frame: CGRectZero)
    private lazy var popoverAnimator = PopoverAnimator()
    private lazy var photoBrowserAnimator = PhotoBrowserAnimator()
    private lazy var statusViewModels : [StatusesViewModel] = [StatusesViewModel]()
    private var tipLabel = UILabel() //提示Label
    
    // MARK:- 系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK:- 设置导航栏
        isLogin ? setNavigationBar() : setupViewWithNOLogin()
        // MARK:- 数据请求
        requestHomeData(true)
        
        setupNotifiction()
        setupTipLabel()
        setupRefreshHeaderView()
        setupRefreshFooterView()
//        tableView.rowHeight = UITableViewAutomaticDimension  //自动计算cell高度的属性
        tableView.estimatedRowHeight = 200
    }
    
    private func setupTipLabel(){
        tipLabel.frame = CGRect(x: 0, y: 30, width: screen_Width, height: 32)
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.hidden = true
        navigationController?.navigationBar.subviews.first?.addSubview(tipLabel)
    }
    
    private func showTipLabel(newDataCount : Int) {
        if newDataCount == 0 {
            return
        }
        tipLabel.text = newDataCount > 0 ? "新增\(newDataCount)条数据" : "暂无数据更新"
        UIView.animateWithDuration(1.0, animations: {
            self.tipLabel.hidden = false
            self.tipLabel.frame.origin.y = 64
            print(self.tipLabel.frame)
            }, completion: { (_) in
                UIView.animateWithDuration(1.0, delay: 1.5, options: [], animations: { 
                    self.tipLabel.frame.origin.y = 30
                    }, completion: { (_) in
                        self.tipLabel.hidden = true
                })
        })
    }
}

// MARK:- 网络请求
extension HomeViewController {
    func requestHomeData(isNewData : Bool){
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = statusViewModels.first?.status?.mid ?? 0
        }else{
            max_id = statusViewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["access_token" : UserAccountViewModel.shareInstan.account?.access_token ?? "",
                          "since_id" : "\(since_id)",
                          "max_id" : "\(max_id)"]
        SVProgressHUD.show()
        NetworkTools.shareInstance.request(.GET, urlString: url, parameters: parameters) { (result, error) -> () in
            if(error != nil){
                SVProgressHUD.dismiss()
                print(error)
                return
            }
            guard let result = result else {
                return
            }
            //解析数据
            let resultDict = result as? [String : AnyObject]
            let resultArray = resultDict!["statuses"] as! [[String : AnyObject]]
            //创建一个零时数组用来存储最新请求到的数据
            var newDataArray : [StatusesViewModel] = [StatusesViewModel]()
            for dict in resultArray {
                let statusModel = StatusesModel(dict: dict)
                let statusViewModel = StatusesViewModel(statuses: statusModel)
                newDataArray.append(statusViewModel)
            }
            if isNewData {
                self.statusViewModels = newDataArray + self.statusViewModels
            }else{
                self.statusViewModels = self.statusViewModels + newDataArray
            }
            //缓存图片
            self.cacheImages(newDataArray)
        }
    }
    
    private func cacheImages(viewModels : [StatusesViewModel]) {
        //创建线程组
        let group = dispatch_group_create()
        
        for viewModel in viewModels {
            if let pic_urls = viewModel.pic_urlArray {
                for picURL in pic_urls {
                    //进入线程组
                    dispatch_group_enter(group)
                    //下载图片
                    SDWebImageManager.sharedManager().downloadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                        dispatch_group_leave(group)
                    })
                }
            }
        }
        
        //线程组通知
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
            //关闭刷新头
            self.tableView.mj_header.endRefreshing()
            //关闭刷新尾
            self.tableView.mj_footer.endRefreshing()
            //刷新表格
            self.tableView.reloadData()
            //弹出提示框
            self.showTipLabel(viewModels.count)
        }
    }
}

// MARK:- TableView数据源代理方法
extension HomeViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusViewModels.count;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (statusViewModels[indexPath.row].status?.cellHeight)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell") as! HomeTableViewCell
        let statusViewModel = statusViewModels[indexPath.row]
        cell.viewModel = statusViewModel
        return cell
    }
}

// MARK:-  设置UI（未登录状态）
extension HomeViewController {
    func setupViewWithNOLogin() {
        ///  添加旋转动画
        visitorView.addRotationAnimation()
    }
}

// MARK:-  设置导航栏（已登录状态）
extension HomeViewController {
    ///  设置导航条左侧和右侧按钮
    private func setNavigationBar(){
        ///  设置左侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        ///  设置右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        ///  设置导航条titleView
        navigationItem.titleView = titleButton
        titleButton.addTarget(self, action: #selector(HomeViewController.clickTitleButton(_:)), forControlEvents: .TouchUpInside)
    }
    //设置刷新头
    private func setupRefreshHeaderView() {
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewData))
        refreshHeader.setTitle("死命加载中...", forState: .Idle)
        refreshHeader.setTitle("撒手就加载", forState: .Pulling)
        tableView.mj_header = refreshHeader
    }
    //刷新头监听方法
    @objc private func loadNewData() {
        requestHomeData(true)
    }
    
    //设置刷新尾
    private func setupRefreshFooterView() {
        let refreshFooter = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadOldData))
        tableView.mj_footer = refreshFooter
    }
    //刷新尾监听方法
    @objc private func loadOldData() {
        requestHomeData(false)
    }
}

// MARK:-  事件监听
extension HomeViewController {
        
    ///  titleButton按钮事件监听
    @objc private func clickTitleButton(sender : UIButton){
        //改变按钮选择状态
        popoverAnimator.closure {(isPresented) -> (Void) in
            sender.selected = isPresented
        }
        //创建控制器
        let titleVC = PopoverViewController()
        //设置控制器弹出样式
        titleVC.modalPresentationStyle = .Custom
        //设置转场代理
        titleVC.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRectMake((UIScreen.mainScreen().bounds.size.width - 180)/2, 55, 180, 250)
        //弹出控制器
        presentViewController(titleVC, animated: true, completion: nil)
    }
}

// MARK:- 通知中心
extension HomeViewController {
    private func setupNotifiction() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.showPhotoBrowserAction(_:)), name: showPhotoBrowserNote, object: nil)
    }
    @objc private func showPhotoBrowserAction(info : NSNotification) {
        guard let note = info.userInfo ,object = info.object else {
            return
        }
        let pic_urls = note["pic_urls"] as! [NSURL]
        let indexPath = note["indexPath"] as! NSIndexPath
        let photoBrowserVc = PhotoBrowseViewController(photo_urls: pic_urls, indexPath: indexPath)
        photoBrowserVc.modalPresentationStyle = .Custom
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.pic_urls = pic_urls
        photoBrowserAnimator.presentDelegate = object as! PicCollectionView
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        presentViewController(photoBrowserVc, animated: true, completion: nil)
    }
}



