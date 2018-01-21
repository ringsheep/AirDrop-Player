//
//  Created by George Zinyakov on 31/12/2017.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let playerController: FileBrowserAudioPlayerDelegate = AudioPlayerChildViewController()
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
        browserAdapter.didSelectFile = { [weak self] file in
            if file.fileExtension == "mp3" {
                self?.playerController.playItems(for: file.filePath)
            }
        }
        window?.rootViewController = browserAdapter.currentBrowser
        if let currentBrowser = browserAdapter.currentBrowser {
            playerController.setupPlayerWidget(on: currentBrowser)
        }
    }
    
}

