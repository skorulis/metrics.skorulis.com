//  Created by Alexander Skorulis on 27/1/2023.

import Foundation

extension DateFormatter {
    
    static let weekFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "w, Y"
        return df
    }()
    
    static let dayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEEE d MMM")
        return df
    }()
}
