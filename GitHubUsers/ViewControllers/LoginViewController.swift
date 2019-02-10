//
//  LoginViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/08.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import WebKit
import APIKit

class LoginViewController: CommonViewController {
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var loginWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginWebView.navigationDelegate = self
        
        guard let pageUrl = URL(string: "https://github.com/login/oauth/authorize?client_id=c82b3a07dbc4915a92d1&scope=user%20public_repo") else {
            return
        }
        let pageRequest = URLRequest(url: pageUrl)
        loginWebView.load(pageRequest)
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCloseButtonTapped(_:)))
        navigationItem.leftBarButtonItem = closeButton
        
        loadingView.stopLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 画面を閉じる前に読み込みを停止しておかないと、リークする。
        if loginWebView.isLoading {
            loginWebView.stopLoading()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    @objc private func onCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }    
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.scheme == "com.cawasemi.githubusers" {
                // リクエストがコールバックURLの場合、アクセストークンを取得する。
                loadingView.startLoading()
                saveAccessToken(url.query) {
                    // アクセストークンの取得が完了したら画面を閉じる。
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        decisionHandler(.allow)
    }
    
    private func saveAccessToken(_ query: String?, completion: @escaping () -> ()) {
        guard let dummy = query else {
            return
        }
        var wCode: String? = nil
        let items = dummy.components(separatedBy: ",")
        for item in items {
            let data = item.components(separatedBy: "=")
            if data.count == 2 || data[0] == "code" {
                wCode = data[1]
                break
            }
        }
        
        guard let code = wCode else {
            completion()
            return
        }
        
        let request = GitHubApiManager.AuthrizedRequest(code: code)
        APIKit.Session.send(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                GitHubApiManager.shared.accessToken = response.accessToken
                completion()
            case .failure(let error):
                self?.printError(error)
                let errorMessage = "認証に失敗しました。\n時間をおいて改めて操作をお願いします。"
                self?.showErrorMessage(errorMessage, completion: completion)
            }
        }
    }
}
