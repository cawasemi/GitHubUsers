//
//  UserDetailViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import APIKit

class UserDetailViewController: CommonViewController {

    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var userDetailView: UIView!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    var userName: String?
    
    private var repositories: [GitHubUserRepository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadUser()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func loadUser() {
        guard let name = userName else {
            return
        }
        
        loadingView.startLoading()

        let request = GitHubApiManager.GitHubUserRequest(login: name)
        APIKit.Session.send(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.updateUserData(response)
            case .failure(let error):
                self?.showApiErrorMessage(error)
            }
        }
    }

    private func loadUserRepositories(_ login: String) {
        let request = GitHubApiManager.GitHubUserRepositoriesRequest(login: login)
        APIKit.Session.send(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.repositories = response
                break
            case .failure(let error):
                self?.printError(error)
            }
        }
    }
    
    private func updateUserData(_ user: GitHubUser) {
        loadingView.stopLoading()
        print(user)
        loadUserRepositories(user.login)
    }

    private func showApiErrorMessage(_ error: SessionTaskError) {
        printError(error)
        let errorMessage = "ユーザーの情報が取得できませんでした。\n時間をおいて改めて操作をお願いします。"
        showErrorMessage(errorMessage) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
