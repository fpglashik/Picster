//
//  HomeViewController.swift
//  Picster
//
//  Created by mac 2019 on 1/17/24.
//

import UIKit

class HomeViewController: UIViewController{
    static var title = "Home"
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        configure()
    }
    
    
    private func configure(){
        if UserPreferenceManager.shared.isTopicPreferenceExist(){
            loadContents()
        }
        else{
            let preferenceVC = UserPreferenceViewController()
            preferenceVC.dismissDelegate = self
            present(preferenceVC, animated: true)
        }
    }
    
    private func loadContents(){
        print("load contents here")
    }
}


extension HomeViewController: UserPreferenceDelegate{
    
    func onDismiss() {
        loadContents()
    }
    
}
