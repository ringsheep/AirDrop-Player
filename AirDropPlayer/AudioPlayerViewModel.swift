//
//  Created by George Zinyakov on 22/01/2018.
//

import Foundation
import KDEAudioPlayer
import MediaPlayer

protocol FileBrowserAudioPlayerDelegate: PlayerControlDelegate {
    func playItems(for filePath: URL)
    func remoteControlReceived(with event: UIEvent?)
    var viewDelegate: AudioPlayerViewDelegate? { get set }
}

protocol AudioPlayerViewDelegate: class {
    func handlePlayButtonState(isPlaying: Bool)
    func handleAppearanceStatus(isHidden: Bool)
    var trackTitle: String? { get set }
}

class AudioPlayerViewModel {
    
    weak var viewDelegate: AudioPlayerViewDelegate?
    
    var isPlaying: Bool = false {
        didSet {
            viewDelegate?.handlePlayButtonState(isPlaying: isPlaying)
        }
    }
    
    lazy var player: AudioPlayer = {
        let player = AudioPlayer()
        player.delegate = self
        return player
    }()
    
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

extension AudioPlayerViewModel: PlayerControlDelegate {
    
    func onNext() {
        player.pause()
        guard player.hasNext else {
            player.stop()
            viewDelegate?.handleAppearanceStatus(isHidden: true)
            return
        }
        player.nextOrStop()
    }
    
    func onPrevious() {
        player.pause()
        if player.hasPrevious == false || player.isPlayingFirstItem {
            player.stop()
            viewDelegate?.handleAppearanceStatus(isHidden: true)
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

extension AudioPlayerViewModel: FileBrowserAudioPlayerDelegate {
    
    func playItems(for file: URL) {
        guard file.isAudioType else {
            return
        }
        viewDelegate?.handleAppearanceStatus(isHidden: false)
        let itemsPaths = audioPaths(for: file)
        player.play(items: audioItems(with: itemsPaths),
                    startAtIndex: itemsPaths.index(of: file) ?? 0)
        isPlaying = true
    }
    
    func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            player.remoteControlReceived(with: event)
        }
    }
    
}

extension AudioPlayerViewModel: AudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
        let prefix = "Now Playing:"
        let artist = item.artist ?? ""
        let title = item.title ?? ""
        
        if artist.isEmpty || title.isEmpty {
            viewDelegate?.trackTitle = prefix + "\n" + item.mediumQualityURL.url.lastPathComponent
        } else {
            viewDelegate?.trackTitle = prefix + "\n" + artist + "\n" + title
        }
    }
    
}
