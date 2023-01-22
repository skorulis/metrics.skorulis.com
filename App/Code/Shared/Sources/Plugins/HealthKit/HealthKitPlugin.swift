//  Created by Alexander Skorulis on 21/1/2023.

import Foundation
import SwiftUI
import HealthKit

public final class HealthKitPlugin: DataSourcePlugin {
    
    public typealias DataType = HealthKitData
    public var name: String { "HealthKit" }
    private let healthStore = HKHealthStore()
    
    public var dataType: HealthKitData.Type { HealthKitData.self }
    
    public var tokenKeys: [APIToken] { [] }
        
    public func fetch(context: FetchContext, tokens: [String : String]) async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Healthkit not available on this device")
            return
        }
        
        //self.authorizeHealthKit()
        try await getSteps()

    }
    
    private func getSteps() async throws {
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let dayStart = Calendar.current.startOfDay(for: now)
        let start = dayStart.adding(days: -14)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: now, options: .strictEndDate)
        let interval = DateComponents(day: 1)
        
        let queryStepCount = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: [.cumulativeSum],
            anchorDate: start,
            intervalComponents: interval
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            queryStepCount.initialResultsHandler = { _, result, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                var total: Int = 0
                result?.enumerateStatistics(from: start, to: now) { statistics, _ in
                    print(statistics)
                    
                    if let sumQuantity = statistics.sumQuantity() {
                        let x = sumQuantity.doubleValue(for: HKUnit.count())
                        total += Int(x)
                        print(total)
                    }
                }
                continuation.resume()
            }
            healthStore.execute(queryStepCount)
        }
    }
    
    public func render(_ entry: MetricsEntry, _ data: DataType) -> AnyView {
        return AnyView(Text("TODO"))
    }
    
    public init() {}
    
    private func authorizeHealthKit() {
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ] // We want to access the step count.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in  // We will check the authorization.
            if success {} // Authorization is successful.
        }
    }
    
    public func merge(data: DataType, newData: DataType) -> DataType {
        return data
    }
    
    
}
