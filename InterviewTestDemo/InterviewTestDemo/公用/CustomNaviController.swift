//
//  CustomNaviController.swift
//  InterviewTestDemo
//
//  Created by NewApple on 2021/1/4.
//

import UIKit

class CustomNaviController: UINavigationController, UINavigationControllerDelegate,UIGestureRecognizerDelegate,UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.delegate = self

    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {

            let sel = #selector(backAction)

            if viewController.navigationItem.hidesBackButton {
                viewController.navigationItem.hidesBackButton = true
            }else {
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_return")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: sel)
            }
            viewController.hidesBottomBarWhenPushed = true
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            self.interactivePopGestureRecognizer!.delegate = self
        }
        else {
            self.interactivePopGestureRecognizer!.delegate = nil
        }
    }
    
    @objc func backAction() {
        self.popViewController(animated: true)
    }
    
    @objc func backPopAction() {
        self.popToRootViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

