//
//  UsersViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import APIKit
import PromiseKit

class UsersViewController: CommonViewController {

    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var emptyMessageView: EmptyMessageView!
    @IBOutlet weak var blankView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var leftItemView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var separatorLineView: UIView!
    @IBOutlet weak var usersTableView: UITableView!

    fileprivate let cellHeigh: CGFloat = 64.0 + 8.0 * 2
    
    /// ユーザー一覧
    fileprivate var users: [GitHubSearchUser] = []
    
    private lazy var allUsersRequest: GitHubApiAllhUsers = {
        return GitHubApiAllhUsers()
    }()
    
    private lazy var searchUsersRequest: GitHubApiSearchUsers = {
        return GitHubApiSearchUsers()
    }()

    /// 検索条件に一致するユーザー数
    ///
    /// 現在表示しているユーザー数ではない。
    private var totalUers: Int64 = 0

    /// 取得ずみのページ数
    fileprivate var pageNo: Int64 = 1

    /// API処理中を表す
    private var isCallingApi: Bool = false
    
    /// すべてのユーザーを表示していることを表す。
    private var isAllUsers: Bool = false
    
    /// 最初の画面表示を表す。
    ///
    /// 一度 true になったら false に戻ることはない。
    private var isFirstAppear: Bool = false

    /// ユーザー情報を更新することを表す。
    private var willRefreshUserData: Bool = false
    
    /// 検索キーワード
    ///
    /// 検索バーでキャンセルされた時に表示を戻すため。
    private var searchKeyword: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isFirstAppear = true
        usersTableView.register(R.nib.userTableViewCell)
        usersTableView.estimatedRowHeight = cellHeigh
        usersTableView.rowHeight = cellHeigh
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshUserData(_:)), for: .valueChanged)
        usersTableView.refreshControl = refreshControl
        
        // 指が離れた時に Pull to Refresh を行いたいので、
        // Table View の Pan Gesture にイベントを追加する。
        usersTableView.panGestureRecognizer.addTarget(self, action: #selector(onTableViewPanGestureEvent(_:)))

        menuButton.addTarget(self, action: #selector(onMenuButtonTapped(_:)), for: .touchUpInside)
        
        userSearchBar.placeholder = "ユーザー名から検索します"
        userSearchBar.delegate = self
        
        // 検索条件入力中に Table View を覆い操作できないようにするための View
        blankView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        blankView.alpha = 0.0
        blankView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBlankViewTapped(_:))))
        
        menuView.eventDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if isFirstAppear {
            // 最初の画面表示であればデータを取得する。
            willLoadUsers(nextPageNo: 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 画面が表示された時に選択されているセルを解除する。
        if let selectedRows = usersTableView.indexPathsForSelectedRows {
            selectedRows.forEach { (indexPath) in
                usersTableView.deselectRow(at: indexPath, animated: true)
            }
        }

        isFirstAppear = false
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
        userSearchBar.text = searchKeyword
    }
    
    @objc private func refreshUserData(_ sender: Any) {
        // Pull to Refresh を予約する。
        willRefreshUserData = true
    }
    
    @objc private func onTableViewPanGestureEvent(_ sender: Any) {
        guard let panGesture = sender as? UIPanGestureRecognizer else {
            return
        }
        if panGesture.state != .ended {
            // 終了イベント以外は処理しない。
        } else if willRefreshUserData {
            // 指が離れた時に　Pull to Refresh が予約されていれば処理する。
            willLoadUsers(nextPageNo: 1)
            willRefreshUserData = false
        }
    }
    
    @objc private func onMenuButtonTapped(_ sender: Any) {
        menuView.showMenu()
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
            self?.userSearchBar.showsCancelButton = true
            self?.view.layoutIfNeeded()
        }
    }
    
    fileprivate func hideBlankView() {
        userSearchBar.resignFirstResponder()

        if blankView.alpha < 1.0 {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blankView.alpha = 0.0
            self?.userSearchBar.showsCancelButton = false
            self?.view.layoutIfNeeded()
        }) { [weak self] (finished) in
            guard let parentView = self?.view, let targetView = self?.blankView else {
                return
            }
            parentView.sendSubviewToBack(targetView)
        }
    }
    
    // MARK: - Call Api

    /// 検索条件に一致するユーザーを取得する。
    private func willLoadUsers(nextPageNo: Int64) {
        if isCallingApi {
            return
        }
        isCallingApi = true
        emptyMessageView.hideMessage()

        if nextPageNo <= 1 {
            self.users.removeAll()
            self.usersTableView.reloadData()
        }
        
        loadUsers(nextPageNo: nextPageNo).done { [weak self] (users) in
            self?.totalUers = users.totalCount
            self?.updateUsersTableView(users.items, nextPageNo: nextPageNo)
        }.ensure { [weak self] in
            self?.didLoadUserData()
        }.catch { [weak self] (error) in
            if let wError = error as? SessionTaskError {
                self?.showApiErrorMessage(wError)
            }
        }
    }
    
    private func loadUsers(nextPageNo: Int64) -> Promise<GitHubUsers> {
        guard let keyword = userSearchBar.text?.trimmingCharacters(in: .whitespaces), !keyword.isEmpty else {
            // キーワードが入力されていない場合は、すべてのユーザーを検索する。
            return loadAllUsers(nextPageNo: nextPageNo)
        }

        isAllUsers = false
        return searchUsersRequest.next(nextPageNo, query: keyword)
    }
    
    /// すべてのユーザーを取得する。
    private func loadAllUsers(nextPageNo: Int64) -> Promise<GitHubUsers> {
        isAllUsers = true
        return allUsersRequest.next(nextPageNo)
    }
    
    /// ユーザー情報の取得が完了した時の処理を行う。
    private func didLoadUserData() {
        isCallingApi = false
        
        if self.usersTableView.refreshControl?.isRefreshing == true {
            self.usersTableView.refreshControl?.endRefreshing()
        }
    }
    
    /// ユーザー一覧テーブルを更新する。
    private func updateUsersTableView(_ users: [GitHubSearchUser], nextPageNo: Int64) {
        if nextPageNo <= 1 {
            self.users.removeAll()
            usersTableView.setContentOffset(.zero, animated: false)
        }
        if 1 < nextPageNo && users.isEmpty {
            // 最初のページ以外で検索結果が０件の場合はこれ以上取得できるものがないので
            // これ以上検索させないために合計ユーザー数を表示数以上にする。
            totalUers = Int64(self.users.count) + 1
            return
        } else if isAllUsers {
            // すべてのユーザーを表示している場合は次のユーザーIDを設定する。
            pageNo = (users.last?.id ?? 0) + 1
        } else {
            // すべてのユーザーを表示していない（ユーザー検索）場合は素直に次のページを設定する。
            pageNo = nextPageNo
        }
        if 0 < users.count {
            for user in users {
                // 同じデータが来ることがあるので除外する。
                if let _ = self.users.last(where: {$0.id == user.id}) {
                    print("duplicate :: \(user)")
                    continue
                }
                self.users.append(user)
            }
        }
        usersTableView.reloadData()
        if self.users.count == 0 {
            let emptyMessage = "指定された条件ではユーザーを見つけることはできませんでした。"
            emptyMessageView.showMessage(emptyMessage)
        }
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
        if let user = users.tryGet(indexPath.row) {
            userCell.prepareUserData(iconUrl: user.iconUrl, userName: user.login)
        }
        return userCell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = users.tryGet(indexPath.row) else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let detailVC = UserDetailViewController()
        detailVC.userName = user.login
        detailVC.userId = user.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 0 < self.users.count
            && self.users.count - indexPath.row <= 5 {
            if 0 < totalUers && totalUers <= self.users.count {
                return
            }
            // 表示されていないデータが一定数以下になったら、次のページを読みに行く。
            willLoadUsers(nextPageNo: pageNo + 1)
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
        searchBar.text = searchKeyword
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideBlankView()
        searchKeyword = searchBar.text
        willLoadUsers(nextPageNo: 1)
    }
}

extension UsersViewController: MenuViewDelegate {
    func menuView(_ menuView: MenuView, didSelectMenu menu: MenuView.MenuItems) {
        GitHubApiManager.shared.clearAccessToken()
        dismiss(animated: true, completion: nil)
    }
}
