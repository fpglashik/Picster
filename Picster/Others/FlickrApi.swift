//
//  FlickrApi.swift
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

struct FlickrApi{
    static var shared = FlickrApi()
    static let perPageItemCount = 20
    private init(){}
    
    private var feedTagComponent: String{
        let topics = UserPreferenceManager.getUserPreferredTopics().joined(separator: ",")
        return topics.isEmpty ? "" : "&tags=\(topics)"
    }
    
    private func feedPageComponent(page: Int) -> String{
        return page <= 0 ? "" : "&page=\(page)"
    }
    
    private func feedPerPageComponent(perPage: Int = FlickrApi.perPageItemCount) -> String{
        let count = max(5, min(30, perPage))
        return "&per_page=\(count)"
    }
    
    func getFeed(for page: Int, completion: @escaping ((Result<[FlickrFeedItem], FlickrError>) -> Void)) async {
        let urlString = Constants.flickerFeedBaseUrl
                                .appending(feedPageComponent(page: page))
                                .appending(feedPerPageComponent())
                                .appending(feedTagComponent)
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        do{
            let networkResultData = try await NetworkManager.fetchData(from: urlString)
            
            if let feed = DataCoders.decode(data: networkResultData, FlickrFeed.self){
                /*feed.items.forEach{
                    print("title:\($0.title)")
                    print("url:\($0.url)")
                    print("murl:\($0.media.urlString)")
                    print("desc:\($0.description)")
                    print("\n")
                    print("\n")
                }*/
                completion(.success(feed.items))
            }
            else{
                completion(.failure(.fail))
            }
        }
        catch{
            completion(.failure(.fail))
        }
        
    }
    
    private var dummyUrls = ["https://live.staticflickr.com/65535/53486166710_c4265267a7_m.jpg", "https://live.staticflickr.com/65535/53486060704_73156bacd2_m.jpg", "https://live.staticflickr.com/65535/53486047994_0e26032c20_m.jpg", "https://live.staticflickr.com/65535/53485744796_b01ed347c5_m.jpg", "https://live.staticflickr.com/65535/53484713492_3d5c8a5ef5_m.jpg", "https://live.staticflickr.com/65535/53484711022_7630094d4e_m.jpg", "https://live.staticflickr.com/65535/53485607611_d168f74ce1_m.jpg", "https://live.staticflickr.com/65535/53486020010_e006873686_m.jpg", "https://live.staticflickr.com/65535/53485912174_42ea0ceb45_m.jpg", "https://live.staticflickr.com/65535/53485608066_e2fed28348_m.jpg", "https://live.staticflickr.com/65535/53485745793_b995929153_m.jpg", "https://live.staticflickr.com/65535/53486019640_8c46740919_m.jpg", "https://live.staticflickr.com/65535/53485873914_5ed941a371_m.jpg", "https://live.staticflickr.com/65535/53485704323_8b7d768435_m.jpg", "https://live.staticflickr.com/65535/53485948610_a802c2988b_m.jpg", "https://live.staticflickr.com/65535/53485641923_f6810f245e_m.jpg", "https://live.staticflickr.com/65535/53485491256_d8967e99b5_m.jpg", "https://live.staticflickr.com/65535/53485659173_9eab5dfd4a_m.jpg", "https://live.staticflickr.com/65535/53485919770_248b7ffff8_m.jpg", "https://live.staticflickr.com/65535/53485929595_9da4755371_m.jpg"]
    
    func getDummyFeed(for page: Int, completion: @escaping ((Result<[FlickrFeedItem], FlickrError>) -> Void)) async {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5){
            let items = dummyUrls.map{
                FlickrFeedItem(
                    title: "Dummy Item Title",
                    url: "",
                    description: "Dummy Item Description width=200 height=200",
                    dateTaken: "",
                    media: FlickrFeedItemMedia(urlString: $0),
                    datePublished: "",
                    author: "",
                    authorId: "",
                    tags: ""
                )
            }
            
            completion(.success(items.shuffled()))
        }
        
    }
    
    
    static func extractWidthHeight(text: String)->(Int, Int){
        
        let dimensions = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
            .split(separator: " ")
            .filter{
                $0.contains("width=") || $0.contains("height=")
            }
            .map{ $0.split(separator: "=") }
            .reduce(into: [String:Int]()) {
                if $1.count >= 1{
                    $0[String($1[0])] = Int($1[1]) ?? 0
                }
            }
        return (dimensions["width"] ?? 0, dimensions["height"] ?? 0)
    }
    
    
    static func generateWidthHeight(text: String)->(Int, Int){
        
        let dimensions = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
            .split(separator: " ")
            .filter{
                $0.contains("width=") || $0.contains("height=")
            }
            .map{ $0.split(separator: "=") }
            .reduce(into: [String:Int]()) {
                if $1.count >= 1{
                    $0[String($1[0])] = Int($1[1]) ?? 0
                }
            }
        return (dimensions["width"] ?? 0, dimensions["height"] ?? 0)
    }
    
}
