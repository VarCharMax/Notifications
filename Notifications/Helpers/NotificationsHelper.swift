//
//  NotificationsHelper.swift
//  Notifications
//
//  Created by Rohan Parkes on 18/7/19.
//  Copyright © 2019 Rohan Parkes. All rights reserved.
//

import UIKit
import UserNotifications

struct NotificationsHelper {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationPermissions(_ completion: @escaping (Bool) -> ()) {
        notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { permissionGranted, error in
            completion(permissionGranted)
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func userHasDisabledNotifications(_ completion: @escaping (Bool) -> ()) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus == .denied)
        }
    }
    
    func createNotificationContentForReminder(_ reminder: Reminder) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        
        content.title = "Reminder"
        content.body = reminder.title ?? ""
        content.badge = 1
        content.userInfo = ["reminder-uuid": reminder.identifier?.uuidString]
        content.categoryIdentifier = "reminder"
        
        return content
    }
    
    func scheduleTimedNotificationWithContent(_ content: UNNotificationContent) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleHourlyWaterReminder() {
        
        let content = UNMutableNotificationContent()
        
        content.title = "Reminder"
        content.body = "This is your reminder to drink some water every hour"
        
        var hourComponents = DateComponents()
        hourComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: hourComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "water-notification", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func unscheduleHourWaterReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["water-notification"])
    }
}
