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
