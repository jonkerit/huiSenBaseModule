//
//  HSFrameworkImage.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/7/8.
//

import UIKit

@objc public class HSFrameworkImage: NSObject {
    @objc public static func imageNamed(_ name: String, bundleName: String?) ->UIImage {
        return UIImage.as.imageNamed(name, bundleName ?? "huiSenBundle")
    }
}
