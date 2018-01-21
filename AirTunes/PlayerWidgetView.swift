//
//  Created by George Zinyakov on 21/01/2018.
//

import Foundation
import UIKit

protocol PlayerWidgetDelegate: class {
    func onNext()
    func onPrevious()
    func togglePlayStatus()
}

class PlayerWidgetView: UIView {
    
    struct Appearance {
        var deafaultOffset: CGFloat = 5.0
        var playButtonSide: CGFloat = 50.0
        var nextPreviousButtonSide: CGFloat = 30.0
        var trackTitleLabelFontSize: CGFloat = 14.0
        var playButtonFontSize: CGFloat = 40.0
    }
    
    let appearance = Appearance()
    weak var delegate: PlayerWidgetDelegate?
    
    lazy var trackTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: self.appearance.trackTitleLabelFontSize)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("▶️", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: self.appearance.playButtonFontSize)
        button.addTarget(self,
                         action: #selector(togglePlayStatus),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("⏩", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(onNext),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("⏪", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(onPrevious),
                         for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        setupSubiews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubiews() {
        addSubview(trackTitleLabel)
        addSubview(playButton)
        addSubview(nextButton)
        addSubview(previousButton)
    }
    
    func setupConstraints() {
        setupNextButtonConstraints()
        setupPlayButtonConstraints()
        setupPreviousButtonConstraints()
        setupTrackTitleLabelConstraints()
    }
    
    func setupNextButtonConstraints() {
        nextButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -appearance.deafaultOffset).isActive = true
        nextButton.topAnchor.constraint(equalTo: topAnchor,
                                        constant: appearance.deafaultOffset).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                           constant: -appearance.deafaultOffset).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: appearance.nextPreviousButtonSide).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: appearance.nextPreviousButtonSide).isActive = true
    }
    
    func setupPlayButtonConstraints() {
        playButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor,
                                             constant: -appearance.deafaultOffset).isActive = true
        playButton.topAnchor.constraint(equalTo: topAnchor,
                                        constant: appearance.deafaultOffset).isActive = true
        playButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                           constant: -appearance.deafaultOffset).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: appearance.playButtonSide).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: appearance.playButtonSide).isActive = true
    }
    
    func setupPreviousButtonConstraints() {
        previousButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor,
                                                 constant: -appearance.deafaultOffset).isActive = true
        previousButton.topAnchor.constraint(equalTo: topAnchor,
                                            constant: appearance.deafaultOffset).isActive = true
        previousButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -appearance.deafaultOffset).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant: appearance.nextPreviousButtonSide).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant: appearance.nextPreviousButtonSide).isActive = true
    }
    
    func setupTrackTitleLabelConstraints() {
        trackTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: appearance.deafaultOffset).isActive = true
        trackTitleLabel.topAnchor.constraint(equalTo: topAnchor,
                                             constant: appearance.deafaultOffset).isActive = true
        trackTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                constant: -appearance.deafaultOffset).isActive = true
        trackTitleLabel.trailingAnchor.constraint(equalTo: previousButton.leadingAnchor,
                                                  constant: -appearance.deafaultOffset).isActive = true
    }
    
    func handlePlayButtonState(isPlaying: Bool) {
        if isPlaying {
            playButton.setTitle("⏸", for: .normal)
        } else {
            playButton.setTitle("▶️", for: .normal)
        }
    }
    
    var trackTitle: String? {
        get {
            return trackTitleLabel.text
        }
        set(newValue) {
            trackTitleLabel.text = newValue
        }
    }
    
    @objc func onNext() {
        delegate?.onNext()
    }
    
    @objc func onPrevious() {
        delegate?.onPrevious()
    }
    
    @objc func togglePlayStatus() {
        delegate?.togglePlayStatus()
    }
}
