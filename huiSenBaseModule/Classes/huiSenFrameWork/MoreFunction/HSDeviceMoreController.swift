//
//  HSDeviceMoreController.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/29.
//

import UIKit

class HSDeviceMoreController: UIViewController {
    var deviceInfoDictionary: [String: Any]? {
        didSet {
            guard let tempDict = deviceInfoDictionary else { return }
            let model = HSDeviceMoreModel()
            model.deviceInfoDictionary = tempDict
            model.deviceName = tempDict["device_name"] as? String ?? ""
            model.devicenumber = tempDict["device_id"] as? String ?? ""
            model.isReset = (tempDict["gateway"] as? String ?? "") == tempDict["device_id"] as? String ?? ""
            model.deviceID = tempDict["device_id"] as? String ?? ""
            model.homeId = tempDict["home_id"] as? String ?? ""
            model.roomId = tempDict["room_id"] as? String ?? ""
            deviceMoreModel = model
            newName = model.deviceName
        }
    }
    /// 刷新数据的闭包
    var reloadTitleData:((String)->Void)?
    var deviceMoreModel: HSDeviceMoreModel?
    private var newName: String?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = self.as.addNormalNavigationBar("更多")
        navView.createRightViewBar([ensureButton])
        navView.backgroundColor = UIColor.init(HSAppThemeModel.backGroundGay)
        view.backgroundColor = UIColor.init(HSAppThemeModel.backGroundGay)
        view.addSubview(tableView)
        let ges = view.as.addTarget(target: self, action: #selector(endAction))
        ges.delegate = self
    }

    // MARK: - Public

    // MARK: - Request
    // 删除设备
    private func delegateNowDevice() {
        guard let deviceMoreModel = deviceMoreModel else { return }
        HSDeviceViewModel.delegateDevice(deviceID: deviceMoreModel.deviceID){[weak self] response in
            if response.code == 200 {
                HSProgressHUD.showMessage(discribeStr: "删除成功", dismiss: true)
                // 首页刷新数据
                NotificationCenter.default.post(name: HSBaseNotificationName.homePageIsrefresh, object: nil)
                self?.navigationController?.popToRootViewController(animated: true)
            }else {
                HSProgressHUD.showMessage(discribeStr: response.message ?? "网络错误", dismiss: true)
            }
        }
    }
    
    // 重启设备
    private func reStartDevice() {
        guard let deviceMoreModel = deviceMoreModel else { return }
        HSDeviceViewModel.restartDevice(deviceID: deviceMoreModel.deviceID){ response in
            if response.code == 200 {
                HSProgressHUD.showMessage(discribeStr: "重启成功", dismiss: true)
                // 首页刷新数据
                NotificationCenter.default.post(name: HSBaseNotificationName.homePageIsrefresh, object: nil)
            }else {
                HSProgressHUD.showMessage(discribeStr: response.message ?? "网络错误", dismiss: true)
            }
        }
    }
    
    // 修改设备名称
    private func sendData(_ newName: String) {
        guard let deviceMoreModel = deviceMoreModel else { return }
        if newName.isEmpty {
            HSProgressHUD.showMessage(discribeStr: "设备名不能为空", dismiss: true)
            return
        }
        if newName == deviceMoreModel.deviceName {
            navigationController?.popViewController(animated: true)
            return
        }
        var tempArray = [[String: String]]()

        var tempDict = [String: String]()
        tempDict["device_id"] = deviceMoreModel.deviceID
        tempDict["device_name"] = newName
        tempDict["room_id"] = deviceMoreModel.roomId
        tempArray.append(tempDict)
        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.updateDeviceURLString, parameters: tempArray){[weak self] (respone, jonsString) in
            guard let strongSelf = self else { return }
            if respone.code == 200 {
                strongSelf.deviceMoreModel?.deviceName = newName
                HSProgressHUD.showMessage(discribeStr: "名字修改成功", dismiss: true)
                strongSelf.tableView.reloadData()
                strongSelf.reloadTitleData?(newName)
                // 首页刷新数据
                NotificationCenter.default.post(name: HSBaseNotificationName.homePageIsrefresh, object: nil)
                strongSelf.navigationController?.popViewController(animated: true)
            }else{
                HSProgressHUD.showMessage(discribeStr: respone.message ?? "网络错误", dismiss: true)
            }
        }
    }
    
    // MARK: - Action
    @objc func endAction() {
        view.endEditing(true)
    }
    @objc func nextAction() {
        view.endEditing(true)
        sendData(newName ?? "")
    }
    
    // MARK: - Private

    // MARK: - setter & getter
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 18, y: UIScreen.as.navBarHeight, width: view.as.width-18*2, height: view.as.height-UIScreen.as.navBarHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(HSDeviceMoreCell.self, forCellReuseIdentifier: "HSDeviceMoreCell")
        tableView.register(HSDeviceMoreOneCell.self, forCellReuseIdentifier: "HSDeviceMoreOneCell")
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    lazy var ensureButton: UIButton = {
        var btn = UIButton.init(title: "确定", titleColor: UIColor.init(HSAppThemeModel.wordMain), titleFont: UIFont.font(name: .regular, size: 15), imageName: nil, backGroudImgName: nil, target: self, action: #selector(nextAction))
        return btn
    }()
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension HSDeviceMoreController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let deviceMoreModel = deviceMoreModel else { return 0}
        return deviceMoreModel.isReset ? 2:1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if indexPath.section == 0 {
            let cell:HSDeviceMoreCell = tableView.dequeueReusableCell(withIdentifier: "HSDeviceMoreCell", for: indexPath) as! HSDeviceMoreCell
            cell.delagate = self
            return cell
        }else {
            let cell:HSDeviceMoreOneCell = tableView.dequeueReusableCell(withIdentifier: "HSDeviceMoreOneCell", for: indexPath) as! HSDeviceMoreOneCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.as.drawPathRefForCell(chioceTableView: tableView, cornerRadius: 10, indexPath: indexPath)
        guard let deviceMoreModel = deviceMoreModel else { return}
        if indexPath.section == 0 {
            guard let cell = cell as? HSDeviceMoreCell else { return}
            cell.giveVauleForCell(deviceMoreModel)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 155 - (HSWebOpenFunction.shared.isMemberRole ? 50:0)
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if indexPath.section == 1 {
            let vc = HSAlertViewController.alertDefaultView(title: "重启网关", contentString: "重启网关将会导致连接该网关的设备重启期间不可用，是否要重启网关?", actionButtonTitleArray: ["取消", "确定"]) { [weak self] (tag, content) in
                if tag == 1 {
                    // 重启设备
                    self?.reStartDevice()
                }
            }
            vc.show()
        }
    }
}

extension HSDeviceMoreController: HSDeviceMoreCellDelegate {
    func delegateDevice() {
        view.endEditing(true)
        let tmepStr = (deviceMoreModel?.isReset ?? false) ? "删除网关后连接的设备不可用，需重新绑定网关，是否要删除网关？" : "删除设备后相关场景将不可用，是否要删除？"
        let tmepTitle = (deviceMoreModel?.isReset ?? false) ? "删除网关" : "删除设备"

        let vc = HSAlertViewController.alertDefaultView(title: tmepTitle, contentString: tmepStr, actionButtonTitleArray: ["取消", "确定"]) {  [weak self] (tag, content)  in
            if tag == 1 {
                // 删除设备
                self?.delegateNowDevice()
            }
        }
        vc.show()
    }
    func changeDeviceName(_ name: String?) {
        if name == nil {
            HSProgressHUD.showMessage(discribeStr: "设备名称不能为空", dismiss: true)
            return
        }
        view.endEditing(true)
        newName = name
    }

}

extension HSDeviceMoreController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return  touch.view is UITableView
    }
}
