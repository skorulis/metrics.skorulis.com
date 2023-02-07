//  Created by Alexander Skorulis on 5/2/2023.

import Foundation
import CoreLocation

public struct LocationData: Codable {
    
    /// Maximum distance in meters
    var maxDistance: Double
    
}

public struct LocationEntry: Codable {
    
    var lng: Double
    var lat: Double
    var date: Double
    var accuracy: Double
    
    var location: CLLocation {
        return .init(latitude: lat, longitude: lng)
    }
    
}
