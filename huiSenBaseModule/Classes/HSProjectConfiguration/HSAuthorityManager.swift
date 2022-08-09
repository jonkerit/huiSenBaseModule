//
//  HSAuthorityManager.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/6/21.
//

import UIKit
import ContactsUI
import PhotosUI
import AssetsLibrary
import EventKitUI
import CoreTelephony
import AVFoundation

public class HSAuthorityManager: NSObject {
    
    //通讯录授权状态
    public static func hasContactAuthorizationStatus() -> Bool {
        switch contactAuthorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorized:
            return true
        default:
            break
        }
        return false
    }
    public static func contactAuthorizationStatus() -> CNAuthorizationStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .authorized
        }
    }

    //相册授权状态
    public static func hasPhotoLibraryAuthorizationStatus() -> Bool {
        switch photoLibraryAuthorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorized:
            return true
        default:
            break
        }
        return false
    }
    public static func photoLibraryAuthorizationStatus() -> CNAuthorizationStatus {
        if #available(iOS 9.0, *) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            default:
                return .authorized
            }
        } else {
            let status = ALAssetsLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            default:
                return .authorized
            }
        }
    }

    //相机授权状态
    public static func hasCameraAuthorizationStatus() -> Bool {
        switch cameraAuthorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorized:
            return true
        default:
            break
        }
        return false
    }
    public static func cameraAuthorizationStatus() -> CNAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .authorized
        }
    }

    //日历授权状态
    public static func hasCalendarAuthorizationStatus() -> Bool {
        switch calendarAuthorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorized:
            return true
        default:
            break
        }
        return false
    }
    public static func calendarAuthorizationStatus() -> CNAuthorizationStatus {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .authorized
        }
    }

    //麦克风权限
    public static func hasSudioAuthorizationStatus() -> Bool {
        switch sudioAuthorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorized:
            return true
        default:
            break
        }
        return false
    }
    public static func sudioAuthorizationStatus() -> CNAuthorizationStatus {
        let status = AVAudioSession.sharedInstance().recordPermission
        switch status {
        case .undetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .granted:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
}
// MARK: - Other Delegate
//extension HSAuthorityManager : {
//
//}
