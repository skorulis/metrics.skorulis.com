//  Created by Alexander Skorulis on 6/3/2023.

import Foundation
import Shared
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
 
    var ioc: IOC!
    
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let updateService = ioc.resolve(BackgroundUpdateService.self)
        updateService.register()
        updateService.schedule()
        
        return true
    }
    
}
