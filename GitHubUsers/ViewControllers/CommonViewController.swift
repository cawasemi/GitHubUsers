//
//  CommonViewController.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit
import APIKit

class CommonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    final func showErrorMessage(_ errorMessage: String, completion: (() -> Void)?) {
        let alertTitle = "エラー"
        let alert = UIAlertController(title: alertTitle, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    final func printError(_ error: SessionTaskError) {
        switch error {
        case .responseError(let error as GitHubError):
            print(error.message) // Prints message from GitHub API
            
        case .connectionError(let error):
            print("Connection error: \(error)")
            
        default:
            print("System error :bow:")
        }
    }
}

extension Int64 {
    var decimalFormat: String {
        if self < 1000 {
            return String(format: "%d", self)
        }
        let kValue = Double(self) / 1000
        if kValue < 1000 {
            return String(format: "%.1lfk", kValue)
        }
        let mValue = kValue / 1000
        return String(format: "%.1lfm", mValue)
    }
}
