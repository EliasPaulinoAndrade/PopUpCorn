//
//  MovieReminderController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UserNotifications
import EventKit

class MovieReminderController: MovieFormatterProtocol {
    weak public var delegate: MovieReminderControllerDelegate? {
        didSet {
            delegate?.reloadReminderButton()
        }
    }
    var movieDAO = MovieCoreDataDAO()

    func needRemindMovie(_ movie: DetailableMovie) {
        let realMovie = toMovie(from: movie)

        guard realMovie.id != nil && realMovie.releaseDate != nil else {
            return
        }

        guard !movieHasReminder(movie) else {
            if !movieDAO.delete(element: realMovie) {
                delegate?.needShowError(message: "A Error Happend While Deleting the Reminder.")
            } else {
                removeNotification(forMovie: movie)
            }

            delegate?.reloadReminderButton()
            delegate?.needRemoveMovie(movie: movie)
            return
        }

        if movieDAO.save(element: realMovie) == nil {
            delegate?.needShowError(message: "A Error Happend While Saving the Reminder.")
        } else {
            setNotification(forMovie: movie)
            setCalendarReminder(forMovie: movie)
        }
        delegate?.reloadReminderButton()
    }

    private func removeNotification(forMovie movie: DetailableMovie) {
        guard let movieID = movie.id else {
            return
        }
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [String(movieID)])
    }

    private func setCalendarReminder(forMovie movie: DetailableMovie) {
        let eventStore = EKEventStore()

        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .authorized:
            addReminderToCalendar(store: eventStore, andMovie: movie)
        case .notDetermined:
            eventStore.requestAccess(to: .reminder) { [weak self] (acessPermitted, error) in
                guard error == nil, acessPermitted else {
                    return
                }
                self?.addReminderToCalendar(store: eventStore, andMovie: movie)
            }
        default:
            break
        }
    }

    private func addReminderToCalendar(store: EKEventStore, andMovie movie: DetailableMovie) {
        let defaultCalendar = store.defaultCalendarForNewReminders() ?? store.calendars(for: .reminder).first
        let calendarFormatter = Calendar.current

        guard let calendar = defaultCalendar,
              let movieReleaseDate = movie.release,
              let startDate = calendarFormatter.date(byAdding: .day, value: -1, to: movieReleaseDate),
              let endDate = calendarFormatter.date(byAdding: .day, value: 1, to: movieReleaseDate) else {
            return
        }

        let reminder = EKReminder(eventStore: store)
        reminder.calendar = calendar
        reminder.title = "\(movie.title ?? "movie") Release"
        reminder.isCompleted = false

        let startDateComponents = calendarFormatter.dateComponents([.minute, .hour, .day, .month, .year], from: startDate)
        reminder.startDateComponents = startDateComponents
        reminder.completionDate = endDate

        do {
            try store.save(reminder, commit: true)
        } catch {
            print(error)
        }
    }

    private func setNotification(forMovie movie: DetailableMovie) {
        guard let movieDate = movie.release, let movieID = movie.id else {
            return
        }

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (userAccepeted, error) in
            guard error == nil, userAccepeted else {
                return
            }

            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "\(movie.title ?? "no title") release is today"
            notificationContent.body = movie.overview ?? "no overview"
            notificationContent.sound = UNNotificationSound.default
            notificationContent.badge = 1

            let notificationTrigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents(
                    [.year, .month, .day, .minute, .second, .hour],
                    from: movieDate
                ), repeats: false
            )

            let notificationRequest = UNNotificationRequest(
                identifier: String(movieID),
                content: notificationContent,
                trigger: notificationTrigger
            )

            notificationCenter.add(notificationRequest, withCompletionHandler: { [weak self] (error) in
                if error != nil {
                    self?.delegate?.needShowError(message: "A Error Happend While Setting the Notification")
                }
            })
        }
    }

    func mustShowReminderButton(forMovie movie: DetailableMovie) -> Bool {
        guard let movieRelease = movie.release else {
            return false
        }

        return movieRelease > Date()
    }

    private func releaseToDate(_ release: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: release) else {
            return nil
        }

        return date
    }

    func controllerWillAppear() {
        delegate?.reloadReminderButton()
    }

    func movieHasReminder(_ movie: DetailableMovie) -> Bool {
        guard let movieID = movie.id, movieDAO.get(elementWithID: movieID) != nil else {
            return false
        }

        return true
    }
}
