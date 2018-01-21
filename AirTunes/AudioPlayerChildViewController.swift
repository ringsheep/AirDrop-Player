//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import KDEAudioPlayer

protocol FileBrowserAudioPlayerDelegate: class {
    func playItems(for filePath: URL)
    func setupPlayerWidget(on controller: UIViewController)
}

class AudioPlayerChildViewController: UIViewController {
    
    var isPlaying: Bool = false {
        didSet {
            playerWidget.handlePlayButtonState(isPlaying: isPlaying)
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
    
    override func loadView() {
        view = playerWidget
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AudioPlayerChildViewController: FileBrowserAudioPlayerDelegate {
    
    func setupPlayerWidget(on controller: UIViewController) {
        playerWidget.removeFromSuperview()
        controller.view.addSubview(playerWidget)
        playerWidget.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        playerWidget.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
        playerWidget.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor).isActive = true
        playerWidget.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor).isActive = true
        playerWidget.isHidden = true
    }
    
    func playItems(for file: URL) {
        playerWidget.isHidden = false
        player.play(items: audioItems(for: file),
                    startAtIndex: FileManager.default.index(of: file))
        isPlaying = true
    }
    
    func audioItems(for filePath: URL) -> [AudioItem] {
        return FileManager.default.allFilesPathsInDirectory(filePath: filePath)?
            .flatMap({ (url) -> AudioItem? in
                return AudioItem(mediumQualitySoundURL: url)
            }) ?? []
    }
    
}

extension AudioPlayerChildViewController: PlayerWidgetDelegate {
    
    func onNext() {
        guard player.hasNext else {
            player.stop()
            playerWidget.isHidden = true
            return
        }
        player.next()
    }
    
    func onPrevious() {
        guard player.hasPrevious else {
            player.stop()
            playerWidget.isHidden = true
            return
        }
        player.previous()
    }
    
    func togglePlayStatus() {
        isPlaying = !isPlaying
        
        if isPlaying {
            player.resume()
        } else {
            player.pause()
        }
    }
    
}

extension AudioPlayerChildViewController: AudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
        playerWidget.trackTitle = "Now Playing:\n\(item.artist)\n\(item.title)"
    }
    
}
