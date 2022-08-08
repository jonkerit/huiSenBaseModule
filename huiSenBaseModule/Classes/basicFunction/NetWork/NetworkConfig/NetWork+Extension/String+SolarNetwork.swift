//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.


import Foundation

extension String: HSNamespaceProtocol {}

extension HSNamespace where Base == String {

    var isIP: Bool {
        if let char = base.first {
            let zero: Character = "0"
            let nine: Character = "9"
            if char >= zero && char <= nine {
                return true
            }
        }
        
        return false;
    }
    
}
