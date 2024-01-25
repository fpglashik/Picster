//
//  FlickrModels.swift
//  Picster
//
//  Created by mac 2019 on 1/25/24.
//

import Foundation

struct FlickrFeed: Decodable{
    var title: String
    var link: String                //"https://www.flickr.com/photos/"
    var description: String
    var modified: String            // "2024-01-16T11:30:58Z"
    var generator: String           // "https://www.flickr.com"
    var items: [FlickrFeedItem]
}

struct FlickrFeedItem: Decodable{
    var title: String
    var url: String                 //"https://www.flickr.com/photos/187113622@N05/53466611837/"
    var description: String
    var dateTaken: String           // "2021-12-30T05:00:13-08:00"
    var media: FlickrFeedItemMedia
    var datePublished: String           //"2024-01-16T11:31:12Z"
    var author: String              //"nobody@flickr.com (\"merlin_mb\")"
    var authorId: String            //"35468147358@N01"
    var tags: String                //"instagram insta"
    
    private enum CodingKeys: String, CodingKey{
        case title          = "title"
        case url            = "link"
        case description    = "description"
        case dateTaken      = "date_taken"
        case media          = "media"
        case datePublished  = "published"
        case author         = "author"
        case authorId       = "author_id"
        case tags           = "tags"
    }
}

struct FlickrFeedItemMedia: Decodable{
    var mediaUrl: String            //"https://live.staticflickr.com/65535/53466611837_aed8ab0d12_m.jpg"
    
    private enum CodingKeys: String, CodingKey {
        case mediaUrl       = "m"
    }
}
