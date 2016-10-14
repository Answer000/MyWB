//
//  PopoverAnimator.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/8.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    // MARK:- 属性
    var presentedFrame : CGRect = CGRectZero
    private var isPresented = false
    
    // 声明一个闭包，用于传递消息
    var closure : ((isPresented : Bool)->(Void))?
    func closure(isPresentClosure : (Bool) -> (Void)){
        closure = isPresentClosure
    }
}

//MARK:-  自定义转场代理方法：UIViewControllerTransitioningDelegate
extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    // 目的：改变弹出view的尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        // 返回自定义转场控制器
        let presentationController =  CustomPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentationController.presentedFrame = presentedFrame
        return presentationController
    }
    
    // 目的：自定义弹出的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        // 返回一个遵守UIViewControllerAnimatedTransitioning协议的对象
        return self
    }
    
    // 目的：自定义消失动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        // 返回一个遵守UIViewControllerAnimatedTransitioning协议的对象
        return self
    }
}

// MARK:- UIViewControllerAnimatedTransitioning
extension PopoverAnimator:UIViewControllerAnimatedTransitioning {
    //动画执行事件
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.23
    }
    // 获取“转场上下文”：可以通过转场上下文获取弹出的view和消失的View
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        closure!(isPresented : isPresented)
        
        // 根据isPresented来判断是弹出还是消息View
        isPresented ? animationPresentedView(transitionContext) : animationDismissedView(transitionContext)
    }
    // 自定义弹出动画
    func animationPresentedView(transitionContext: UIViewControllerContextTransitioning){
        // 获取弹出的View
        // UITransitionContextFromViewKey:消失的View
        // UITransitionContextToViewKey:弹出的View
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 将弹出的View添加到containeView中
        transitionContext.containerView().addSubview(presentedView)
        
        // 执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        // 设置毛点（默认从中间开始）
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            presentedView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                //必须告诉转场上下文动画已经完成
                transitionContext.completeTransition(true)
        }
    }
    // 自定义消失动画
    func animationDismissedView(transitionContext: UIViewControllerContextTransitioning){
        
        // 获取消失的View
        let dismissedView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        // 添加消失动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            dismissedView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
            }) { (_) -> Void in
                //必须告诉转场上下文动画已经完成
                transitionContext.completeTransition(true)
        }
    }
}
