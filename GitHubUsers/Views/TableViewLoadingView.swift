//
//  TableViewLoadingView.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/11.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit

@IBDesignable
class TableViewLoadingView: UITableViewHeaderFooterView {
    class var reuseIdentifier: String {
        return "tableViewLoadingView"
    }

    private weak var activityIndicatorView: UIActivityIndicatorView? = nil

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        if let _ = activityIndicatorView {
            return
        }
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)
        self.activityIndicatorView = indicatorView
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView?.startAnimating()
    }
}
