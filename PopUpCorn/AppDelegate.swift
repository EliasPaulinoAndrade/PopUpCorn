//
//  AppDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator = AppCoordinator()

    var openedByNotification: Bool = false
    var wasLaunched: Bool = false

    var notificationIdentifier: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow.init(frame: UIScreen.main.bounds)

        appCoordinator.start()

        wasLaunched = true
        if openedByNotification {
            appCoordinator.configureNavigationDueNotification(
                withNotificationIdentifier: notificationIdentifier
            )
        }

        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler( [.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.notificationIdentifier = response.notification.request.identifier
        if wasLaunched && !openedByNotification {
            appCoordinator.configureNavigationDueNotification(
                withNotificationIdentifier: notificationIdentifier
            )
        }
        self.openedByNotification = true
//        _ = MovieCoreDataDAO().delete(elementWithID: response.notification.request.identifier)
        completionHandler()
    }
}
