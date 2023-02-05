//  Created by Alexander Skorulis on 27/1/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

@MainActor
final class FetchStatusService: ObservableObject {
 
    @Published private var pluginStatuses: [String: Status] = [:]
    
    func start() {
        pluginStatuses.removeAll()
    }
    
    func status(plugin: any DataSourcePlugin) -> Status {
        let key = plugin.keyName
        return pluginStatuses[key] ?? Status.waiting
    }
    
    func set(status: Status, plugin: any DataSourcePlugin) {
        let key = plugin.keyName
        pluginStatuses[key] = status
    }
    
}

// MARK: - Inner types

extension FetchStatusService {
    enum Status {
        case waiting
        case active(_ status: String?)
        case failed(_ error: Error)
        case finished
        
        var fullTitle: String {
            if let subtitle {
                return "\(title): \(subtitle)"
            }
            return title
        }
        
        var title: String {
            switch self {
            case .waiting: return "Waiting"
            case .active: return "In progress"
            case .failed: return "Failed"
            case .finished: return "Finished"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .waiting, .finished: return nil
            case let .active(status): return status
            case let .failed(error): return error.localizedDescription
            }
        }
        
        var icon: Image {
            switch self {
            case .waiting: return Image(systemName: "clock")
            case .active: return Image(systemName: "play.fill")
            case .failed: return Image(systemName: "exclamationmark.triangle.fill")
            case .finished: return Image(systemName: "checkmark.circle.fill")
            }
        }
        
        var flavor: AlertCell.Flavor {
            switch self {
            case .waiting: return .brand
            case .active: return .brand
            case .failed: return .error
            case .finished: return .success
            }
        }
    }
}


