//
//  LoadingView.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingView: UIView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    private func commonInit() {
        guard let targetView = R.nib.loadingView(owner: self, options: nil) else {
            return
        }
        backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        targetView.backgroundColor = UIColor.clear
        activityIndicatorView.backgroundColor = UIColor.clear
        messageLabel.text = nil
        addSubview(targetView)
    }
    
    /// 読み込み中部品を表示する。
    func startLoading(_ message: String? = nil) {
        if let parentView = superview {
            parentView.bringSubviewToFront(self)
        }

        self.alpha = 1.0
        messageLabel.text = message
        messageLabel.isHidden = (message == nil)
        activityIndicatorView.startAnimating()
    }
    
    /// 読み込み中部品を非表示にする。
    func stopLoading() {
        if let parentView = superview {
            parentView.sendSubviewToBack(self)
        }
        self.alpha = 0.0
        activityIndicatorView.stopAnimating()
    }
}
