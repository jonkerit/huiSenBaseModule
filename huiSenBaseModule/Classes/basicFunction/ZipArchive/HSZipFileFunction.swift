//
//  HSHSZipFileFunction.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/21.
//

import UIKit
import SSZipArchive

struct HSZipDecumentName {
    /// 压缩文件的文件夹名称
    static let zipH5FileDecument = "huiSenSmartZipFile"
    /// 解压文件的文件夹名称
    static let H5FileDecument = "huiSenSmartUnZipFile"
    /// 解压文件的临时文件夹名称，用于存放临时文件
    static let cacheH5FileDecument = "huiSenSmartCacheUnZipFile"
}
class HSZipFileFunction: NSObject {
    static var shared = HSZipFileFunction()
    
    /// 压缩文件的文件夹地址
    var zipH5FileDecumentPath: String {
        get{
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] + "/\(HSZipDecumentName.zipH5FileDecument)"
            createHuiSenDecument(path)
            return path
        }
    }
    
    /// 解压文件的文件夹的地址
    var H5FileDecumentPath: String {
        get{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(HSZipDecumentName.H5FileDecument)"
            createHuiSenDecument(path)
            return path
        }
    }
    
    /// 解压文件的临时文件夹名称，用于存放临时文件,下次加入
    var cacheH5FileDecumentPath: String {
        get{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(HSZipDecumentName.cacheH5FileDecument)"
            createHuiSenDecument(path)
            return path
        }
    }
    
    @discardableResult
    /// 解压bundle里面的zip文件
    /// - Parameters:
    ///   - fileName: 解压后的文件夹名称
    ///   - zipPath: zip的文件名称
    /// - Returns: 解压后的文件路径
    func unZipFileActionFormBundle(_ fileName: String, zipPath:String) -> String?{
        let unZipPath = H5FileDecumentPath
        // 检查是否有fileName文件，有就先删除
        var isDir = ObjCBool(false)
        let resultPath = "\(unZipPath)/\(fileName)"
        let isExistedDecument = FileManager.default.fileExists(atPath: resultPath, isDirectory: &isDir)
        if isExistedDecument {
            do {
                try FileManager.default.removeItem(atPath: resultPath)
            } catch {
                return nil
            }
        }
        let time = currentTimeStamp()
        let success = SSZipArchive.unzipFile(atPath: zipPath, toDestination: resultPath)
        if !success {
            return nil
        }
        
        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: unZipPath)
        } catch {
            return nil
        }
        
        #if huiSenSmart
        HSDebugLog("解压成功---\(resultPath),所用时间：\(currentTimeStamp()-time)")
        for (index, item) in items.enumerated() {
            HSDebugLog("\(index)--文件名称---\(item)")
        }
        #endif
        
        return resultPath
    }
    
    
    
    /// 解压H5指定文件夹的zip，到指定的文件夹中
    /// - Parameter fileName: zip的名称（解压后的文件名称也用zip）
    /// - Returns: 解压后的文件夹路径
    func unZipFileActionFromH5Path(_ fileName: String) -> String? {
        let zipPath = "\(zipH5FileDecumentPath)/\(fileName).zip"
        // 检查是否有fileName文件，有就先删除
        var isDir = ObjCBool(false)
        let resultPath = "\(H5FileDecumentPath)/\(fileName)"
        let isExistedDecument = FileManager.default.fileExists(atPath: resultPath, isDirectory: &isDir)
        if isExistedDecument {
            do {
                try FileManager.default.removeItem(atPath: resultPath)
            } catch {
                return nil
            }
        }
        let success = SSZipArchive.unzipFile(atPath: zipPath, toDestination: resultPath)
        if !success {
            return nil
        }
        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: resultPath)
        } catch {
            return nil
        }
        #if huiSenSmart
        for (index, item) in items.enumerated() {
            HSDebugLog("\(index)--文件名称---\(item)")
        }
        #endif
        
        return resultPath
    }
    
    /// 判断是否存在解压包文件夹
    /// - Parameter H5fileName: 文件夹名称
    /// - Returns: bool
    func isExistedUnZipH5(_ H5fileName: String)  -> Bool{
        var isDir = ObjCBool(false)
        let resultPath = "\(H5FileDecumentPath)/\(H5fileName)"
        let isExistedDecument = FileManager.default.fileExists(atPath: resultPath, isDirectory: &isDir)
        if isDir.boolValue {
            return false
        }
        return isExistedDecument
    }
    /// 判断是否存在index文件
    /// - Parameter H5fileName: 文件夹名称
    /// - Returns: bool
    func isExistedUnZipH5IndexFile(_ H5fileName: String)  -> Bool{
        var isDir = ObjCBool(false)
        let resultPath = "\(H5FileDecumentPath)/\(H5fileName)"
        let isExistedDecument = FileManager.default.fileExists(atPath: resultPath, isDirectory: &isDir)
        if !isDir.boolValue || !isExistedDecument{
            return false
        }
        
        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: resultPath)
        } catch {
            return false
        }
        for item in items {
            if item == "index.html" {
                return true
            }
        }
        return false
    }
    
    /// 判断是否存在压缩包文件
    /// - Parameter zipH5fileName: 压缩文件夹名称
    /// - Returns: bool
    func isExistedZipH5(_ zipH5fileName: String)  -> Bool{
        var isDir = ObjCBool(false)
        let resultPath = "\(zipH5FileDecumentPath)/\(zipH5fileName)"
        let isExistedDecument = FileManager.default.fileExists(atPath: resultPath, isDirectory: &isDir)
        if isDir.boolValue {
            return false
        }
        return isExistedDecument
    }
}

extension HSZipFileFunction {
    private func currentTimeStamp() -> TimeInterval {
        let date = Date()
        return date.timeIntervalSince1970
    }
    
    // 判断是否存在文件夹, 不存在就创建文件夹
    private func createHuiSenDecument(_ path:String) {
        var isDir = ObjCBool(false)
        let isExistedDecument = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        if !(isDir.boolValue && isExistedDecument) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch _ as NSError {
            }
        }
    }
}
