//
//  TablePresenter.swift
//  IMDBFinder
//
//  Created by Матвей Матюшко on 09.02.2023.
//

import Foundation
import UIKit

protocol TablePresenterInput {
    var films: [AboutFilm]? {get set}
    var searchString: String? {get set}
    func setView(view: TablePresenterOutput?)
    var numberOfRowsInSection: Int {get }
    func getFilms()
}

protocol TablePresenterOutput {
    func succes()
    func failure()
}

class TablePresenter: TablePresenterInput {
    var view: TablePresenterOutput? = nil
    var searchString: String? = ""
    var service: ServiceProtocol! = Service()
    var films: [AboutFilm]? = []
    var numberOfRowsInSection: Int {
        return films?.count ?? 0
    }
    func setView(view: TablePresenterOutput?) {
        self.view = view
    }
    func getFilms() {
        service.getDataURL(title: searchString!) {[weak self] array, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let array = array else {
                    self.view?.failure()
                    return
                }
                for item in 0..<array.count {
                    self.films?.append(AboutFilm(title: array[item]["title"]!,
                                                 description: array[item]["description"]!,
                                                 image: array[item]["image"]!))
                }
                self.view?.succes()
            }
        }
    }
}
