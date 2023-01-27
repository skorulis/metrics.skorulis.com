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
        self.pullLatest()
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
    
    func upload(entry: MetricsEntry) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let data = try! encoder.encode(entry)
            db.collection("metrics")
                .document("skorulis")
                .collection("days")
                .document(entry.id)
                .setData(data as! [String: Any]) { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
        }
    }
    
    func pullLatest() {
        db.collection("metrics")
            .document("skorulis")
            .collection("days")
            .getDocuments { [weak self] (snapshot, error) in
                guard let snapshot else { return }
                
                for doc in snapshot.documents {
                    guard let entry = try? self?.decoder.decode(MetricsEntry.self, from: doc.data()) else {
                        continue
                    }
                    self?.store.replace(entry: entry)
                }
            }
    }
}
