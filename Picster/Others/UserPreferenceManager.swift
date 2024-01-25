//
//  UserPreferenceManager.swift
//  Picster
//
//  Created by mac 2019 on 1/19/24.
//

import Foundation


class UserPreferenceManager{
    
    private init(){}
    
    
    public static func getUserPreferredTopics() -> [String] {
        return UserDefaults.standard.object(forKey: Constants.key_PreferredTopics) as? [String] ?? []
    }
    
    
    public static func setUserPreferredTopics(topics: [String]){
        UserDefaults.standard.setValue(topics, forKey: Constants.key_PreferredTopics)
    }
    
    
    public static func isTopicPreferenceExist() -> Bool {
        UserDefaults.standard.object(forKey: Constants.key_PreferredTopics) != nil
    }
    
}
