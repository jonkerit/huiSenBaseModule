////
////  HSScanQrViewController.swift
////  huiSenSmart
////
////  Created by jonker.sun on 2022/1/20.
////
//
//import UIKit
//import Foundation
//import AVFoundation
//import ObjectMapper
//
//class HSScanQrViewController: UIViewController {
//    
//    weak var delegate:HSScanQrViewProtocol?
//    /// 扫描的原始字符串
//    private var originalScanString:String?
//    /// 定时器
//    private var GCDtimer:DispatchSourceTimer?
//    private var choiceHome: HSHomeModel?
//    // MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//         
//        if HSUserAccountDault.standard.privatePolicyStatus != 2 || HSAuthorityManager.cameraAuthorizationStatus() == .denied{
//            HSProgressHUD.showMessage(discribeStr: "没有同意相机权限，不能使用该功能",dismiss: true)
//            Timer.as.timerDelay(by: 1.5, qosClass: nil) {
//                self.comeBack()
//            }
//            return
//        }
//        
//        if TARGET_IPHONE_SIMULATOR != 0 {
//            HSProgressHUD.showMessage(discribeStr: "模拟器不支持摄像头",dismiss: true)
//            Timer.as.timerDelay(by: 1.5, qosClass: nil) {
//                self.comeBack()
//            }
//            return
//        }
//        if HSNetworkQuery.getNetworkStatus() == "no network" {
//            let view = self.as.showError(in: view, errorType: .noNet) { errorType in
//            }
//            view.errorTitleLabel.textColor = UIColor.init(HSAppThemeModel.backGroundLight)
//            return
//        }
//        view.backgroundColor = .clear
//        setUI()
//        choiceHome = createChioceHome()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if !session.isRunning {
//            session.startRunning()
//        }
//        scanningView.startTimer()
//    }
//
//    // MARK: - Public
//
//    // MARK: - Request
//    
//    // MARK: - Action
//    // 开关灯
//    @objc func openLightAction() {
//        guard let device = AVCaptureDevice.default(for: .video) else {
//            return
//        }
//        if (noticeLable.text ?? "") == "开灯" {
//            noticeLable.text = "关灯"
//        }else {
//            noticeLable.text = "开灯"
//        }
//        if device.hasFlash && device.isTorchAvailable {
//            try? device.lockForConfiguration()
//            if device.torchMode == .off {
//                device.torchMode = .on
//            }else{
//                device.torchMode = .off
//            }
//            device.unlockForConfiguration()
//        }
//    }
//    // MARK: - Private
//    private func setUI() {
//        let device = AVCaptureDevice.default(for: .video)
//        do {
//            let input = try AVCaptureDeviceInput.init(device: device!)
//            let output = AVCaptureMetadataOutput()
//            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            session.addInput(input)
//            session.addOutput(output)
//            
//            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128]
//            
//            view.layer.insertSublayer(self.videoPreviewLayer, at: 0)
//            view.addSubview(scanningView)
//            view.addSubview(openLightView)
//            view.addSubview(noticeLable)
//            session.startRunning()
//            createNavView()
//        } catch let error as NSError {
//            HSDebugLog(error)
//            view.backgroundColor = .white
//            HSProgressHUD.showMessage(discribeStr: "请打开摄像头", dismiss: true)
//            Timer.as.timerDelay(by: 1.5, qosClass: nil) {
//                self.comeBack()
//            }
//            return
//        }
//    }
//    /// nav
//    private func createNavView() {
//        let navView = self.as.addNormalNavigationBar("扫一扫")
//        navView.backgroundColor = .clear
//        navView.titleView.textColor = UIColor.init(HSAppThemeModel.backGroundLight)
//        navView.backButton.setImage(UIImage.as.imageNamed("Navbar_back").withRenderingMode(.alwaysTemplate), for: .normal)
//        navView.backButton.tintColor = UIColor.init(HSAppThemeModel.backGroundLight)
//    }
//
//    /// 播放声音
//    private func audioPlay() {
//        let sound:SystemSoundID = 1302
//        AudioServicesPlaySystemSound(sound)
//    }
//    
//    /// 开始扫描
//    private func startScanning() {
//        errorView.isHidden = true
//        Timer.as.timerDelay(by: 1, qosClass: nil) {
//            self.session.startRunning()
//            self.scanningView.startTimer()
//        }
//    }
// 
//    /// 停止扫描
//    private func stopScanning() {
//        scanningView.removeTimer()
//        session.stopRunning()
//    }
//    
//    /// 返回
//    private func comeBack() {
//        guard let nav = navigationController else {
//            dismiss(animated: true, completion: nil)
//            return
//        }
//        nav.popViewController(animated: true)
//    }
//    // 获取当前选中的家庭
//    private func createChioceHome() -> HSHomeModel? {
//        do{
//            guard let jsonString = HSUserAccountDault.standard.homeInfo else {return nil}
//            let data = jsonString.data(using: String.Encoding.utf8)!
//            //把NSData对象转换回JSON对象
//            let json : Any! = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
//            let modelArray = Mapper<HSHomeModel>().mapArray(JSONArray: json as! [[String : Any]])
//            
//            guard let homeId = HSUserAccountDault.standard.chioceHomeId else {
//                HSUserAccountDault.standard.chioceHomeId = modelArray.first?.homeId
//                return modelArray.first}
//            for model in modelArray {
//                if model.homeId == homeId{
//                    return model
//                }
//            }
//            return modelArray.first ?? nil
//        }catch{
//            return nil
//        }
//    }
//    // MARK: - setter & getter
//    
//    /// 扫码终端
//    lazy var session: AVCaptureSession = {
//        let session = AVCaptureSession()
//        session.canSetSessionPreset(.high)
//        return session
//    }()
//    
//    /// 扫码图层
//    lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
//        let lay = AVCaptureVideoPreviewLayer.init(session: session)
//        lay.videoGravity = .resizeAspectFill
//        lay.frame = view.bounds
//        return lay
//    }()
//    
//    /// QRlayer
//    private lazy var scanningView: HSScanQrView = HSScanQrView.createCustomView(frame: UIScreen.main.bounds, superLayer: videoPreviewLayer)
//    /// 扫描第N页的提示
//    private lazy var noticeLable:UILabel = {
//        let lab = UILabel.init(title: "开灯", fontColor: .white, fonts: UIFont.font(name: .regular, size: 14), alignment: .center)
//        lab.sizeToFit()
//        lab.frame = CGRect(x: view.as.width/2-lab.as.width/2, y: openLightView.as.bottom+5, width: lab.as.width, height: lab.as.height)
//        return lab
//    }()
//    /// 点击
//    lazy var openLightView: UIView = {
//        var view = UIView.init(frame: CGRect(x: view.as.width/2-25, y: view.as.height-UIScreen.as.tabBarSafeHeight-50-70, width: 50, height: 50))
//        view.backgroundColor = .black
//        view.as.addTarget(target: self, action: #selector(openLightAction))
//        view.as.cornerRadius = 25
//        let imagV = UIImageView.init(imageName: "QRLight", tintColor: HSAppThemeModel.backGroundLight)
//        imagV.sizeToFit()
//        imagV.frame = CGRect(x: view.as.width/2-imagV.as.width/2, y: view.as.height/2-imagV.as.height/2, width: imagV.as.width, height: imagV.as.height)
//        view.addSubview(imagV)
//        return view
//    }()
//    
//    lazy var errorView: HSErrorView = {
//        let view = self.as.showError(in: view, errorType: .noQRUsed) {[weak self] errorType in
//            self?.startScanning()
//        }
//        
//        view.frame = CGRect(x: 0, y: UIScreen.as.navBarHeight, width: view.as.width, height: view.as.height-UIScreen.as.navBarHeight)
//        view.backgroundColor = .black.withAlphaComponent(HSScanQrstaticNumber.scanBorderOutsideViewAlpha)
//        view.errorTitleLabel.textColor = UIColor.init(HSAppThemeModel.backGroundLight)
//        view.isHidden = true
//        return view
//    }()
//}
//
//// MARK: - AVCaptureMetadataOutputObjectsDelegate
//extension HSScanQrViewController: AVCaptureMetadataOutputObjectsDelegate{
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if metadataObjects.count>0 {
//            audioPlay()
//            stopScanning()
//            let resultObject:AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
//            #if DEBUG
//            HSProgressHUD.showMessage(discribeStr: "扫描结果：\(resultObject.stringValue ?? "")",dismiss:true)
//            print("扫描结果：\(resultObject.stringValue ?? "")")
//            #endif
//            
//            if resultObject.stringValue == nil || choiceHome == nil {
//                errorView.isHidden = false
//            }else{
//                HSProductViewModel.registerDevice(home_id: choiceHome!.homeId, param: resultObject.stringValue!) {[weak self] response in
//                    HSProgressHUD.dismiss()
//                    guard let strongSelf = self else { return  }
//                    if response.code == 200 {
//                        guard let model = response.data as? HSProductDistributionModel else {
//                            strongSelf.errorView.isHidden = false
//                            return  }
//                        // 首页刷新数据
//                        NotificationCenter.default.post(name: HSBaseNotificationName.homePageIsrefresh, object:"HSScanQrViewController")
//                        let vc = HSDeviceChangeNameController()
//                        vc.dataArray = [model]
//                        strongSelf.navigationController?.pushViewController(vc, animated: true)
//                    }else{
//                        HSProgressHUD.showMessage(discribeStr: response.message ?? "网络错误", dismiss: true)
//                        strongSelf.startScanning()
//                    }
//                }
//            }
//            
//        }
//    }
//}
