//  Created by Alexander Skorulis on 13/12/2022.

import Foundation

public struct RescueTimeDay: Codable {
    
    public let productivity_pulse: Double
    public let date: String
    
    /* Not currently using percentages
    let very_productive_percentage: Double
    let productive_percentage: Double
    let neutral_percentage: Double
    let distracting_percentage: Double
    let very_distracting_percentage: Double
    let all_productive_percentage: Double
    let all_distracting_percentage: Double
    let uncategorized_percentage: Double
    let business_percentage: Double
    let communication_and_scheduling_percentage: Double
    let social_networking_percentage: Double
    let design_and_composition_percentage: Double
    let entertainment_percentage: Double
    let news_percentage: Double
    let software_development_percentage: Double
    let reference_and_learning_percentage: Double
    let shopping_percentage: Double
    let utilities_percentage: Double
     */
    
    public let total_hours: Double
    public let very_productive_hours: Double
    public let productive_hours: Double
    public let neutral_hours: Double
    public let distracting_hours: Double
    public let very_distracting_hours: Double
    public let all_productive_hours: Double
    public let all_distracting_hours: Double
    public let uncategorized_hours: Double
    public let business_hours: Double
    public let communication_and_scheduling_hours: Double
    public let social_networking_hours: Double
    public let design_and_composition_hours: Double
    public let entertainment_hours: Double
    public let news_hours: Double
    public let software_development_hours: Double
    public let reference_and_learning_hours: Double
    public let shopping_hours: Double
    public let utilities_hours: Double
    
}

extension RescueTimeDay {
    static func +(lhs: RescueTimeDay, rhs: RescueTimeDay) -> RescueTimeDay {
        return RescueTimeDay(
            productivity_pulse: 0,
            date: lhs.date,
            total_hours: lhs.total_hours + rhs.total_hours,
            very_productive_hours: lhs.very_productive_hours + rhs.very_productive_hours,
            productive_hours: lhs.productive_hours + rhs.productive_hours,
            neutral_hours: lhs.neutral_hours + rhs.neutral_hours,
            distracting_hours: lhs.distracting_hours + rhs.distracting_hours,
            very_distracting_hours: lhs.very_distracting_hours + rhs.very_distracting_hours,
            all_productive_hours: lhs.all_productive_hours + rhs.all_productive_hours,
            all_distracting_hours: lhs.all_distracting_hours + rhs.all_distracting_hours,
            uncategorized_hours: lhs.uncategorized_hours + rhs.uncategorized_hours,
            business_hours: lhs.business_hours + rhs.business_hours,
            communication_and_scheduling_hours: lhs.communication_and_scheduling_hours + rhs.communication_and_scheduling_hours,
            social_networking_hours: lhs.social_networking_hours + rhs.social_networking_hours,
            design_and_composition_hours: lhs.design_and_composition_hours + rhs.design_and_composition_hours,
            entertainment_hours: lhs.entertainment_hours + rhs.entertainment_hours,
            news_hours: lhs.news_hours + rhs.news_hours,
            software_development_hours: lhs.software_development_hours + rhs.software_development_hours,
            reference_and_learning_hours: lhs.reference_and_learning_hours + rhs.reference_and_learning_hours,
            shopping_hours: lhs.shopping_hours + rhs.shopping_hours,
            utilities_hours: lhs.utilities_hours + rhs.utilities_hours
        )
    }
    
    public static func sum(days: [RescueTimeDay]) -> RescueTimeDay {
        var result: RescueTimeDay?
        for day in days {
            if let prev = result {
                result = prev + day
            } else {
                result = day
            }
        }
        return result!
    }

}
