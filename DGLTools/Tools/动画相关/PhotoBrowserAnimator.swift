//
//  PhotoBrowserAnimator.swift
//  02-PhotoBrowser(基本设置)
//
//  Created by 丁贵林 on 16/8/4.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

import UIKit

protocol PresentedProtocol : class {
    func getImageView(indexPath : NSIndexPath) -> UIImageView
    func getStartRect(indexPath : NSIndexPath) -> CGRect
    func getEndRect(indexPath : NSIndexPath) -> CGRect
}

protocol DismissProtocol : class {
    
    func getImageView() -> UIImageView
    func getIndexPath() -> NSIndexPath
    
}

class PhotoBrowserAnimator: NSObject {
    
    var isPresented = false
    var indexPath : NSIndexPath?
    
    weak var presentedDelegate : PresentedProtocol?
    weak var dismissDelegate : DismissProtocol?
}


//MARK: - 实现转场代理方法
extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    
    //告诉弹出动画交给谁去处理
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
}


//MARK: - 实现转场动画
extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    
    
    //1.决定动画执行时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    //2.决定动画如何执行
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(transitionContext)
        
        if isPresented {
            
            
            //1.nil值校验
            guard let indexPath = indexPath, presentedDelegate = presentedDelegate  else {
                return
            }
            
            //2.获取弹出的view
            let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            //3.执行动画
            //3.1获取执行动画的imageview
            let imageView = presentedDelegate.getImageView(indexPath)
            transitionContext.containerView()?.addSubview(imageView)
            
            //3.2设置imageview的起始位置
            imageView.frame = presentedDelegate.getStartRect(indexPath)
            
            //3.3执行动画
            transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
            UIView.animateWithDuration(duration, animations: {
                imageView.frame = presentedDelegate.getEndRect(indexPath)
                }, completion: { (_) in
                    //2.将弹出的View添加到containerView中
                    transitionContext.containerView()?.addSubview(presentedView)
                    transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
            
        } else {
            
            //0.控制校验
            guard let dismissDelegate = dismissDelegate, presentedDelegate = presentedDelegate else {
                return
            }
            
            //1.取出消失的动画
            let  dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
//            dismissView?.removeFromSuperview()
            
            //2.执行动画
            //2.1获取执行动画的imageview
            let imageView = dismissDelegate.getImageView()
            transitionContext.containerView()?.addSubview(imageView)
            
            //2.1取出indexPath
            let indexPath = dismissDelegate.getIndexPath()

            //2.3获取结束的位置
            let endRect = presentedDelegate.getStartRect(indexPath)
            
            dismissView?.alpha = endRect == CGRectZero ? 1.0 : 0.0
            
            //2.4执行动画
            UIView.animateWithDuration(duration, animations: { 
                
                if endRect == CGRectZero {
                    imageView.removeFromSuperview()
                    dismissView?.alpha = 0.0
                } else {
                    imageView.frame = endRect
                }
                
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
            

        }
    }

}