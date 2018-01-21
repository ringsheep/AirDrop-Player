//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import FileBrowser
import PandoraPlayer
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
            guard let player = self?.player(for: file) else { return }
            self?.currentBrowser?.present(player,
                                          animated: true,
                                          completion: nil)
        }
    }
    
    func player(for file: FBFile) -> PandoraPlayer {
        let allPaths = allPathsInDirectory(file: file)
        let allItems = allPaths?.map({ AVPlayerItem(url: $0) }) ?? []
        let currentItemIndex = allPaths?.index(of: file.filePath)
        
        let player = PandoraPlayer.configure(withAVItems: allItems)
        player.currentSongDidChanged(index: currentItemIndex)
        
        player.onClose = { _ in
            player.dismiss(animated: true, completion: nil)
        }
        
        return player
    }
    
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
