//
//  HSAESEcoding.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/24.
//

import CryptoSwift

fileprivate let HSAPPNetworkAESAESKey = "userpasswordencr"
fileprivate let HSAPPNetworkIVIVKey = "userpasswordencr"

class HSAESEcoding: NSObject {
    
    /// AES-CBC128位加密
    /// - Parameter stringToEncode: 需要加密的字符串
    /// - Returns: 加密后的字符串
    static func endCode_AES_CBC(_ stringToEncode:String) -> String {
        var encodeString = ""
        let iv: [UInt8] = HSAPPNetworkIVIVKey.bytes
        do {
            let aes =  try AES(key: HSAPPNetworkAESAESKey.bytes, blockMode: CBC(iv: iv), padding: .pkcs5)
            let encoded = try aes.encrypt(stringToEncode.bytes)
            encodeString = encoded.toBase64()
            print(encodeString)
        } catch {
            print(error.localizedDescription)
        }
        return encodeString
    }
    
    /// AES-CBC128位解密
    /// - Parameter stringToDecode: 需要解密的字符串
    /// - Returns: 加密后的字符串
    static func deCode_AES_CBC(_ stringToDecode:String) -> String {
        //decode base64
        let data = NSData(base64Encoded: stringToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data?.length
        // 把data 转成byte数组
        for i in 0..<count! {
        var temp:UInt8 = 0
        data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        // decode AES
        var decrypted: [UInt8] = []
        let iv: [UInt8] = HSAPPNetworkIVIVKey.bytes
        do {
           decrypted = try AES(key: HSAPPNetworkAESAESKey.bytes, blockMode: CBC(iv: iv), padding: .pkcs5).decrypt(encrypted)
        } catch {
           print(error.localizedDescription)
        }
        // byte 转换成NSData
        let encoded = Data(decrypted)
        var str = ""
        //解密结果从data转成string
        str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str
    }
}
