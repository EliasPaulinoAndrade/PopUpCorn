//
//  MovieReminderControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol MovieReminderControllerDelegate: AnyObject {
    func needShowError(message: String)
    func reloadReminderButton()
    func needRemoveMovie(movie: DetailableMovie)
    func reminderWasAdded(inReminders: Bool)
}
