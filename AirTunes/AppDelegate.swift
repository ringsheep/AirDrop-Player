//
//  Created by George Zinyakov on 31/12/2017.
//

import UIKit
import FileBrowser

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let inboxFolderUrlComponent = "Inbox/"
    lazy var inboxUrl = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask).last?.appendingPathComponent(inboxFolderUrlComponent)
    
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
        window?.rootViewController = FileBrowser(initialPath: inboxUrl,
                                                 allowEditing: true,
                                                 showCancelButton: false)
    }
    
}

