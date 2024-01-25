//
//  UserPreferenceManager.swift
//  Picster
//
//  Created by mac 2019 on 1/19/24.
//

import Foundation

class Constants{
    static let key_PreferredTopics = "PreferredTopics"
}

class UserPreferenceManager{
    
    static let shared = UserPreferenceManager()
    
    
    private init(){}
    
    
    public func getUserPreferredTopics() -> [String] {
        return UserDefaults.standard.object(forKey: Constants.key_PreferredTopics) as? [String] ?? []
    }
    
    
    public func setUserPreferredTopics(topics: [String]){
        UserDefaults.standard.setValue(topics, forKey: Constants.key_PreferredTopics)
    }
    
    
    public func isTopicPreferenceExist() -> Bool {
        UserDefaults.standard.object(forKey: Constants.key_PreferredTopics) != nil
    }
    
}
