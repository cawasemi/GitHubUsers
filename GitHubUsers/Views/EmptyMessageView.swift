//
//  EmptyMessageView.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/11.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit

@IBDesignable
class EmptyMessageView: UIView {

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
    
    private func commonInit() {
        guard let targetView = R.nib.emptyMessageView(owner: self, options: nil) else {
            return
        }
        addSubview(targetView)
        messageLabel.text = nil
    }
    
    func showMessage(_ message: String) {
        if let parentView = superview {
            parentView.bringSubviewToFront(self)
        }
        self.alpha = 1.0
        messageLabel.text = message
    }
    
    func hideMessage() {
        if let parentView = superview {
            parentView.sendSubviewToBack(self)
        }
        self.alpha = 0.0
    }
}
