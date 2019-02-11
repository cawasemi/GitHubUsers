//
//  MenuView.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/11.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit

protocol MenuViewDelegate: NSObjectProtocol {
    func menuView(_ menuView: MenuView, didSelectMenu menu: MenuView.MenuItems)
}

@IBDesignable
class MenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    enum MenuItems: Int {
        case logout = 0
        case numberOfItems
        
        var name: String {
            switch self {
            case .logout: return "ログアウト"
            case .numberOfItems: return ""
            }
        }
    }
    
    private let menuCellIdentifier: String = "menuCellIdentifier"

    @IBOutlet weak var blankView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuTableViewWidth: NSLayoutConstraint!
    @IBOutlet weak var menuTableViewLeading: NSLayoutConstraint!
    
    weak var eventDelegate: MenuViewDelegate? = nil
    
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
        guard let targetView = R.nib.menuView(owner: self, options: nil) else {
            return
        }
        addSubview(targetView)

        // 文字列
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: menuCellIdentifier)
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        // 背景色を透明にする。
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        subviews.forEach({$0.backgroundColor = UIColor(white: 0.0, alpha: 0.0)})
        
        // Table View の右側の領域をタップしたらメニュー画面が閉じるようにしたい。
        blankView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapGestuerEvent(_:))))
        
    }
    
    @objc private func onTapGestuerEvent(_ sender: Any) {
        guard let tapGesture = sender as? UITapGestureRecognizer else {
            return
        }
        if tapGesture.state == .ended {
            hideMenu()
        }
    }
    
    func showMenu() {
        if let parentVeiw = superview {
            parentVeiw.bringSubviewToFront(self)
        }
        
        blankView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        menuTableViewLeading.constant = -menuTableViewWidth.constant
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.blankView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            self?.menuTableViewLeading.constant = 0.0
            self?.layoutIfNeeded()
        }
    }
    
    func hideMenu() {
        let menuWidth = menuTableViewWidth.constant
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.blankView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            self?.menuTableViewLeading.constant = -menuWidth
            self?.layoutIfNeeded()
        }) { [weak self] (finished) in
            guard let targetView = self, let parentVeiw = targetView.superview else {
                return
            }
            parentVeiw.sendSubviewToBack(targetView)
        }
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItems.numberOfItems.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellIdentifier, for: indexPath)
        cell.textLabel?.text = MenuItems(rawValue: indexPath.row)?.name
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = MenuItems(rawValue: indexPath.row) else {
            return
        }
        eventDelegate?.menuView(self, didSelectMenu: menu)
    }
}
