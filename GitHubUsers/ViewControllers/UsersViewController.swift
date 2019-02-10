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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCloseButtonTapped(_:)))
        navigationItem.leftBarButtonItem = closeButton

        usersTableView.register(R.nib.userTableViewCell)
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        loadUsers()
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
    
    private func loadUsers() {
//        guard let userApi = URL(string: "https://api.github.com/users") else {
//            return
//        }
//        let accessToken = GitHubApiManager.shared.accessToken
//        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
//        var urlRequest = URLRequest(url: userApi)
//        urlRequest.allHTTPHeaderFields = ["Authorization": accessToken]
//        let task = session.dataTask(with: urlRequest) { (data, response, error) in
//            if let wError = error {
//                dump(wError)
//                return
//            }
//            guard let receivedData = data, let result = String(data: receivedData, encoding: String.Encoding.utf8) else {
//                return
//            }
//            print(result)
//        }
//        task.resume()
        
        let request = GitHubApiManager.RateLimitRequest()//GitHubAPI.SearchUsersRequest(query: "ca")
        APIKit.Session.send(request) { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                dump(error)
            }
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 123
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.userTableViewCell, for: indexPath)!
        userCell.prepareUserData(iconUrl: nil, userName: "\(indexPath)")
        return userCell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0 + 16.0
    }
}
