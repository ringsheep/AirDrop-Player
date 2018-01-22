//
//  Created by George Zinyakov on 31/12/2017.
//

import UIKit
import AVFoundation
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var playerViewModel: FileBrowserAudioPlayerDelegate = AudioPlayerViewModel()
    lazy var playerWidget: PlayerWidgetView = PlayerWidgetView()
    
    var browserAdapter: FileBrowserAdaptable = FileBrowserAdapter()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        playerWidget.delegate = playerViewModel
        playerViewModel.viewDelegate = playerWidget
        reloadFileBrowser()
        
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        application.beginReceivingRemoteControlEvents()
        
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
            self?.playerViewModel.playItems(for: file.filePath)
        }
        browserAdapter.setupPlayerView(with: playerWidget)
        window?.rootViewController = browserAdapter.currentBrowser
        
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        playerViewModel.remoteControlReceived(with: event)
    }
    
}

