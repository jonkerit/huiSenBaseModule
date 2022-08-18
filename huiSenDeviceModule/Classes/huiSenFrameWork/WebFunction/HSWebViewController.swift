//
//  HSWebViewController.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/3.
//

import UIKit
import WebKit

class HSWebViewController: UIViewController {
    /// 设备model
    var deviceInfo: [String: String]! {
        didSet {
            titleString = deviceInfo["device_name"] ?? ""
        }
    }
    /// 标题 (可选)
    var titleString: String = ""
    /// 刷新数据的闭包
    var reloadData:(()->Void)?
    /// 设备相关信息
    var deviceInfoDictionary: [String: Any]?
    /// H5 控制nav右侧的按钮的事件名称
    var navBarButtonActionName: String?
    
    ///kvo
//    private var KVOCenter:HSSafelyKVOCenter = HSSafelyKVOCenter()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        customNavView.titleView.text = titleString
        if HSAPPBaseUrl.isEmpty {
            #if DEBUG
            HSAPPBaseUrl = "https://staging.huisensmart.com/app"
            //    static let HSAPPBaseUrl = "http://106.15.107.104:7711"
            #elseif BATE
            HSAPPBaseUrl = "https://staging.huisensmart.com/app"
            #else
            HSAPPBaseUrl = "https://api.huisensmart.com/app"
            #endif
        }
        // 清楚本地缓存
        clearCookies()
        // 加载本地H5资源
        HSUserAccountDault.standard.H5IsLoad = true
        addNotice()
        loadFileH5()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 拦截系统返回手势
        if let delegate = navigationController as? HSBaseNavigationController{
            if delegate.viewControllers.count>1 {
                delegate.gestureRecognizerDelegate = self
            }
        }
    }
   
    // MARK: -- selctor 方法
    @objc func testButtonAction() {
        guard let device_id = deviceInfo["product_id"] else { return }
        let array = device_id.components(separatedBy: "__")
        HSTestWebFunctionView.createCustomView(array.last ?? "")
    }
    @objc func moreAction(_ btn: UIButton) {
        // 更多
        let vc = HSDeviceMoreController()
        vc.deviceInfoDictionary = deviceInfoDictionary
        navigationController?.pushViewController(vc, animated: true)
        vc.reloadTitleData = {[weak self] name in
            guard let strongSelf = self else { return }
//            strongSelf.customNavView.titleView.text = name
            strongSelf.deviceInfo["device_name"] = name
            strongSelf.deviceInfoDictionary?["device_name"] = name
            let tempDict = ["key":"name", "value": name]
            strongSelf.passDataToJS(mehodName: HSH5SetDeviceInfoMehod, jsonString: String.as.dictionaryToJSONString(tempDict))

        }
    }
    
    // H5 操作
    @objc func finishAction(_ btn: UIButton) {
        if navBarButtonActionName != nil && !navBarButtonActionName!.isEmpty {
            passDataToJS(mehodName: navBarButtonActionName, jsonString: nil)
        }
    }

    // MARK: - setter & getter
    lazy var webView:WKWebView = {
        // 中间隔一层，防止内存不释放
        let weakScriptMessageDelegate = HSWeakScriptMessageDelegate.init(scriptTarget: self)
        // 初始化
        let userconfiguration:WKUserContentController = WKUserContentController()
        // 注册方法
        for temp in inputFuncArray {
            userconfiguration.add(weakScriptMessageDelegate, name: temp)
        }
        // 配置屏幕适配
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let userScript:WKUserScript = WKUserScript.init(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userconfiguration.addUserScript(userScript)
        // 加载H5初始化的JS资源
        let customScript:WKUserScript = WKUserScript.init(source: createJSFormLocation(), injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userconfiguration.addUserScript(customScript)
        
        let configuration:WKWebViewConfiguration = WKWebViewConfiguration()
        configuration.userContentController = userconfiguration
        configuration.processPool = WKProcessPool()

        if #available(iOS 10.0, *) {
            configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        }else{
            configuration.preferences.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        }
        var webView:WKWebView = WKWebView.init(frame: CGRect(x: 0, y: UIScreen.as.navBarHeight, width: view.as.width, height: view.as.height-UIScreen.as.navBarHeight), configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(webView)
        return webView
    }()
    
    /// navView
    lazy var customNavView: HSNavigationBarView = {
        // 标题
        let customNavView = self.as.addNormalNavigationBar(titleString) {[weak self] in
            guard let strongeSelf = self else { return }
            // 返回按钮事件
            strongeSelf.comeBackAction()
        }
        customNavView.backgroundColor = UIColor.init(HSAppThemeModel.backGroundGay)
        #if DEBUG
        customNavView.createRightViewBar([moreButton,testButton], 15)
        #elseif BATE
        customNavView.createRightViewBar([moreButton,testButton], 15)
        #else
        customNavView.createRightViewBar([moreButton])
        #endif
        finishButton.frame = CGRect(x: UIScreen.as.screenWidth-finishButton.as.width-15, y: UIScreen.as.statusBarHeight+(44 - finishButton.as.height)/2, width: finishButton.as.width, height: finishButton.as.height)
        customNavView.addSubview(finishButton)

        return customNavView
    }()
    lazy var testButton:UIButton = UIButton.init(title: "查看H5包信息", titleColor: .black, titleFont: UIFont.font(name: .medium, size: 16), imageName: nil, backGroudImgName: nil, target: self, action: #selector(testButtonAction))
    
    lazy var moreButton:UIButton = UIButton.init(title: nil, titleColor: .black, titleFont: UIFont.font(name: .medium, size: 16), imageName: "H5More", backGroudImgName: nil, target: self, action: #selector(moreAction(_ :)), tintColor: HSAppThemeModel.imageGay)
    
    lazy var finishButton:UIButton = {
        let btn = UIButton.init(title: "        ", titleColor: .black, titleFont: UIFont.font(name: .regular, size: 16), imageName: nil, backGroudImgName: nil, target: self, action: #selector(finishAction(_ :)), tintColor: HSAppThemeModel.imageGay)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.textAlignment = .right
        btn.sizeToFit()
        btn.isHidden = true
        return btn
    }()
    
    lazy var emptyView: UILabel = {
        let lab = UILabel.init(title: "没有数据", fontColor: UIColor.init(HSAppThemeModel.wordGay), fonts: UIFont.font(name: .regular, size: 13), alignment: .center)
        lab.numberOfLines = 0
        lab.isHidden = true
        lab.sizeToFit()
        lab.center = view.center
        view.addSubview(lab)
        return lab
    }()
    /// 回调方法缓存
    lazy var callbackMethodCache = [String: String]()
    /// 需要注册的方法的数组
    lazy var inputFuncArray: [String] = [HSH5GetApppVersionMehod, HSH5GetJSBriggeMehod, HSH5GetThemeMehod, HSH5GetUserInfoMehod, HSH5GetDeviceInfoMehod, HSH5GetDeviceAttributeMehod, HSH5GetOperationMehod, HSH5SetStorageMehod, HSH5GetStorageMehod, HSH5HanlderToastMehod, HSH5HandlerDialogMehod, HSH5PageChangeMehod, HSH5HandlerApiMehod, HSH5VibrationMehod]
}

// MARK: - public 方法
extension HSWebViewController{
    /// 返回按钮事件
    func comeBackAction() {
        passDataToJS(mehodName: HSH5ComeBackActionMehod, jsonString: nil) {[weak self] (respose, error) in
            guard let strongSelf = self else { return }
            guard  error == nil, let result = respose as? String, result == "ok"  else {
                strongSelf.reloadData?()
                strongSelf.removeObseiveKey()
                if strongSelf.presentingViewController != nil {
                    strongSelf.dismiss(animated: false, completion: nil)
                }else{
                    strongSelf.navigationController?.popViewController(animated: true)
                }
                return
            }
        }
    }
    
    // 加载数据到JS文件中（OC调用JS方法）
    func passDataToJS(mehodName:String?, jsonString: String?, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        let resultJS = "\(mehodName ?? "")('\(jsonString ?? "")')"
        webView.evaluateJavaScript(resultJS) { responce, error in
            completionHandler?(responce, error)
        }
        #if huiSenSmart
        HSDebugLog("c即将调用的JS方法和参数：\(resultJS)")
        #endif
    }
    // josn string 转dict
    func stringValueDiction(_ str: String) -> [String : Any]? {
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
}

// MARK: - Private 方法
extension HSWebViewController{
    // 加载本地HTML资源
    private func loadWebView(_ inputFilePath: String){
        if self.webView.isLoading {
          return
        }
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#,?,%,=,&")
        let encodingURL = inputFilePath.addingPercentEncoding(withAllowedCharacters: charSet)!
        let tempURL = NSURL.init(fileURLWithPath: encodingURL) as URL
        
        guard let urlComponents = NSURLComponents.init(url: tempURL, resolvingAgainstBaseURL: false) else {
               return
           }
        // to do: 下一个版本需要删除
//        #if huiSenSmart
        let queryItem = URLQueryItem.init(name: "userAgent", value: "iOS")
        urlComponents.queryItems = [queryItem]
//        #endif

        if let url = urlComponents.url {
            let documentsURL = HSZipFileFunction.shared.H5FileDecumentPath
            self.webView.loadFileURL(url, allowingReadAccessTo: URL.init(fileURLWithPath: documentsURL))
        }else{
            #if huiSenSmart
            HSDebugLog("====没有URL")
            #endif
        }
    }
    
    // 获取本地H5的资源路径
    private func loadFileH5(){
        // 处理文件名称
        guard let product_id = deviceInfo["product_id"] else {
            // 加载空页面
            emptyView.isHidden = false
            return }
        guard let patch = HSWebOpenReady.shared.productFilePath(product_id, completioned: {[weak self] (productID, error) in
            guard let strongSelf = self else { return }
            if productID != nil && error == nil {
                strongSelf.loadFileH5()
            }
        }) else {
            // 加载空页面
            emptyView.isHidden = false
            return
        }
//        let inputFilePath = "\(patch)?userAgent=iOS"
        loadWebView(patch)
    }
    
    /// 生成JS
    private func createJSFormLocation()-> String{
        let jScripts = "var _hs = {userAgent: 'iOS', appVersion: 'appVersion', bridgeVersion: '1.1',initializedTheme: '#0000'}"
        return jScripts
    }
    // 清除缓存
    private func clearCookies() {
        let websiteDataTypes = NSSet.init(objects: [WKWebsiteDataTypeMemoryCache as AnyObject,WKWebsiteDataTypeDiskCache as AnyObject], count: 2)
        let dateFrom = NSDate.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom as Date) {}
    }
    // 移除handlers方法
    private func removeObseiveKey(){
        if #available(iOS 14.0, *) {
            self.webView.configuration.userContentController.removeAllScriptMessageHandlers()
            self.webView.configuration.userContentController.removeAllContentRuleLists()
        }else{
            for temp in self.inputFuncArray {
                self.webView.configuration.userContentController.removeScriptMessageHandler(forName: temp)
            }
        }
        self.webView.configuration.userContentController.removeAllUserScripts()
    }
    
    private func openQR() {
        // to do
//        let vc = HSScanQrViewController()
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addNotice() {
//        //  给webview添加进度监听
//        KVOCenter.addSafelyObserverForObject(target: webView, keyPath: "estimatedProgress", options: .new) { dict in
//        }
//        // 监听标题
//        KVOCenter.addSafelyObserverForObject(target: webView, keyPath: "title", options: .new) { dict in
//
//        }
    }
}

// MARK: - WKNavigationDelegate,WKUIDelegate
extension HSWebViewController:WKNavigationDelegate,WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let _ = navigationAction.request.url {
            decisionHandler(.allow)

        }
    }
    // 页面开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    // 页面加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        emptyView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        decisionHandler(.allow, preferences)
    }
    
}

// MARK: - HSScanQrViewProtocol to do
//extension HSWebViewController: HSScanQrViewProtocol {
//    func scanQrResultData(data: AnyObject) {
//
//    }
//}

// MARK: - UIGestureRecognizerDelegate
extension HSWebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 返回按钮事件
        comeBackAction()
        return false
    }
}


