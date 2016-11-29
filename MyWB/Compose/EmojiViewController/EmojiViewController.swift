//
//  EmojiViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/18.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

private let screen_width = UIScreen.mainScreen().bounds.width
private let screen_heigth = UIScreen.mainScreen().bounds.height
private let itemWH = screen_width / 7
private let emojiCell   = "emojiCell"

class EmojiViewController: UIViewController {

    // MARK:- 自定义属性
    private lazy var toolBar = UIToolbar()
    private lazy var emojiCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmojiCollectionViewLayout())
    private lazy var emojiManager = EmojiManager()
    //传递表情给外界的闭包
    private var callClosure : (emoji : Emojis)->()
    //回调属性
    var callBackEmoji : ((emoji : Emojis) -> ())?
    // MARK:- 系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK:- 重写构造函数
    init(callClosure : (emoji : Emojis)->()) {
        self.callClosure = callClosure
        //必须实现方法
        super.init(nibName: nil, bundle: nil)
    }
    // MARK:- 重写构造函数必须实现的方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI
extension EmojiViewController{
    private func setupLayout() {
        //添加子控件
        view.addSubview(emojiCollectionView)
        view.addSubview(toolBar)
        //设置布局
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["toolBar" : toolBar,"emojiCollectionView" : emojiCollectionView]
        var emojiCons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[emojiCollectionView]-0-|", options: [], metrics: nil, views: views)
        emojiCons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[emojiCollectionView]-0-[toolBar]-0-|", options: [.AlignAllLeft,.AlignAllRight], metrics: nil, views: views)
        view.addConstraints(emojiCons)
        
        //设置collectionView
        setupCollectionView()
        //设置toolBar
        setupToolBar()
    }
    private func setupCollectionView() {
        
        //注册cell
        emojiCollectionView.registerClass(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: emojiCell)
        //设置代理
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        //设置背景色
        emojiCollectionView.backgroundColor = UIColor.clearColor()
    }
    private func setupToolBar() {
        let titles = ["最近","默认","Emoji","浪小花"];
        
        var tempItems = [UIBarButtonItem]()
        for i in 0 ..< titles.count {
            let item = UIBarButtonItem(title: titles[i], style: .Plain, target: self, action: #selector(EmojiViewController.itemClick(_:)))
            item.tag = i + 1000
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        // 3.设置toolBar的items数组
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orangeColor()
    }
}

// MARK:- 事件监听
extension EmojiViewController {
    @objc private func itemClick(item : UIBarButtonItem) {
        let section = item.tag - 1000
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        emojiCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
}

// MARK:- collectionView代理方法
extension EmojiViewController : UICollectionViewDataSource ,UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emojiManager.emojiPackges.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiManager.emojiPackges[section].emojis.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(emojiCell, forIndexPath: indexPath) as! EmojiCollectionViewCell
        cell.emoji = emojiManager.emojiPackges[indexPath.section].emojis[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //获取点击的表情
        let emoji = emojiManager.emojiPackges[indexPath.section].emojis[indexPath.item]
        //插入表情
        insertEmotion(emoji)
        //将表情回调到控制器
        callClosure(emoji: emoji)
    }
    // MARK:- 插入表情方法
    private func insertEmotion(emoji : Emojis) {
        //空白表情或删除表情不需要插入
        if emoji.isRemove || emoji.isEmpty {
            return
        }
        //判断该表情是否已存在
        if emojiManager.emojiPackges.first!.emojis.contains(emoji){
            //如果已经存在,先获取该表情下标值
            let index = emojiManager.emojiPackges.first?.emojis.indexOf(emoji)
            //根据下标值删除该表情
            emojiManager.emojiPackges.first?.emojis.removeAtIndex(index!)
        }else{
            //如果不存在，将最后一个表情删除
            emojiManager.emojiPackges.first?.emojis.removeAtIndex(19)
        }
        //将表情插入到第一个
        emojiManager.emojiPackges.first?.emojis.insert(emoji, atIndex: 0)
    }
}


// MARK:- 自定义布局
class EmojiCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        //设置属性
        collectionView!.showsVerticalScrollIndicator = false
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.pagingEnabled = true
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}
