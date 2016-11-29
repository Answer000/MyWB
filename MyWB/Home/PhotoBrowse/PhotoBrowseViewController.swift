//
//  PhotoBrowseViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/25.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

let screenBounds = UIScreen.mainScreen().bounds
private let photoBrowserCell = "photoBrowserCell"

class PhotoBrowseViewController: UIViewController {

    // MARK:- 自定义属性
    var indexPath : NSIndexPath
    var photo_urls : [NSURL] = [NSURL]()
    
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserCollectionFlowViewLayout())
    private lazy var closeBtn = UIButton(type: .Custom)
    private lazy var saveBtn = UIButton(type: .Custom)
    //构造函数
    init(photo_urls : [NSURL] ,indexPath : NSIndexPath) {
        self.photo_urls = photo_urls
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //系统回调方法
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // 2.滚动到对应的图片
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    //隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        super.prefersStatusBarHidden()
        return true
    }
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        super.preferredStatusBarUpdateAnimation()
        return .Slide
    }
}

// MARK:- 设置UI
extension PhotoBrowseViewController {
    private func setupUI() {
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        //设置代理
        collectionView.dataSource = self
        //注册cell
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCell)
        //设置frame
        collectionView.frame = view.bounds
        closeBtn.frame = CGRectMake(30, screenBounds.height - 30 - 25, 60, 25)
        saveBtn.frame = CGRectMake(screenBounds.width - 30 - 60, screenBounds.height - 30 - 25, 60, 25)
        //设置标题
        closeBtn.setTitle("关 闭", forState: .Normal)
        saveBtn.setTitle("保 存", forState: .Normal)
        //设置字体
        closeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        saveBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        //设置背景色
        closeBtn.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        saveBtn.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        
        closeBtn.addTarget(self, action: #selector(PhotoBrowseViewController.closeClick), forControlEvents: .TouchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowseViewController.saveClick), forControlEvents: .TouchUpInside)
    }
}

// MARK:-  UICollectionViewCell 代理方法
extension PhotoBrowseViewController : UICollectionViewDataSource ,ImageViewClickDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo_urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCell, forIndexPath: indexPath) as! PhotoBrowserCell
        cell.photoURL = photo_urls[indexPath.item]
        cell.delegate = self
        return cell
    }
}

// MARK:- 事件监听
extension PhotoBrowseViewController {
    //关闭按钮监听事件
    @objc func closeClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //保存按钮监听事件
    @objc func saveClick() {
        //获取当前展示的图片
        let cell = collectionView.visibleCells().first as! PhotoBrowserCell
        let image = cell.imgView.image
        //校验
        guard let img = image else {
            return
        }
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(PhotoBrowseViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image image : UIImage,didFinishSavingWithError error : NSError?,contextInfo : AnyObject) {
        let statuInfo : String
        if error != nil {
            statuInfo = "保存失败"
        }else{
            statuInfo = "保存成功"
        }
        SVProgressHUD.showInfoWithStatus(statuInfo)
    }
    func imageViewClick() {
        closeClick()
    }
}

// MARK:- PhotoBrowserAnimatorDismissDelegate代理方法
extension PhotoBrowseViewController : PhotoBrowserAnimatorDismissDelegate {
    func imageViewForDismiss(indexPath: NSIndexPath) -> UIImageView {
        let imageView = UIImageView()
        let cell = collectionView.visibleCells().first as! PhotoBrowserCell
        imageView.frame = cell.imgView.frame
        imageView.image = cell.imgView.image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func indexPathForDismiss() -> NSIndexPath {
        let cell = collectionView.visibleCells().first!
        let indexPath = collectionView.indexPathForCell(cell)!
        return indexPath
    }
}

// MARK:- 设置布局layout
class PhotoBrowserCollectionFlowViewLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        //设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        //设置collectionView属性
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}


