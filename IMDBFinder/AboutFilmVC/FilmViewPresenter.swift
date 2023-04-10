//
//  AboutFilmPresenter.swift
//  IMDBFinder
//
//  Created by Матвей Матюшко on 09.03.2023.
//

import Foundation
import UIKit

protocol FilmViewPresenterInput {
    init(film: AboutFilm?)
    func setView(view: FilmViewPresenterOutput)
    var title: String {get}
    var description: String {get}
    var image: String { get }
}

protocol FilmViewPresenterOutput {
    func configure()
}

class FilmViewPresenter: FilmViewPresenterInput {
    required init(film: AboutFilm?) {
        self.film = film
    }
    var service = Service()
    var view: FilmViewPresenterOutput? = nil
    var film: AboutFilm?
    func setView(view: FilmViewPresenterOutput) {
        self.view = view
        self.view?.configure()
    }
    var title: String {
        guard let film = film else {
            return "error"
        }
        return film.title
    }
    var description: String {
        guard let film = film else {
            return "error"
        }
        return film.description
    }
    var image: String {
        guard let film = film else {
            return "error"
        }
        return film.image
    }
}
