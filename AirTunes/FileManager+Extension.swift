//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation

extension FileManager {
    
    func index(of filePath: URL) -> Int {
        return allFilesPathsInDirectory(filePath: filePath)?.index(of: filePath) ?? 0
    }
    
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
