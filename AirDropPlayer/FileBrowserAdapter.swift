//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import FileBrowser

protocol FileBrowserAdaptable {
    var currentBrowser: FileBrowser? { get set }
    func reloadFileBrowser()
    var didSelectFile: ((FBFile) -> ())? { get set }
    func setupPlayerView(with view: UIView)
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
    
    func setupPlayerView(with view: UIView) {
        guard let currentBrowser = currentBrowser else {
            return
        }
        currentBrowser.view.addSubview(view)
        view.isHidden = true
        view.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        view.bottomAnchor.constraint(equalTo: currentBrowser.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: currentBrowser.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: currentBrowser.view.trailingAnchor).isActive = true
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
