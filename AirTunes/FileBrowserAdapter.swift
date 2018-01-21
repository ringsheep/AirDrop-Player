//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import FileBrowser
import AVFoundation

protocol FileBrowserAdaptable {
    var currentBrowser: FileBrowser? { get set }
    func reloadFileBrowser()
}

class FileBrowserAdapter: FileBrowserAdaptable {
    
    let inboxFolderUrlComponent = "Inbox/"
    lazy var inboxUrl = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask).last?.appendingPathComponent(inboxFolderUrlComponent)
    var currentBrowser: FileBrowser?
    var isPlaying: Bool = false
    lazy var playerWidget: PlayerWidgetView = {
        let view = PlayerWidgetView()
        view.delegate = self
        return view
    }()
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func reloadFileBrowser() {
        let browser = FileBrowser(initialPath: inboxUrl,
                                  allowEditing: true,
                                  showCancelButton: false)
        browser.didSelectFile = didSelectFile
        currentBrowser = browser
    }
    
    lazy var didSelectFile: (FBFile) -> () = { [weak self] file in
        if file.fileExtension == "mp3" {
//            guard let player = self?.player(for: file) else { return }
//            self?.currentBrowser?.present(player,
//                                          animated: true,
//                                          completion: nil)
            
            self?.setupPlayerWidget()
        }
    }
    
    func setupPlayerWidget() {
        guard let currentBrowser = currentBrowser else { return }
        currentBrowser.view.addSubview(playerWidget)
        playerWidget.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        playerWidget.bottomAnchor.constraint(equalTo: currentBrowser.view.bottomAnchor).isActive = true
        playerWidget.leadingAnchor.constraint(equalTo: currentBrowser.view.leadingAnchor).isActive = true
        playerWidget.trailingAnchor.constraint(equalTo: currentBrowser.view.trailingAnchor).isActive = true
    }
    
//    func player(for file: FBFile) -> PandoraPlayer {
//        let allPaths = allPathsInDirectory(file: file)
//        let allItems = allPaths?.map({ AVPlayerItem(url: $0) }) ?? []
//        let currentItemIndex = allPaths?.index(of: file.filePath) ?? 0
//        
//        let player = PandoraPlayer.configure(withAVItems: allItems)
//        player.currentSongDidChanged(index: currentItemIndex)
//        
//        player.onClose = { _ in
//            player.dismiss(animated: true, completion: nil)
//        }
//        
//        return player
//    }
    
    func allPathsInDirectory(file: FBFile) -> [URL]? {
        let currentDirectory = file.filePath.deletingLastPathComponent()
        let allPathsInDirectory = try? FileManager.default.contentsOfDirectory(at: currentDirectory,
                                                                               includingPropertiesForKeys: [],
                                                                               options: [.skipsHiddenFiles,
                                                                                         .skipsPackageDescendants,
                                                                                         .skipsSubdirectoryDescendants])
        return allPathsInDirectory
    }
    
}

extension FileBrowserAdapter: PlayerWidgetDelegate {
    
    func onNext() {
    }
    
    func onPrevious() {
    }
    
    func togglePlayStatus() {
        isPlaying = !isPlaying
        playerWidget.handlePlayButtonState(isPlaying: isPlaying)
    }
    
}
