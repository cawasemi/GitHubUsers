//
//  RepositoryTableViewCell.swift
//  GitHubUsers
//
//  Created by Shusaku Harada on 2019/02/10.
//  Copyright © 2019 Shusaku Harada. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    /// リポジトリ名ラベル用のフォント
    class var nameFont: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }
    
    /// 開発言語タイトルラベル用のフォント
    class var languageTitletFont: UIFont {
        return UIFont.systemFont(ofSize: 15.0, weight: .regular)
    }

    /// 開発言語ラベル用のフォント
    class var languageFont: UIFont {
        return UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    }
    
    /// スタータイトルラベル用のフォント
    class var stargazersTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    }

    /// スター数ラベル用のフォント
    class var stargazersFont: UIFont {
        return UIFont.systemFont(ofSize: 15.0, weight: .regular)
    }
    
    /// 説明ラベル用のフォント
    class var descriptionFont: UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }
    
    class func cellHeight(_ value: GitHubUserRepository, baseWidth: CGFloat) -> CGFloat {
        let maxWidth = baseWidth - 16.0 * 2
        var height: CGFloat = 0
        height += 12.0
        height += nameFont.capHeight
        height += 8.0
        height += languageFont.capHeight
        height += 8.0
        height += descriptionFont.capHeight * 3
        height += 12.0
        return height
    }

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var languageTitleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var stargazersTitleLabel: UILabel!
    @IBOutlet weak var stargazersLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        repositoryNameLabel.font = RepositoryTableViewCell.nameFont
        languageTitleLabel.font = RepositoryTableViewCell.languageTitletFont
        languageLabel.font = RepositoryTableViewCell.languageFont
        stargazersTitleLabel.font = RepositoryTableViewCell.stargazersTitleFont
        stargazersLabel.font = RepositoryTableViewCell.stargazersFont
        repositoryDescriptionLabel.font = RepositoryTableViewCell.descriptionFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        repositoryNameLabel.text = nil
        languageLabel.text = nil
        stargazersLabel.text = nil
        repositoryDescriptionLabel.text = nil
    }
    
    func prepareRepositoryData(_ value: GitHubUserRepository) {
        repositoryNameLabel.text = value.name
        if let language = value.language, !language.isEmpty {
            languageLabel.text = language
        } else {
            languageLabel.text = "-"
        }
        stargazersLabel.text = value.stargazers.decimalFormat
        repositoryDescriptionLabel.text = value.description
    }
}
