//
//  FlickrApiCaller.swift
//  Picster
//
//  Created by mac 2019 on 1/25/24.
//

import Foundation

extension Constants {
    static let flickerApiKey: String = "74d7b36645b77c950a81384174cb420b"
    static let flickerApiSecret: String = "edcbeca38fb2b13b"
    static let flickerFeedBaseUrl = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tagmode=any"
}


enum FlickrError: Error, LocalizedError{
    case fail
    
    var errorDescription: String?{
        NSLocalizedString("Fail", comment: "")
    }
}

struct FlickrApiCaller{
    static var shared = FlickrApiCaller()
    private init(){}
    
    private var feedTagComponent: String{
        let topics = UserPreferenceManager.getUserPreferredTopics().joined(separator: ",")
        return topics.isEmpty ? "" : "&tags=\(topics)"
    }
    
    private func feedPageComponent(page: Int) -> String{
        return page <= 0 ? "" : "&page=\(page)"
    }
    
    private func feedPerPageComponent(perPage: Int = 20) -> String{
        let count = max(5, min(30, perPage))
        return "&per_page=\(count)"
    }
    
    func getFeed(for page: Int, completion: @escaping ((Result<[FlickrFeedItem], FlickrError>) -> Void)) async {
        let urlString = Constants.flickerFeedBaseUrl
                                .appending(feedPageComponent(page: page))
                                .appending(feedPerPageComponent())
                                .appending(feedTagComponent)
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let networkResult = await NetworkManager.fetchData(from: urlString)
        
        switch networkResult{
            case .success(let data):
                if let feed = DataCoders.decode(data: data, FlickrFeed.self){
                    print(feed.title)
                    completion(.success(feed.items))
                }
                else{
                    completion(.failure(.fail))
                }
            case .failure(_):
                completion(.failure(.fail))
        }
        
    }
    
}
