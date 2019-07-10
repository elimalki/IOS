//
//  UIViewControllerExtension.swift
//  Talinor
//
//  Created by George Heints on 1/3/19.
//  Copyright © 2019 Organization. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
    //
    //    func hidenTabBar() {
    //        var frame = self.tabBarController?.tabBar.frame
    //        frame!.origin.y = self.view.frame.size.height + (frame?.size.height)!
    //        UIView.animate(withDuration: 0.5, animations: {
    //            self.tabBarController?.tabBar.frame = frame!
    //        })
    //    }
    //
    //    func shownTabBar() {
    //        var frame = self.tabBarController?.tabBar.frame
    //        frame!.origin.y = self.view.frame.size.height - (frame?.size.height)!
    //        UIView.animate(withDuration: 0.5, animations: {
    //            self.tabBarController?.tabBar.frame = frame!
    //        })
    //    }
    
    func hidenTabBar() {
        DispatchQueue.main.async {
            guard let frame = self.tabBarController?.tabBar.frame else { return }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tabBarController?.tabBar.frame.origin.y =  UIScreen.main.bounds.height + (frame.size.height)
            })
        }
        
    }
    
    func shownTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            guard let frame = self.tabBarController?.tabBar.frame else { return }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.height - (frame.size.height)
            })
        }
    }
    
    func showTabBar(){
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func hideTabBar(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showNavBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func hideNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func displayViewController(view: UIView, content: UIViewController, handler: (()->Void)? = nil) {
        self.addChild(content)
        view.addSubview(content.view)
        content.didMove(toParent: self)
        UIView.animate(withDuration: 0.3, animations: {
            content.view.alpha = 1
        }){ _ in
            handler?()
        }
    }
    
    func hideViewController(content: UIViewController, handler: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            content.view.alpha = 0
        }){_ in
            content.willMove(toParent: nil)
            content.view.removeFromSuperview()
            content.removeFromParent()
            handler?()
        }
    }
    
    func addKeyboardCheckStateForSuperScroll(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardCheckStateForSuperScroll(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard  let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let scrollView = (view.subviews.first{ $0 as? UIScrollView != nil}) as? UIScrollView else { return }
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 70, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let scrollView = (view.subviews.first{ $0 as? UIScrollView != nil}) as? UIScrollView else { return }
        
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func showOkAlert(with title: String = "Talinor", and message: String?, closure: (()->Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(_) in
            closure?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWith(question: String, success: @escaping (()->Void), failed: @escaping (()->Void)) {
        let alert = UIAlertController(title: "Talinor", message: question, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default, handler: { (_) in
            success()
        })
        let noAction = UIAlertAction(title: "NO", style: .default, handler: {(_) in
            failed()
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        //        if tabBarController?.selectedViewController == self ||
        //            navigationController?.presentedViewController == self ||
        //            navigationController?.visibleViewController == self ||
        //            navigationController?.topViewController == self{
        //
        //
        //        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWith(textField placeholder: String, message: String?, okTitle: String = "OK", cancelTitle: String = "Cancel",  complite: @escaping ((String?)->Void), failed: @escaping (()->Void)){
        let alert = UIAlertController(title: "Talinor", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .cancel, handler: {(_) in
            complite((alert.textFields![0] as UITextField).text)
        })
        
        let cancelAcrion = UIAlertAction(title: cancelTitle, style: .default, handler: {(_) in
            failed()
        })
        
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = placeholder
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAcrion)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithField(title: String? = "Talinor", textField placeholder: String, message: String?, complite: @escaping ((String?)->Void)){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {(_) in
            complite((alert.textFields![0] as UITextField).text)
        })
        
        let cancelAcrion = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = placeholder
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAcrion)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
    
}

extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
}
