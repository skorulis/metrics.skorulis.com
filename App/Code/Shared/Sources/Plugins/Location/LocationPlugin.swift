//  Created by Alexander Skorulis on 5/2/2023.

import Foundation
import SwiftUI
import CodableFirebase
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

public final class LocationPlugin: DataSourcePlugin {
    
    public var name: String = "Location"
    
    public var dataType: LocationData.Type { DataType.self }
    public typealias DataType = LocationData
    
    public var tokenKeys: [APIToken] { [] }
    
    private let db = Firestore.firestore()
    private let mainStore: MainStore
    
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }
    
    public func fetch(context: FetchContext, tokens: [String : String]) async throws {
        guard let baseLocation = self.mainStore.homeLocation else {
            return
        }
        let snapshot = try await db.collection("location")
            .document("skorulis")
            .collection("history")
            .getDocuments()
        
        let decoder = FirebaseDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        var maxDistances: [String: Double] = [:]
        let clLocation = CLLocation(latitude: baseLocation.latitude, longitude: baseLocation.longitude)
        for doc in snapshot.documents {
            guard let entry = try? decoder.decode(LocationEntry.self, from: doc.data()) else {
                continue
            }
            let date = Date(timeIntervalSince1970: entry.date)
            let dateString = dateFormatter.string(from: date)
            let distance = clLocation.distance(from: entry.location)
            if let prev = maxDistances[dateString] {
                if distance > prev {
                    maxDistances[dateString] = distance
                }
            } else {
                maxDistances[dateString] = distance
            }
        }
        for (key, value) in maxDistances {
            var entry = context.entry(date: dateFormatter.date(from: key)!)
            let data = LocationData(maxDistance: value)
            entry.setData(plugin: self, data: data)
            context.replace(entry: entry)
        }
    }
    
    public func settingsView(_ viewModel: SettingsViewModel) -> some View {
        VStack {
            Text("Set home location")
            MapView(homeLocation: locationBinding)
                .frame(height: 300)
        }
        
    }
    
    public func merge(data: LocationData, newData: LocationData) -> LocationData {
        let maxDistance = max(data.maxDistance, newData.maxDistance)
        
        return LocationData(maxDistance: maxDistance)
    }
    
    private var locationBinding: Binding<CLLocationCoordinate2D?> {
        return Binding<CLLocationCoordinate2D?> {
            self.mainStore.homeLocation
        } set: { newValue in
            self.mainStore.homeLocation = newValue
        }
    }
 
    
}
