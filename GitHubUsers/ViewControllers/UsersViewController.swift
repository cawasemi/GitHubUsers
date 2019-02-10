//
//  UsersViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import APIKit

class UsersViewController: CommonViewController {

    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var blankView: UIView!
    
    fileprivate let cellHeigh: CGFloat = 64.0 + 8.0 * 2
    
    fileprivate var users: [GitHubSearchUser] = []
    fileprivate var pageNo: Int = 1
    private var isCallingApi: Bool = false
    private var totalUers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usersTableView.register(R.nib.userTableViewCell)
        usersTableView.estimatedRowHeight = cellHeigh
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        userSearchBar.delegate = self
        
        blankView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        blankView.alpha = 0.0
        blankView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBlankViewTapped(_:))))

        loadUsers(nextPageNo: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 画面がh表示された時に選択されているセルを解除する。
        if let selectedRows = usersTableView.indexPathsForSelectedRows {
            selectedRows.forEach { (indexPath) in
                usersTableView.deselectRow(at: indexPath, animated: true)
            }
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
    
    /// MARK: - Event Handler

    @objc private func onCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func onBlankViewTapped(_ sender: Any) {
        hideBlankView()
    }
    
    // MARK: - View Control
    
    fileprivate func showBlankView() {
        if 0.0 < blankView.alpha {
            return
        }
        view.bringSubviewToFront(blankView)
        blankView.alpha = 0.0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.blankView.alpha = 1.0
        }
    }
    
    fileprivate func hideBlankView() {
        userSearchBar.resignFirstResponder()

        if blankView.alpha < 1.0 {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blankView.alpha = 0.0
        }) { [weak self] (finished) in
            guard let parentView = self?.view, let targetView = self?.blankView else {
                return
            }
            parentView.sendSubviewToBack(targetView)
        }
    }
    
    // MARK: - Call Api
    
    private func loadCurrentUser() {
        let request = GitHubApiManager.GitHubCurrentUserRequest()
        APIKit.Session.send(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                GitHubApiManager.shared.currentLogin = response.login
            case .failure(let error):
                self?.printError(error)
            }
        }
    }

    private func loadUsers(nextPageNo: Int) {
        if isCallingApi {
            return
        }
        isCallingApi = true
        guard let keyword = userSearchBar.text, !keyword.isEmpty else {
            // キーワードが入力されていない場合は、すべてのユーザーを検索する。
            loadAllUsers()
            return
        }
        
        let request = GitHubApiManager.SearchUsersRequest(query: keyword, pageNo: nextPageNo)
        APIKit.Session.send(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.totalUers = response.totalCount
                self?.updateUsersTableView(response.items, nextPageNo: nextPageNo)
            case .failure(let error):
                self?.showApiErrorMessage(error)
            }
            self?.isCallingApi = false
        }
    }
    
    private func loadAllUsers() {
        let request = GitHubApiManager.AllUsersRequest()
        APIKit.Session.send(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.totalUers = 0
                self?.updateUsersTableView(response, nextPageNo: 0)
            case .failure(let error):
                self?.showApiErrorMessage(error)
            }
            self?.isCallingApi = false
        }
    }
    
    private func updateUsersTableView(_ users: [GitHubSearchUser], nextPageNo: Int) {
        if nextPageNo <= 1 {
            self.users.removeAll()
        }
        pageNo = nextPageNo
        self.users.append(contentsOf: users)
        usersTableView.reloadData()
    }
    
    private func showApiErrorMessage(_ error: SessionTaskError) {
        printError(error)
        let errorMessage = "ユーザーの検索に失敗しました。\n時間をおいて改めて操作をお願いします。"
        showErrorMessage(errorMessage, completion: nil)
    }
}

extension UsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.userTableViewCell, for: indexPath)!
        let user = users[indexPath.row]
        userCell.prepareUserData(iconUrl: user.iconUrl, userName: user.login)
        return userCell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let detailVC = UserDetailViewController()
        detailVC.userName = user.login
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 0 < self.users.count
            && self.users.count < totalUers
            && self.users.count - indexPath.row <= 5 {
            // 表示されていないデータが一定数以下になったら、次のページを読みに行く。
            loadUsers(nextPageNo: pageNo + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeigh
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showBlankView()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideBlankView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideBlankView()
        loadUsers(nextPageNo: 1)
    }
}
