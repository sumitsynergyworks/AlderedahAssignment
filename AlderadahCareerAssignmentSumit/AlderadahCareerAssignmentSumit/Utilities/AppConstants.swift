//
//  AppConstants.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import Foundation
import UIKit

public let ASUserDefauls = UserDefaults.standard
public let ASNotificationCenter = NotificationCenter.default
public let ASSharedApplication = UIApplication.shared
public let ASMainBundle = Bundle.main
public let ASFileManager = FileManager.default
public let screenSize = UIScreen.main.bounds.size
public let AppBundleIdentifier = ASMainBundle.bundleIdentifier!
let ASDBManager = DBManager.manager
let ASSharedAppDelegate = ASSharedApplication.delegate as? AppDelegate
let ASSharedClass = ASShared.shared

public class ASAppConstants {
    public static let defaultCornerRadiusView: Float = 6.0
}

public class ASSegueIdentifiers {
    
}

public class StoryboardControllerIds {
    static public func appStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: StringConstants.MAIN_STORYBOARD_NAME, bundle: ASMainBundle)
    }
    
    public static let UserTabbarController = "UserTabbarController"
    public static let AdminTabbarController = "AdminTabBarController"
}

public class NotificationNames {
    static let USER_LOGGEDIN_NOTIFICATION = Notification.Name("USER_LOGGEDIN_NOTIFICATION")
    static let USER_LOGGEDOUT_NOTIFICATION = Notification.Name("USER_LOGGEDOUT_NOTIFICATION")
}

