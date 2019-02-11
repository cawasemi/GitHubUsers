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
    /// 対象の数値を整形する。
    ///
    /// 対象の数値が 1,000 未満であればそのまま。
    /// 対象の数値が 1,000 以上であれば 12.3k のように変換。
    /// 対象の数値が 1,000,000 以上であれば　45.6m のように変換。
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

extension String {
    /// 対象の文字列を表示するのに必要なサイズを取得する。
    func requiredSize(maxWidth: CGFloat, font: UIFont) -> CGSize {
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font]
        let target = NSAttributedString(string: self, attributes: attributes)
        let rect = target.boundingRect(with: CGSize(width: maxWidth, height: 1024), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
}

extension Array {
    /// 指定されたインデックスが対象の配列の範囲内であるか確認し、範囲外であれば nil を返す。
    func tryGet(_ index: Int) -> Element? {
        if 0 <= index && index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}
