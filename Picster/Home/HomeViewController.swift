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
        if UserPreferenceManager.isTopicPreferenceExist(){
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
        Task{
            await FlickrApiCaller.shared.getFeed(for: 1) { result in
                switch result{
                case .success(let items):
                    items.forEach{
                        print($0.title)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}


extension HomeViewController: UserPreferenceDelegate{
    
    func onDismiss() {
        loadContents()
    }
    
}
