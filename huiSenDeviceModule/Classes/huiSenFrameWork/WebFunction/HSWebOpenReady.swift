//
//  HSWebOpenReady.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/15.
//

import UIKit

public typealias CompletionFinish = (String?, NSError?) -> Void
public typealias checkCompletionFinish = ([String: Any]?, String?) -> Void
public typealias downCompletionFinish = (String?, String?) -> Void
fileprivate let maniFestJsonName = "manifest"
fileprivate let settingMenusJsonName = "settingMenus"

class HSWebOpenReady: NSObject {
    static var shared = HSWebOpenReady()
    private var zipFileFunction = HSZipFileFunction.shared
    private var completion: CompletionFinish?
    
    // MARK: - LifeCycle

    // MARK: - Public
    func productFilePath(_ productID: String, completioned:@escaping CompletionFinish) -> String? {
        completion = completioned
        let filePath = getProductFilePath(productID)
        return filePath
    }
    
    /// 获取maniFestJson的json数据
    /// - Parameter productID: 产品ID
    /// - Returns: [String: Any]
    func getManifestInfo(productID: String) -> [String: Any]? {
        let JSfilePath = "\(zipFileFunction.H5FileDecumentPath)/\(productID)/\(maniFestJsonName).json"
        do {
            let tempDta = try NSData.init(contentsOfFile: JSfilePath, options: [])
            let anyObject = try? JSONSerialization.jsonObject(with: tempDta as Data, options: .mutableContainers)
            guard let tempDict = anyObject as? [String: Any] else { return nil }
            return tempDict
        } catch {
            return nil
        }
    }
    
    /// 获取SettingMenus的json数据
    /// - Parameter productID: 产品ID
    /// - Returns: [[String: Any]]
    func getSettingMenusInfo(productID: String) -> [[String: Any]]? {
        let JSfilePath = "\(zipFileFunction.H5FileDecumentPath)/\(productID)/\(settingMenusJsonName).json"
        do {
            let tempDta = try NSData.init(contentsOfFile: JSfilePath, options: [])
            let anyObject = try? JSONSerialization.jsonObject(with: tempDta as Data, options: .mutableContainers)
            guard let tempArray = anyObject as? [[String: Any]] else { return nil }
            return tempArray
        } catch {
            return nil
        }
    }

    // MARK: - Private
    /// 获取可跳转的index.html的全路径
    /// - Parameter productID: 产品ID
    /// - Returns: 可跳转的index.html的全路径
    private func getProductFilePath(_ productID: String) -> String? {
        // 判断是否有解压后的indx.html文件
        let isExistedUnZipIndexFile = zipFileFunction.isExistedUnZipH5IndexFile(productID)
        
        if isExistedUnZipIndexFile {
            // 获取版本号
            guard let dictData = getManifestInfo(productID: productID) else {
                // 检查是否有压缩包
                let isExistedZipIndexFile = zipFileFunction.isExistedZipH5(productID)
                if isExistedZipIndexFile {
                    // 解压
                    guard let _ = zipFileFunction.unZipFileActionFromH5Path(productID)else {
                        // 下载
                        updateZip(productID, nil)
                        return nil
                    }
                    return getProductFilePath(productID)
                }else{
                    // 下载
                    updateZip(productID, nil)
                    return nil
                }
            }
            // 对比版本号,如果不是最新版本走更新流程
            guard let vision = dictData["version"] as? String else {
                return "\(zipFileFunction.H5FileDecumentPath)/\(productID)/index.html"
            }
            updateZip(productID, vision)
            
            return "\(zipFileFunction.H5FileDecumentPath)/\(productID)/index.html"
            
        }else{
            // 解压
            guard let _ = zipFileFunction.unZipFileActionFromH5Path(productID)else {
                // 下载
                updateZip(productID, nil)
                return nil
            }
            return getProductFilePath(productID)
        }
    }
    
    private func updateZip(_ productID: String, _ oldVersion: String?) {
        requestCheck(productID) {[weak self] (dataDict, errorMsg) in
            guard let strongSelf = self else { return }
            if dataDict != nil && errorMsg == nil {
                strongSelf.dealResult(productID: productID, oldVersion:oldVersion, dataDict: dataDict!)
            }
        }
    }
    
    // 处理check版本结果， 如果发现有新版就下载ZIP包
    private func dealResult(productID: String, oldVersion: String?, dataDict:[String: Any]) {
        guard let version = dataDict["version"] as? String else {
            return
        }
        guard let urlStirng = dataDict["url"] as? String, let MD5 = dataDict["md5"] as? String else {
            return
        }
    #if DEBUG
        if !HSUserAccountDault.standard.H5IsLoad {
            return
        }
    #elseif BATE
        if !HSUserAccountDault.standard.H5IsLoad {
            return
        }
    #else
        if oldVersion == version {
            return
        }
    #endif
        // 下载ZIP-如果有该ZIP就先删除该压缩包
        var isDir = ObjCBool(false)
        let resultPath = "\(zipFileFunction.zipH5FileDecumentPath)/\(productID).zip"
        let isExistedDecument = FileManager.default.fileExists(atPath: resultPath, isDirectory: &isDir)
        if isExistedDecument {
            do {
                try FileManager.default.removeItem(atPath: resultPath)
            } catch {
            }
        }
        downH5Zip(urlStirng: urlStirng, productID: productID, MD5: MD5) {[weak self] (filePath, errorMsg) in
            guard let strongSelf = self else { return }
            if filePath != nil {
                // 成功后删除原来的已经使用的解压文件，回调结果
                let resultPath = "\(strongSelf.zipFileFunction.H5FileDecumentPath)/\(productID)"
                let isExistedDecument = FileManager.default.fileExists(atPath: resultPath, isDirectory: &isDir)
                if isExistedDecument {
                    do {
                        try FileManager.default.removeItem(atPath: resultPath)
                    } catch {
                    }
                }
                if strongSelf.completion != nil {
                    HSUserAccountDault.standard.H5IsLoad = false
                    strongSelf.completion!(productID,nil)
                }
            }else{
                strongSelf.completion!(nil,NSError.init(domain: "下载失败", code: 400, userInfo: nil))
            }
        }
    }
    
    
    
    /// 检查最新版本信息
    /// - Parameters:
    ///   - productID: 产品ID
    ///   - completioned: 回调
    private func requestCheck(_ productID: String, completioned:@escaping checkCompletionFinish) {

        var env = ""
        
        #if DEBUG
        env = "development"
        #elseif BATE
        env = "development"
        #else
        env = "production"
        #endif
        let tempParameters = ["env":env,"product_id":productID,"bridge_version":HSH5JSBridgeVision,"ui_kind":1] as [String : Any]
        HSNetworkManager.sharedInstance.requestHttp(URLString: HSH5NetworkUrl.getH5ZipInfoURLString, parameters: tempParameters, hethod:.post) { response in
            if response.code == 200 {
                guard let data = response.dataDictionary else { return completioned(nil,response.message) }
                completioned(data,nil)
            }else{
                completioned(nil,response.message)
            }
        }
    }
    
    /// 下载zip
    /// - Parameters:
    ///   - urlStirng: 下载的URL String
    ///   - productID: 产品ID
    ///   - MD5: ZIP的MD5值
    ///   - completioned: （成功后的zip路径，失败）
    private func downH5Zip(urlStirng: String, productID: String, MD5: String, completioned:@escaping downCompletionFinish) {
        HSProgressHUD.show()
        let resultPath = "\(zipFileFunction.zipH5FileDecumentPath)/\(productID).zip"
        HSNetworkManager.sharedInstance.requestDownData(URLString: urlStirng, resultPath: resultPath, isHaveToken: true, networkTargetType: .Other) { progress in
            
        } completioned: { response in
            HSProgressHUD.dismiss()
            // 判断文件的MD5值
            guard let fileURL = response.fileURL, response.error == nil  else {
                completioned(nil, "下载失败")
                return }
            let fileData : Data = FileManager.default.contents(atPath: fileURL.path)!
            let resultMD5 = String.as.dataToMD5(fileData)
            
            if MD5 == resultMD5 {
                // 下载成功
                completioned(fileURL.path, nil)
            }else{
                // 下载文件不完整，失败
                completioned(nil, "下载失败")
            }
        }
    }
}
