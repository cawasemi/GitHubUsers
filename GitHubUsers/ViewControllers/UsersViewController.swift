//
//  UsersViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import APIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    fileprivate var users: [GitHubUser] = []
    fileprivate var pageNo: Int = 1
    private var isCallingApi: Bool = false
    private var totalUers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usersTableView.register(R.nib.userTableViewCell)
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        userSearchBar.delegate = self
        
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

    @objc private func onCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadUsers(nextPageNo: Int) {
        if isCallingApi {
            return
        }
        isCallingApi = true
        guard let keyword = userSearchBar.text, !keyword.isEmpty else {
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
                dump(error)
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
                dump(error)
            }
            self?.isCallingApi = false
        }
    }
    
    private func updateUsersTableView(_ users: [GitHubUser], nextPageNo: Int) {
        if nextPageNo <= 1 {
            self.users.removeAll()
        }
        pageNo = nextPageNo
        self.users.append(contentsOf: users)
        usersTableView.reloadData()
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
        userCell.prepareUserData(iconUrl: user.iconUrl, userName: user.name)
        return userCell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let detailVC = UserDetailViewController()
        detailVC.userId = user.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 0 < self.users.count
            && self.users.count < totalUers
            && self.users.count - indexPath.row < 5 {
            loadUsers(nextPageNo: pageNo + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0 + 16.0
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadUsers(nextPageNo: 1)
    }
}
