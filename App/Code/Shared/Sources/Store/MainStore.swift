//  Created by Alexander Skorulis on 18/1/2023.

import ASKCore
import CoreLocation
import FirebaseAuth
import Foundation

final class MainStore: ObservableObject {
    
    private let keyValueStore: PKeyValueStore
    private static let homeKey = "homeLocationKey"

    @Published var isLoggedIn: Bool
    @Published var homeLocation: CLLocationCoordinate2D? {
        didSet {
            try! keyValueStore.set(codable: homeLocation, forKey: Self.homeKey)
        }
    }
    
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        self.homeLocation = try! keyValueStore.codable(forKey: Self.homeKey)
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
    
    func updateLoggedIn() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
}

extension CLLocationCoordinate2D: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            latitude: try container.decode(Double.self, forKey: .latitude),
            longitude: try container.decode(Double.self, forKey: .longitude)
        )
    }
}
