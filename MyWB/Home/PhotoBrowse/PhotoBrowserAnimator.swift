//
//  PhotoBrowserAnimator.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/26.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

// MARK:- 面向协议开发
//弹出视图动画代理
protocol PhotoBrowserAnimatorPresentDelegate {
    func imageViewForPresent(indexPath : NSIndexPath) -> UIImageView
    func startRectForPresent(indexPath : NSIndexPath) -> CGRect
    func endRectForPresent(indexPath : NSIndexPath) -> CGRect
}
//消失视图动画代理
protocol PhotoBrowserAnimatorDismissDelegate {
    func imageViewForDismiss(indexPath : NSIndexPath) -> UIImageView
    func indexPathForDismiss() -> NSIndexPath
}

class PhotoBrowserAnimator: NSObject {
    private var isPresent = false
    var presentDelegate : PhotoBrowserAnimatorPresentDelegate?
    var dismissDelegate : PhotoBrowserAnimatorDismissDelegate?
    var indexPath : NSIndexPath? = NSIndexPath()
    var pic_urls : [NSURL] = [NSURL]()
    
}

extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animateTransitionForPresent(transitionContext)
        }else{
            animateTransitionForDismiss(transitionContext)
        }
    }
}

extension PhotoBrowserAnimator {
    private func animateTransitionForPresent(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate , let indexPath = indexPath  else {
            return
        }
        //获取弹出视图
        let presentView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        //将弹出动画添加到视图容器中
        transitionContext.containerView().addSubview(presentView)
        
        //创建一个UIImageView
        let imageView = presentDelegate.imageViewForPresent(indexPath)
        let startRect = presentDelegate.startRectForPresent(indexPath)
        imageView.frame = startRect
        transitionContext.containerView().addSubview(imageView)
        transitionContext.containerView().backgroundColor = UIColor.blackColor()
        presentView.alpha = 0.0
        //执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            imageView.frame = presentDelegate.endRectForPresent(indexPath)
            }, completion: { (_) in
                presentView.alpha = 1.0
                imageView.removeFromSuperview()
                transitionContext.containerView().backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
        })
    }
    
    private func animateTransitionForDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate ,let dismissDelegate = dismissDelegate else {
            return
        }
        //获取消失视图
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        //将消失视图添加到视图容器中
        transitionContext.containerView().addSubview(dismissView)
        let indexPath = dismissDelegate.indexPathForDismiss()
        let imageView = dismissDelegate.imageViewForDismiss(indexPath)
        transitionContext.containerView().addSubview(imageView)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            imageView.frame = presentDelegate.startRectForPresent(indexPath)
            dismissView.alpha = 0.0
            }, completion: { (_) in
                dismissView.removeFromSuperview()
                transitionContext.completeTransition(true)
        })
    }
}

 
