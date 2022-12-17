//  Created by Alexander Skorulis on 13/12/2022.

import Foundation

struct RescueTimeDay: Codable {
    
    let productivity_pulse: Double
    let date: String
    
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
    
    let total_hours: Double
    let very_productive_hours: Double
    let productive_hours: Double
    let neutral_hours: Double
    let distracting_hours: Double
    let very_distracting_hours: Double
    let all_productive_hours: Double
    let all_distracting_hours: Double
    let uncategorized_hours: Double
    let business_hours: Double
    let communication_and_scheduling_hours: Double
    let social_networking_hours: Double
    let design_and_composition_hours: Double
    let entertainment_hours: Double
    let news_hours: Double
    let software_development_hours: Double
    let reference_and_learning_hours: Double
    let shopping_hours: Double
    let utilities_hours: Double
}
