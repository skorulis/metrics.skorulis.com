//Created by Alexander Skorulis on 9/1/2023.

import ASKCore
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RescueTimeView {
    let data: RescueTimeDay
    
    private static let veryProductiveColor = Color(0x3498db)
    private static let productiveColor = Color(0x2980b9)
    private static let neutralColor = Color(0x95a5a6)
    private static let unproductiveColor = Color(0xc0392b)
    private static let veryUnproductiveColor = Color(0xe74c3c)
    
}

// MARK: - Rendering

extension RescueTimeView: View {
    
    var body: some View {
        VStack {
            Text("Total hours: \(data.total_hours)")
            pie
        }
    }
    
    private var pie: some View {
        PieView(slices: [
            (data.very_productive_hours, Self.veryProductiveColor),
            (data.productive_hours, Self.productiveColor),
            (data.neutral_hours, Self.neutralColor),
            (data.uncategorized_hours, Color.black),
            (data.distracting_hours, Self.unproductiveColor),
            (data.very_distracting_hours, Self.veryUnproductiveColor)
        ])
        .frame(width: 300, height: 300)
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

