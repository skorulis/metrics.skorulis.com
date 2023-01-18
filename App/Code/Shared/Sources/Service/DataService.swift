//  Created by Alexander Skorulis on 18/1/2023.

import CodableFirebase
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DataService {
    
    private let store: MetricsStore
    private let plugins: PluginManager
    private let db = Firestore.firestore()
    
    init(store: MetricsStore,
         plugins: PluginManager
    ) {
        self.store = store
        self.plugins = plugins
    }
}

extension DataService {
    
    var decoder: FirebaseDecoder {
        let decoder = FirebaseDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.userInfo[.pluginsKey] = plugins.plugins
        return decoder
    }
    
    var encoder: FirebaseEncoder {
        let encoder = FirebaseEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.userInfo[.pluginsKey] = plugins.plugins
        return encoder
    }
    
    func save(entry: MetricsEntry) {
        let data = try! encoder.encode(entry)
        db.collection("metrics")
            .document("skorulis")
            .collection("days")
            .document(entry.id)
            .setData(data as! [String: Any])
    }
    
    func fetch() {
        db.collection("metrics")
            .document("skorulis")
            .collection("days")
            .getDocuments { snapshot, error in
                print(error)
                print(snapshot?.count)
            }
    }
}
