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
    
    private var totalRepositories: Int = 0
    
    private var pageNo: Int = 0
    
    private var isCallingApi: Bool = false
    
    private var cellHeights: [Int64: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userDetailView.alpha = 0.0
        userIconView.image = nil
        loginNameLabl.text = nil
        fullNameLabel.text = nil
        followerTitleLabel.text = "フォロワー："
        followerCountLabel.text = nil
        followingTitleLabel.text = "フォロイー："
        followingCountLabel.text = nil

        repositoriesTableView.register(R.nib.repositoryTableViewCell)
        repositoriesTableView.dataSource = self
        repositoriesTableView.delegate = self
        
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

    private func loadUserRepositories(nextPageNo: Int) {
        if isCallingApi {
            return
        }
        
        guard let login = userName else {
            return
        }

        isCallingApi = true
        let request = GitHubApiManager.GitHubUserRepositoriesRequest(login: login, pageNo: nextPageNo)
        APIKit.Session.send(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.repositories = response
                self?.repositoriesTableView.reloadData()
                break
            case .failure(let error):
                self?.printError(error)
            }
            self?.isCallingApi = false
        }
    }
    
    private func updateUserData(_ user: GitHubUser) {
        userDetailView.alpha = 1.0
        loadingView.stopLoading()
        loadUserRepositories(nextPageNo: 1)

        if let urlString = user.iconUrl, let iconUrl = URL(string: urlString) {
            Nuke.loadImage(with: iconUrl, into: userIconView)
        }
        loginNameLabl.text = user.login
        fullNameLabel.text = user.name
        
        followerCountLabel.text = user.followers.decimalFormat
        followingCountLabel.text = user.following.decimalFormat
    }
    
    private func updateUserRepositoriesData(_ repositories: [GitHubUserRepository]) {
        
    }

    private func showApiErrorMessage(_ error: SessionTaskError) {
        printError(error)
        let errorMessage = "ユーザーの情報が取得できませんでした。\n時間をおいて改めて操作をお願いします。"
        showErrorMessage(errorMessage) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}


extension UserDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.repositoryTableViewCell, for: indexPath)!
        let repo = repositories[indexPath.row]
        cell.prepareRepositoryData(repo)
        return cell
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 0 < self.repositories.count
            && self.repositories.count < totalRepositories
            && self.repositories.count - indexPath.row <= 5 {
            // 表示されていないデータが一定数以下になったら、次のページを読みに行く。
            loadUserRepositories(nextPageNo: pageNo + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let repo = repositories[indexPath.row]
        if let height = cellHeights[repo.id] {
            return height
        }
        let height = RepositoryTableViewCell.cellHeight(repo, baseWidth: tableView.frame.width)
        cellHeights[repo.id] = height
        return height
    }
}
