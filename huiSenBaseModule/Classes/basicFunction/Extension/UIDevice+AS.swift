//
//  UIDevice+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//

// 苹果个移动设备的名称---- https://www.jianshu.com/p/7ca4dcdbefac
import UIKit
public enum DeviceType: String {
    case unknown
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5c
    case iPhone5S
    case iPhone6
    case iPhone6Plus
    case iPhone6S
    case iPhone6SPlus
    case iPhoneSE
    case iPhone7
    case iPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXR
    case iPhoneXS
    case iPhoneXMax
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone11SE2020
    case iPhone12Mini
    case iPhone12
    case iPhone12Pro
    case iPhone12ProMax
    case iPhone13Mini
    case iPhone13
    case iPhone13Pro
    case iPhone13ProMax
    case simulator
}
public extension AriSwift where Base: UIDevice {
    static var deviceTypeName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let type = mirror.children.map {String(UnicodeScalar(UInt8( $0.value as! Int8)))}.joined()
        return type
    }
    static var deviceType: DeviceType {
        switch deviceTypeName {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iPhone4
        case "iPhone4,1":                               return .iPhone4S
        case "iPhone5,1", "iPhone5,2":                  return .iPhone5
        case "iPhone5,3", "iPhone5,4":                  return .iPhone5c
        case "iPhone6,1", "iPhone6,2":                  return .iPhone5S
        case "iPhone7,2":                               return .iPhone6
        case "iPhone7,1":                               return .iPhone6Plus
        case "iPhone8,1":                               return .iPhone6S
        case "iPhone8,2":                               return .iPhone6SPlus
        case "iPhone8,4":                               return .iPhoneSE
        case "iPhone9,1", "iPhone9,3":                  return .iPhone7
        case "iPhone9,2", "iPhone9,4":                  return .iPhone7Plus
            //2017年9月13日，第十二代iPhone 8，iPhone 8 Plus，iPhone X发布
        case "iPhone10,1", "iPhone10,4":                return .iPhone8
        case "iPhone10,2", "iPhone10,5":                return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6":                return .iPhoneX
            //2018年9月13日，第十三代iPhone XS，iPhone XS Max，iPhone XR发布
        case "iPhone11,8":                              return .iPhoneXR
        case "iPhone11,2":                              return .iPhoneXS
        case "iPhone11,6":                              return .iPhoneXMax
            //2019年9月11日，第十四代iPhone 11，iPhone 11 Pro，iPhone 11 Pro Max发布
        case "iPhone12,1":                              return .iPhone11
        case "iPhone12,3":                              return .iPhone11Pro
        case "iPhone12,5":                              return .iPhone11ProMax
            //2020年4月15日，新款iPhone SE发布
        case "iPhone12,8":                              return .iPhone11SE2020
            //2020年10月14日，新款iPhone 12 mini、12、12 Pro、12 Pro Max发布
        case "iPhone13,1":                              return .iPhone12Mini
        case "iPhone13,2":                              return .iPhone12
        case "iPhone13,3":                              return .iPhone12Pro
        case "iPhone13,4":                              return .iPhone12ProMax
            //2021年9月15日，新款iPhone 13 mini、13、13 Pro、13 Pro Max发布
        case "iPhone14,4":                              return .iPhone13Mini
        case "iPhone14,5":                              return .iPhone13
        case "iPhone14,2":                              return .iPhone13Pro
        case "iPhone14,3":                              return .iPhone13ProMax
        case "x86_64":                                  return .simulator
        default:                                        return .unknown
        }
    }
    static var ipAddress: String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
    static var deviceBrands: String {return "Apple"}
    static var systemVersion: String {return Base.current.systemVersion}
}
