//
//  MainTabBarController.swift
//  Pitaya
//
//  Created by Eric Lin on 2022/10/14.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    enum TabBarTab: Int, CaseIterable {
        case products = 0
        case friends
        case home
        case manage
        case setting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let tabbarAppearance = UITabBarAppearance()
        tabbarAppearance.backgroundColor = .white
        UITabBar.appearance().tintColor = .hotPinkColor
        UITabBar.appearance().scrollEdgeAppearance = tabbarAppearance
        UITabBar.appearance().standardAppearance = tabbarAppearance
        
        setUpChildViewControllers()
    }
    
    /// setUp Candid Wallet TabBar
    func setUpChildViewControllers() {
        let firstViewController = UIViewController()
        // 錢錢
        addChildViewController(childController: firstViewController,
                               image: "icTabbarProductsOff",
                               selectedImage: "icTabbarProductsOff",
                               tag: .products)
        
        // 朋友
        let secondViewController = FriendsViewController()
        addChildViewController(childController: secondViewController,
                               image: "icTabbarFriendsOn",
                               selectedImage: "icTabbarFriendsOn",
                               tag: .friends)
        // 首頁
        let thirdViewController = UIViewController()
        addChildViewController(childController: thirdViewController,
                               image: "icTabbarHomeOff",
                               selectedImage: "icTabbarHomeOff",
                               tag:  .home)
        
        // 記帳
        let fourthViewController = UIViewController()
        addChildViewController(childController: fourthViewController,
                               image: "icTabbarManageOff",
                               selectedImage: "icTabbarManageOff",
                               tag:  .manage)

        // 設定
        let fifthViewController = UIViewController()
        addChildViewController(childController: fifthViewController,
                               image: "icTabbarSettingOff",
                               selectedImage: "icTabbarSettingOff",
                               tag:  .setting)
    }
    
    /// This function is a helper method used to add a child view controller to the Tab Bar.
    /// - Parameters:
    ///   - childController: The view controller to be added as a child to the Tab Bar.
    ///   - image: TabBar 未選中時的 image.
    ///   - selectedImage: TabBar 選中時的 image.
    ///   - title: The title of the tab (not visible if left empty).
    ///   - tag:  目前 ViewController 的 tag
    func addChildViewController(childController: UIViewController,
                                image: String,
                                selectedImage: String,
                                tag: TabBarTab) {
        
        childController.tabBarItem.image = UIImage.init(named: image)
        childController.tabBarItem.selectedImage = UIImage.init(named: selectedImage)
        childController.tabBarItem.tag = tag.rawValue
        
        let navigationController = UINavigationController(rootViewController: childController)
        
        self.addChild(navigationController)
    }
}

//MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 點選皆回到首層
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
