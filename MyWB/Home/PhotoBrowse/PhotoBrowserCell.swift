//
//  PhotoBrowserCell.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/25.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

// MARK:- 保存按钮点击代理
protocol ImageViewClickDelegate {
    func imageViewClick()
}

class PhotoBrowserCell: UICollectionViewCell {
    
    var delegate : ImageViewClickDelegate?
    
    // MARK:-  设置PhotoBrowserCell
    var photoURL : NSURL? {
        didSet{
            guard let photoURL = photoURL else {
                return
            }
            setupContent(photoURL)
        }
    }
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var imgView : UIImageView = UIImageView(frame: CGRectZero)
    private var scrollView : UIScrollView = UIScrollView(frame : CGRectZero)
    private var progressView : ProgressView = ProgressView()
}

extension PhotoBrowserCell {
    private func setupUI() {
        //添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imgView)
        //设置frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        scrollView.backgroundColor = UIColor.blackColor()
        
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.mainScreen().bounds.width * 0.5, y: UIScreen.mainScreen().bounds.height * 0.5)
        
        // 3.设置控件的属性
        progressView.hidden = true
        progressView.backgroundColor = UIColor.clearColor()
        
        imgView.contentMode = .ScaleToFill
        imgView.userInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCell.tapGestureClick)))
    }
    
    @objc private func tapGestureClick() {
        delegate?.imageViewClick()
    }
    
    private func setupContent(photoURL : NSURL?) {
        //校验
        guard let photoURL = photoURL else {
            return
        }
        let img = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(photoURL.absoluteString)
        progressView.hidden = false
        imgView.sd_setImageWithURL(getBigPhotoURL(photoURL), placeholderImage: img, options: [], progress: { (current, total) in
            self.progressView.progress = CGFloat(current)/CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.hidden = true
        }
        let imgSize = img.size
        let w : CGFloat = UIScreen.mainScreen().bounds.width
        let h : CGFloat = w/imgSize.width * imgSize.height
        var y : CGFloat = 0
        if h >= UIScreen.mainScreen().bounds.height {
            y = 0
        }else{
            y = (UIScreen.mainScreen().bounds.height - h) * 0.5
        }
        imgView.frame = CGRect(x: 0, y: y, width: w, height: h)
     
        // 5.设置scrollView的contentSize
        scrollView.contentSize = CGSize(width: 0, height: h)
    }
    
    private func getBigPhotoURL(smallURL : NSURL) -> NSURL {
        let smallURLString = smallURL.absoluteString
        let bigURLString  = smallURLString!.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        return NSURL(string: bigURLString)!
    }

}
