//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/07.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import KeychainAccess

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        loginButton.addTarget(self, action: #selector(onLoginButtonTapped(_:)), for: .touchUpInside)
        loginButton.alpha = 0.0
        let buttonTitle = "ログイン"
        loginButton.setTitle(buttonTitle, for: .normal)
        
        URLCache.shared.removeAllCachedResponses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !GitHubApiManager.shared.hasAccessToken {
            // アクセストークンが存在していない場合はログインボタンを表示する。
            loginButton.alpha = 1.0
            return
        }

        let usersVC = UsersViewController()
        let mainNC = UINavigationController(rootViewController: usersVC)
        present(mainNC, animated: true, completion: nil)
    }
    
    @objc func onLoginButtonTapped(_ sender: Any?) {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        present(nav, animated: true, completion: nil)
    }
}
