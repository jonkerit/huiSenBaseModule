//
//  HSCoadble+Extension.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/8/25.
//

import Foundation

public protocol HSCoadble: Codable{
    func toDict()->Dictionary<String, Any>?
    func toData()->Data?
    func toString()->String?
    static func decode<T: Decodable>(fromDictionary rootData: Any, to Model: T.Type) -> T?
    static func decode<T: Decodable>(fromArray rootData: Any, to Model: T.Type) -> [T]?
}

public extension HSCoadble {
    
    func toData()->Data?{
        return try? JSONEncoder().encode(self)
    }
    
    func toDict()->Dictionary<String, Any>? {
        if let data = toData(){
            do{
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            }catch{
                 debugPrint(error.localizedDescription)
                return nil
            }
        }else{
            debugPrint("model to data error")
            return nil
        }
    }
    func toString()->String?{
        if let data = try? JSONEncoder().encode(self),let x = String.init(data: data, encoding: .utf8){
            return x
        }else{
            return nil
        }
    }
    
    static func decode<T: Decodable>(fromDictionary rootData: Any, to Model: T.Type) -> T? {
        var decodeData: Data = Data()
        do {
            if let tempString = rootData as? String {
                decodeData = tempString.data(using: .utf8) ?? Data()
            }else if let data = rootData as? Data {
                decodeData = data;
            }else if let tempDict = rootData as? [String: Any] {
                decodeData = try JSONSerialization.data(withJSONObject: tempDict)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let data: T = try decoder.decode(T.self, from: decodeData) as! T
            return data
        } catch {

        }
        return nil
    }
    
    public static func decode<T: Decodable>(fromArray rootData: Any, to Model: T.Type) -> [T]? {
        var decodeData: Data = Data()
        do {
            if let tempString = rootData as? String {
                decodeData = tempString.data(using: .utf8) ?? Data()
            }else if let data = rootData as? Data {
                decodeData = data;
            }else if let tempDict = rootData as? [Any] {
                decodeData = try JSONSerialization.data(withJSONObject: tempDict)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let data: [T] = try decoder.decode([T].self, from: decodeData) as! [T]
            return data
        } catch {
        }
        return nil
    }
}
