//
//  FlickrMediaItemViewModel.swift
//  Picster
//
//  Created by mac 2019 on 1/25/24.
//

import Foundation

struct FlickrMediaItemViewModel{
    
    let title: String
    let urlString: String
    let width: Int
    let height: Int
    
    
    init(feedItem: FlickrFeedItem) {
        self.title = feedItem.title
        self.urlString = feedItem.media.urlString
        
        let dimension = FlickrApi.extractWidthHeight(text: feedItem.description)
        self.width = dimension.0
        self.height = dimension.1
    }
    
}
