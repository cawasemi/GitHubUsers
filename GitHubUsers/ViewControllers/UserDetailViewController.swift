//
//  UserDetailViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import APIKit
import Nuke

class UserDetailViewController: CommonViewController {

    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var userDetailView: UIView!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var loginNameLabl: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followerTitleLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingTitleLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    var userName: String?
    
    private var repositories: [GitHubUserRepository] = []
    private lazy var countFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userIconView.image = nil
        loginNameLabl.text = nil
        fullNameLabel.text = nil
        followerTitleLabel.text = "フォロワー："
        followerCountLabel.text = nil
        followingTitleLabel.text = "フォロイー："
        followingCountLabel.text = nil
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Nuke.cancelRequest(for: userIconView)
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
        loadUserRepositories(user.login)

        if let urlString = user.iconUrl, let iconUrl = URL(string: urlString) {
            Nuke.loadImage(with: iconUrl, into: userIconView)
        }
        loginNameLabl.text = user.login
        fullNameLabel.text = user.name
        
        followerCountLabel.text = user.followers.decimalFormat
        followingCountLabel.text = user.following.decimalFormat
    }

    private func showApiErrorMessage(_ error: SessionTaskError) {
        printError(error)
        let errorMessage = "ユーザーの情報が取得できませんでした。\n時間をおいて改めて操作をお願いします。"
        showErrorMessage(errorMessage) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
