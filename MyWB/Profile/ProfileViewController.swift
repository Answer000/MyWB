//
//  ProfileViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

//批量获取用户的粉丝数、关注数、微博数
private let usersCountsUrlStr : String = "https://api.weibo.com/2/users/show.json"

private let profileDefaultCell : String = "profileDefaultCell"
private let profileFirstCell : String = "profileFirstCell"

class ProfileViewController: BaseViewController {

    private lazy var sectionArr : [[[String : String]]] =
        [[["image":(UserAccountViewModel.shareInstan.account?.avatar_large)!,"nickName":(UserAccountViewModel.shareInstan.account?.screen_name)!]],
        [["title":"新的好友","icon":"tabbar_profile_highlighted"]],
        [["title":"我的相册","icon":"tabbar_profile_highlighted"],["title":"我的点评","icon":"tabbar_profile_highlighted"],["title":"我的赞","icon":"tabbar_profile_highlighted"]],
        [["title":"微博钱包","icon":"tabbar_profile_highlighted","detailtext":"新手一分夺豪礼"],["title":"微博运动","icon":"tabbar_profile_highlighted","detailtext":"每天10000步，你达标了吗?"]],
        [["title":"粉丝头条","icon":"tabbar_profile_highlighted","detailtext":"推广博文及账号的利器"],["title":"粉丝服务","icon":"tabbar_profile_highlighted","detailtext":"橱窗、私信、营销、数据助手"]],
        [["title":"草稿箱","icon":"tabbar_profile_highlighted"]],
        [["title":"更多","icon":"tabbar_profile_highlighted","detailtext":"文章、收藏"]]]
    private var countsModel : ProfileCountsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        ///  打开滚动属性
        visitorView.scrollEnabled = true
        ///  设置访客视图信息
        visitorView.setupVisitorViewInfo(iconName:"visitordiscover_image_profile", tip: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人" ,isHide_bgImgView: false)
        if isLogin {
            setupUI()
            requestUsersCounts()
        }
    }
}

// MARK:- UI设置
extension ProfileViewController {
    private func setupUI() {
        //隐藏tableView的分割线
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        //注册cell
        tableView.registerClass(ProfileDefaultCell.self, forCellReuseIdentifier: profileDefaultCell)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"设置", style: .Plain, target: self, action: #selector(ProfileViewController.settingClick))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友", style: .Plain, target: self, action: #selector(ProfileViewController.addFriendsClick))
    }
}

// MARK:- 事件监听
extension ProfileViewController {
    //设置按钮监听事件
    @objc private func settingClick() {
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingVC, animated: true)
    }
    //添加好友按钮监听事件
    @objc private func addFriendsClick() {
        
    }
}

// MARK:- tableView
extension ProfileViewController  {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionArr.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArr[section].count
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.000001
        }
        return 10.0
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 154
        }
        return 44
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var firstCell = tableView.dequeueReusableCellWithIdentifier(profileFirstCell) as? ProfileFirstCell
            if firstCell == nil {
                firstCell = NSBundle.mainBundle().loadNibNamed("ProfileFirstCell", owner: nil, options: nil)?.first as? ProfileFirstCell
            }
            firstCell?.selectionStyle = .None
            firstCell?.firstDict = sectionArr[indexPath.section][indexPath.row]
            firstCell?.countsModel = countsModel
            return firstCell!
        }else{
            let defaultcell = tableView.dequeueReusableCellWithIdentifier(profileDefaultCell) as! ProfileDefaultCell
            defaultcell.selectionStyle = .None
            defaultcell.defaultDict = sectionArr[indexPath.section][indexPath.row]
            return defaultcell
        }
    }
}

// MARK:- 网络请求(批量获取用户的粉丝数、关注数、微博数)
extension ProfileViewController {
    private func requestUsersCounts() {
        let params = ["access_token" : UserAccountViewModel.shareInstan.account?.access_token ?? "",
                      "uids" : UserAccountViewModel.shareInstan.account?.uid ?? "",
                      "screen_name" : UserAccountViewModel.shareInstan.account?.screen_name ?? ""]
        NetworkTools.shareInstance.request(.GET, urlString: usersCountsUrlStr, parameters: params) { (result, error) in
            if error != nil {
                return
            }
            let countDict = result as! [String : AnyObject]
            self.countsModel = ProfileCountsModel(dict: countDict)
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
    }
}


// MARK:- ProfileDefaultCell
class ProfileDefaultCell : UITableViewCell {
    //自定义
    private lazy var iconImgView : UIImageView = UIImageView()
    private lazy var textlabel : UILabel = UILabel()
    private lazy var detailtextlabel : UILabel = UILabel()
    private lazy var moreImgView : UIImageView = UIImageView()
    
    lazy var line : UIView = UIView()
    var defaultDict : [String : String]? {
        didSet{
            guard let dict = defaultDict else {
                return
            }
            let image = UIImage(named: dict["icon"]!)
            iconImgView.image = image
            textlabel.text = dict["title"]
            detailtextlabel.text = dict["detailtext"]
            moreImgView.image = UIImage(named: "mine_icon_membership_arrow")
            setupDefaultSubviews()
        }
    }
    
    private func setupDefaultSubviews() {
        //添加视图
        contentView.addSubview(iconImgView)
        contentView.addSubview(textlabel)
        contentView.addSubview(detailtextlabel)
        contentView.addSubview(line)
        contentView.addSubview(moreImgView)
        
        //UIFont
        textlabel.font = UIFont.systemFontOfSize(15)
        detailtextlabel.font = UIFont.systemFontOfSize(13)

        //Color
        textlabel.textColor = UIColor.darkTextColor()
        detailtextlabel.textColor = UIColor.lightGrayColor()
        line.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        
        //关闭自动布局
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        detailtextlabel.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        moreImgView.translatesAutoresizingMaskIntoConstraints = false

        //添加约束
        let views = ["iconImgView" : iconImgView, "textlabel" : textlabel, "detailtextlabel": detailtextlabel,"line" : line,"moreImgView" : moreImgView]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[iconImgView(24)]-9.5-[line(0.5)]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImgView(24)]-15-[textlabel]-10-[detailtextlabel]", options: [.AlignAllCenterY], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[line]-0-|", options: [], metrics: nil, views: ["line" : line])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[moreImgView(12)]-15-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:[moreImgView(12)]-15.5-[line]", options: [], metrics: nil, views: views)
        contentView.addConstraints(cons)
    }
}
