//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.

import Foundation

public class HSProgress {
    
    public weak var request: HSRequest?

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
    
    init(request: HSRequest) {
        self.request = request
    }
    
}

extension HSProgress: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return """
        
        ------------------------ HSProgress ----------------------
        URL:\(request?.URLString ?? "")
        Progress:\(currentProgressString)
        ----------------------------------------------------------
        
        """
    }
}
