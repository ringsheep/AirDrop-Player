//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import FileBrowser
import AVFoundation
import KDEAudioPlayer

protocol FileBrowserAdaptable {
    var currentBrowser: FileBrowser? { get set }
    func reloadFileBrowser()
}

class FileBrowserAdapter: FileBrowserAdaptable {
    
    let inboxFolderUrlComponent = "Inbox/"
    lazy var inboxUrl = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask).last?.appendingPathComponent(inboxFolderUrlComponent)
    var currentBrowser: FileBrowser?
    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                player.resume()
            } else {
                player.pause()
            }
        }
    }
    
    lazy var player: AudioPlayer = {
        let player = AudioPlayer()
        player.delegate = self
        return player
    }()
    
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
            self?.setupPlayerWidget()
            self?.playItems(for: file)
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
    
    func playItems(for file: FBFile) {
        player.play(items: audioItems(for: file),
                    startAtIndex: index(of: file))
    }
    
    func index(of file: FBFile) -> Int {
        return allPathsInDirectory(file: file)?.index(of: file.filePath) ?? 0
    }
    
    func audioItems(for file: FBFile) -> [AudioItem] {
        return allPathsInDirectory(file: file)?.flatMap({ (url) -> AudioItem? in
            return AudioItem(mediumQualitySoundURL: url)
        }) ?? []
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

extension FileBrowserAdapter: PlayerWidgetDelegate {
    
    func onNext() {
        player.nextOrStop()
    }
    
    func onPrevious() {
        player.previous()
    }
    
    func togglePlayStatus() {
        isPlaying = !isPlaying
        playerWidget.handlePlayButtonState(isPlaying: isPlaying)
    }
    
}

extension FileBrowserAdapter: AudioPlayerDelegate {
    
}
