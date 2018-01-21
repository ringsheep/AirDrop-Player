//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import KDEAudioPlayer
import MediaPlayer

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
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            player.remoteControlReceived(with: event)
        }
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
        guard file.isAudioType else {
            return
        }
        playerWidget.isHidden = false
        let itemsPaths = audioPaths(for: file)
        player.play(items: audioItems(with: itemsPaths),
                    startAtIndex: itemsPaths.index(of: file) ?? 0)
        isPlaying = true
    }
    
    func audioPaths(for filePath: URL) -> [URL] {
        return FileManager.default.allFilesPathsInDirectory(filePath: filePath)?
            .flatMap({ (url) -> URL? in
                if url.isAudioType {
                    return url
                } else {
                    return nil
                }
            }) ?? []
    }
    
    func audioItems(with audioPaths: [URL]) -> [AudioItem] {
        return audioPaths.flatMap({ (url) -> AudioItem? in
            return AudioItem(mediumQualitySoundURL: url)
        })
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
        let prefix = "Now Playing:"
        let artist = item.artist ?? ""
        let title = item.title ?? ""
        
        if artist.isEmpty || title.isEmpty {
            playerWidget.trackTitle = prefix + "\n" + item.mediumQualityURL.url.lastPathComponent
        } else {
            playerWidget.trackTitle = prefix + "\n" + artist + "\n" + title
        }
    }
    
}
