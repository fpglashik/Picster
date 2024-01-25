//
//  DataCoder.swift
//  Picster
//
//  Created by mac 2019 on 1/25/24.
//

import Foundation

enum DataCoders{
    
    static func decode<T: Decodable>(data: Data?, _ type: T.Type = T.self) -> T? where T: Decodable{
        do{
            return try JSONDecoder().decode(T.self, from: data!)
        }
        catch{
            return nil
        }
    }
    
    static func encode<T: Encodable>(instance: T) -> Data? where T: Encodable{
        do{
            return try JSONEncoder().encode(instance)
        }
        catch{
            return nil
        }
    }
    
}
