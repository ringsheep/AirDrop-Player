//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import FileBrowser

protocol FileBrowserAdaptable {
    var currentBrowser: FileBrowser? { get set }
    func reloadFileBrowser()
    var didSelectFile: ((FBFile) -> ())? { get set }
}

class FileBrowserAdapter: FileBrowserAdaptable {
    
    let inboxFolderUrlComponent = "Inbox/"
    lazy var inboxUrl = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask).last?.appendingPathComponent(inboxFolderUrlComponent)
    var currentBrowser: FileBrowser?
    
    func reloadFileBrowser() {
        let browser = FileBrowser(initialPath: inboxUrl,
                                  allowEditing: true,
                                  showCancelButton: false)
        browser.didSelectFile = didSelectFile
        currentBrowser = browser
    }
    
    var didSelectFile: ((FBFile) -> ())? {
        get {
            return currentBrowser?.didSelectFile
        }
        set(newValue) {
            currentBrowser?.didSelectFile = newValue
        }
    }
    
}
