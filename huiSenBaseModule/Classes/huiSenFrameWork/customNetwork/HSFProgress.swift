//
//  HSFProgress.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/15.
//

import Foundation

public class HSFProgress {
    
    public weak var request: HSURLRequest?

    public var originalProgress: Progress?
    
    
    /// The Request's progress: 0-1
    public var currentProgress: Double {
        return originalProgress?.fractionCompleted ?? 0
    }
    
    /// The Request's progress: 0% - 100%
    public var currentProgressString: String {
        if let fractionCompleted = originalProgress?.fractionCompleted {
            return String(format: "%.0lf%%", fractionCompleted * 100)
        }
        return ""
    }
    
    init(request: HSURLRequest?) {
        self.request = request
    }
    
}

extension HSFProgress: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return """
        
        ------------------------ HSFProgress ----------------------
        URL:\(request?.URLString ?? "")
        Progress:\(currentProgressString)
        ----------------------------------------------------------
        
        """
    }
}
