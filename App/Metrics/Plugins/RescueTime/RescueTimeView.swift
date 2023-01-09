//Created by Alexander Skorulis on 9/1/2023.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RescueTimeView {
    let data: RescueTimeDay
}

// MARK: - Rendering

extension RescueTimeView: View {
    
    var body: some View {
        Text("Rescue Time")
    }
}

// MARK: - Previews

struct RescueTimeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let data = RescueTimeDay(
            productivity_pulse: 0,
            date: "2023-01-08",
            total_hours: 45.6,
            very_productive_hours: 19.43,
            productive_hours: 1,
            neutral_hours: 2.23,
            distracting_hours: 4.54,
            very_distracting_hours: 18.4,
            all_productive_hours: 20,
            all_distracting_hours: 22,
            uncategorized_hours: 0.6,
            business_hours: 0.08,
            communication_and_scheduling_hours: 1,
            social_networking_hours: 0.86,
            design_and_composition_hours: 0.02,
            entertainment_hours: 8.6,
            news_hours: 12.8,
            software_development_hours: 16,
            reference_and_learning_hours: 4.4,
            shopping_hours: 0.03,
            utilities_hours: 0.6
        )
        RescueTimeView(data: data)
    }
}

