//
//  TabBarViewController.swift
//  Picster
//
//  Created by mac 2019 on 1/17/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    
    private func configureTabs(){
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: ProfileViewController())
        
        vc1.tabBarItem = UITabBarItem(title: HomeViewController.title, image: UIImage(systemName: "house"), tag: 1)
        vc2.tabBarItem = UITabBarItem(title: ProfileViewController.title, image: UIImage(systemName: "person"), tag: 3)
        
        setViewControllers([vc1, vc2], animated: true)
        tabBar.tintColor = .label
        setTabBarBGColor()
    }
    
    
    private func setTabBarBGColor(){
        let isDarkStyle = traitCollection.userInterfaceStyle == .dark
        tabBar.backgroundColor = .systemGray.withAlphaComponent(isDarkStyle ? 0.2 : 0.8)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle{
            setTabBarBGColor()
        }
    }

}

