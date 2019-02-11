//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.nib` struct is generated, and contains static references to 7 nibs.
  struct nib {
    /// Nib `EmptyMessageView`.
    static let emptyMessageView = _R.nib._EmptyMessageView()
    /// Nib `LoadingView`.
    static let loadingView = _R.nib._LoadingView()
    /// Nib `LoginViewController`.
    static let loginViewController = _R.nib._LoginViewController()
    /// Nib `RepositoryTableViewCell`.
    static let repositoryTableViewCell = _R.nib._RepositoryTableViewCell()
    /// Nib `UserDetailViewController`.
    static let userDetailViewController = _R.nib._UserDetailViewController()
    /// Nib `UserTableViewCell`.
    static let userTableViewCell = _R.nib._UserTableViewCell()
    /// Nib `UsersViewController`.
    static let usersViewController = _R.nib._UsersViewController()
    
    /// `UINib(name: "EmptyMessageView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.emptyMessageView) instead")
    static func emptyMessageView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.emptyMessageView)
    }
    
    /// `UINib(name: "LoadingView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.loadingView) instead")
    static func loadingView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.loadingView)
    }
    
    /// `UINib(name: "LoginViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.loginViewController) instead")
    static func loginViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.loginViewController)
    }
    
    /// `UINib(name: "RepositoryTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.repositoryTableViewCell) instead")
    static func repositoryTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.repositoryTableViewCell)
    }
    
    /// `UINib(name: "UserDetailViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.userDetailViewController) instead")
    static func userDetailViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.userDetailViewController)
    }
    
    /// `UINib(name: "UserTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.userTableViewCell) instead")
    static func userTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.userTableViewCell)
    }
    
    /// `UINib(name: "UsersViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.usersViewController) instead")
    static func usersViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.usersViewController)
    }
    
    static func emptyMessageView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.emptyMessageView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    static func loadingView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.loadingView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    static func loginViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.loginViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    static func repositoryTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> RepositoryTableViewCell? {
      return R.nib.repositoryTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? RepositoryTableViewCell
    }
    
    static func userDetailViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.userDetailViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    static func userTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UserTableViewCell? {
      return R.nib.userTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UserTableViewCell
    }
    
    static func usersViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.usersViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 2 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `repositoryTableViewCell`.
    static let repositoryTableViewCell: Rswift.ReuseIdentifier<RepositoryTableViewCell> = Rswift.ReuseIdentifier(identifier: "repositoryTableViewCell")
    /// Reuse identifier `userTableViewCell`.
    static let userTableViewCell: Rswift.ReuseIdentifier<UserTableViewCell> = Rswift.ReuseIdentifier(identifier: "userTableViewCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    struct _EmptyMessageView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "EmptyMessageView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _LoadingView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "LoadingView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _LoginViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "LoginViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _RepositoryTableViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = RepositoryTableViewCell
      
      let bundle = R.hostingBundle
      let identifier = "repositoryTableViewCell"
      let name = "RepositoryTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> RepositoryTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? RepositoryTableViewCell
      }
      
      fileprivate init() {}
    }
    
    struct _UserDetailViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "UserDetailViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _UserTableViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = UserTableViewCell
      
      let bundle = R.hostingBundle
      let identifier = "userTableViewCell"
      let name = "UserTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UserTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UserTableViewCell
      }
      
      fileprivate init() {}
    }
    
    struct _UsersViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "UsersViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}