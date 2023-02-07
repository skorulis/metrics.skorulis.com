//  Created by Alexander Skorulis on 7/2/2023.

import Foundation

extension NumberFormatter {
    
    static let decimalFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 1
        return nf
    }()
    
}

extension NumberFormatter {
    
    func string(from: Double) -> String {
        return self.string(from: from as NSNumber) ?? ""
    }
}
