//
//  Created by George Zinyakov on 22/01/2018.
//

import Foundation
import AVFoundation

extension URL {
    
    var isAudioType: Bool {
        let availableTypes: [String] = AVURLAsset.audiovisualMIMETypes()
            .map({ $0.replacingOccurrences(of: "audio/", with: "") })
        return availableTypes.contains(pathExtension)
    }
    
}
