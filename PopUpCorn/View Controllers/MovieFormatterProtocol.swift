//
//  MovieFormatterStrategy.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 02/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol MovieFormatterProtocol {
    func format(movie: Movie) -> ListableMovie
    func format(movie: Movie) -> DetailableMovie
}

extension MovieFormatterProtocol {

    func format(movie: Movie) -> ListableMovie {
        let listableMovie = ListableMovie.init(
            title: movie.title ?? MoviePlaceholder.title,
            release: dateFormatter().date(from: movie.releaseDate ?? ""),
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            genresIDs: movie.genreIDs
        )

        return listableMovie
    }

    func format(movie: Movie) -> DetailableMovie {
        let detailableMovie = DetailableMovie.init(
            title: movie.title,
            release: dateFormatter().date(from: movie.releaseDate ?? ""),
            image: movie.backdropPath ?? movie.posterPath,
            genres: movie.genreIDs,
            overview: movie.overview,
            id: "\(movie.id ?? -1)"
        )

        return detailableMovie
    }

    func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter
    }

    func toMovie(from detailableMobie: DetailableMovie)  -> Movie {
        let movie = Movie.init(
            id: Int(detailableMobie.id ?? "-1"),
            title: detailableMobie.title,
            posterPath: detailableMobie.image,
            backdropPath: detailableMobie.image,
            isAdult: nil,
            overview: detailableMobie.overview,
            releaseDate: dateFormatter().string(from: detailableMobie.release ?? Date()),
            genreIDs: detailableMobie.genres
        )

        return movie
    }

    func releaseString(fromDate release: Date?) -> String? {
        guard let releaseDate = release else {
            return nil
        }

        let today = Date()
        let calendar = Calendar.current

        if calendar.isDateInToday(releaseDate) {
            return "release is Today"
        } else if calendar.isDateInTomorrow(releaseDate) {
            return "release is Tomorrow"
        } else if calendar.isDateInYesterday(releaseDate) {
            return "release was Yesterday"
        } else if calendar.isDateInWeekend(releaseDate) {
            let dayInWeek = calendar.component(.weekday, from: releaseDate)
            let dayName = calendar.weekdaySymbols[dayInWeek - 1]
            if releaseDate > today {
                return "release is on \(dayName)"
            } else {
                return "release was on \(dayName)"
            }
        } else if releaseDate > today,
            let upperLimitDate = calendar.date(byAdding: .day, value: 60, to: today),
            releaseDate < upperLimitDate {
            if let daysOffset = calendar.dateComponents([.day], from: today, to: releaseDate).day {
                return "release is in \(daysOffset) days"
            }
        } else if releaseDate < today,
            let upperLimitDate = calendar.date(byAdding: .day, value: -60, to: today),
            releaseDate > upperLimitDate {
            if let daysOffset = calendar.dateComponents([.day], from: releaseDate, to: today).day {
                return "release was in \(daysOffset) days"
            }
        } else if let oneMounthDate = calendar.date(byAdding: .month, value: 2, to: today),
            let sixMounthDate = calendar.date(byAdding: .month, value: 6, to: today),
            releaseDate > oneMounthDate, releaseDate < sixMounthDate {
            if let mounthOffset = calendar.dateComponents([.month], from: today, to: releaseDate).month {
                return "release is in \(mounthOffset) mounths"
            }
        } else if let oneMounthPastDate = calendar.date(byAdding: .month, value: -2, to: today),
            let sixMounthPastDate = calendar.date(byAdding: .month, value: -6, to: today),
            releaseDate < oneMounthPastDate, releaseDate > sixMounthPastDate {
            if let mounthOffset = calendar.dateComponents([.month], from: releaseDate, to: today).month {
                return "release was in \(mounthOffset) mounths"
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        dateFormatter.dateStyle = .short

        return "release was on \(dateFormatter.string(from: releaseDate))"
    }
}
