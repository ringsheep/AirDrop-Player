//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation

extension FileManager {
    
    func allFilesPathsInDirectory(filePath: URL) -> [URL]? {
        let currentDirectory = filePath.deletingLastPathComponent()
        let allPathsInDirectory = try? contentsOfDirectory(at: currentDirectory,
                                                           includingPropertiesForKeys: [],
                                                           options: [.skipsHiddenFiles,
                                                                     .skipsPackageDescendants,
                                                                     .skipsSubdirectoryDescendants])
        return allPathsInDirectory
    }
    
}
