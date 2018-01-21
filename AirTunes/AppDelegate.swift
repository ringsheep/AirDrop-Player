//
//  Created by George Zinyakov on 31/12/2017.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var browserAdapter: FileBrowserAdaptable = FileBrowserAdapter()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        reloadFileBrowser()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        reloadFileBrowser()
        return true
    }
    
    func reloadFileBrowser() {
        browserAdapter.reloadFileBrowser()
        window?.rootViewController = browserAdapter.currentBrowser
    }
    
}

