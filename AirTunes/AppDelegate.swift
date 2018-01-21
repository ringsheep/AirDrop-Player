//
//  Created by George Zinyakov on 31/12/2017.
//

import UIKit
import AVFoundation
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    typealias FileBrowserAudioPlayerProtocol = (FileBrowserAudioPlayerDelegate & PlayerWidgetDelegate)
    
    var window: UIWindow?
    let playerController: FileBrowserAudioPlayerProtocol = AudioPlayerChildViewController()
    var browserAdapter: FileBrowserAdaptable = FileBrowserAdapter()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        reloadFileBrowser()
        window?.makeKeyAndVisible()
        
        application.beginReceivingRemoteControlEvents()
        configureCommandCenter()
        
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
            self?.playerController.playItems(for: file.filePath)
        }
        window?.rootViewController = browserAdapter.currentBrowser
        if let currentBrowser = browserAdapter.currentBrowser {
            playerController.setupPlayerWidget(on: currentBrowser)
        }
    }
    
    func configureCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.playerController.onPrevious()
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.playerController.onNext()
            return .success
        }
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.playerController.togglePlayStatus()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.playerController.togglePlayStatus()
            return .success
        }
    }
    
}

