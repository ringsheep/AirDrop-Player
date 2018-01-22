//
//  Created by George Zinyakov on 23/01/2018.
//

import Foundation
import KDEAudioPlayer

extension AudioPlayer {
    
    var isPlayingFirstItem: Bool {
        guard let currentItem = currentItem else { return false }
        return (items?.index(of: currentItem) == 0) ?? false
    }
    
}
