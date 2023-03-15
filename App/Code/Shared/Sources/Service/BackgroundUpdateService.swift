//  Created by Alexander Skorulis on 6/3/2023.

import BackgroundTasks
import Foundation

public final class BackgroundUpdateService {
    
    private let fetchService: FetchService
    
    init(fetchService: FetchService) {
        self.fetchService = fetchService
    }
    
    public func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.skorulis.Metrics.update", using: nil) { task in
            self.handle(task: task as! BGAppRefreshTask)
        }
        print("Registered background task")
    }
    
    public func schedule() {
        let request = BGAppRefreshTaskRequest(identifier: "com.skorulis.Metrics.update")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 8 * 60 * 60)
        do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }
    
    func handle(task: BGAppRefreshTask) {
        schedule()
        let asyncTask = Task {
            await self.fetchService.fetch()
            task.setTaskCompleted(success: true)
            
        }
        
        task.expirationHandler = {
            asyncTask.cancel()
        }
    }
    
}
