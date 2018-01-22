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
            return
        }
        player.nextOrStop()
    }
    
    func onPrevious() {
        player.pause()
        if player.hasPrevious == false || player.isPlayingFirstItem {
            player.stop()
            return
        }
        player.previous()
    }
    
    func togglePlayStatus() {
        if player.state == .paused {
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
        let itemsPaths = audioPaths(for: file)
        player.play(items: audioItems(with: itemsPaths),
                    startAtIndex: itemsPaths.index(of: file) ?? 0)
    }
    
    func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            player.remoteControlReceived(with: event)
        }
    }
    
}

extension AudioPlayerViewModel: AudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: AudioPlayer,
                     didChangeStateFrom from: AudioPlayerState,
                     to state: AudioPlayerState) {
        switch state {
        case .stopped:
            viewDelegate?.handleAppearanceStatus(isHidden: true)
            viewDelegate?.handlePlayButtonState(isPlaying: false)
        case .paused:
            viewDelegate?.handlePlayButtonState(isPlaying: false)
        case .playing:
            viewDelegate?.handleAppearanceStatus(isHidden: false)
            viewDelegate?.handlePlayButtonState(isPlaying: true)
        default:
            break
        }
    }
    
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
