//
//  Service.swift
//  IMDBFinder
//
//  Created by Матвей Матюшко on 03.03.2023.
//

import Foundation
import UIKit

protocol ServiceProtocol {
    func getDataURL(title: String, completion: @escaping ([[String: String]]?, Error?) -> Void)
    func loadImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void)
}

class Service: ServiceProtocol {
    func getDataURL(title: String, completion: @escaping ([[String: String]]?, Error?) -> Void) {
            let titleWithoutSpaces = title.replacingOccurrences(of: " ", with: "%20")
            let notValidUrl = "https://imdb-api.com/API/Search/k_qzrg3gpg/"
            let validUrl = notValidUrl + titleWithoutSpaces
            let url = URL(string: validUrl)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let someDictionaryJSON = try? JSONSerialization.jsonObject(with: data,
                                                                options: .allowFragments) as? [String: Any]
                let arrayOfFilms = someDictionaryJSON?["results"] as? [[String: String]]
                completion(arrayOfFilms, error)
            }
            task.resume()
        }
    func loadImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let url = URL(string: urlString) ?? URL(string: "https://via.placeholder.com/150")
        let task = URLSession.shared.dataTask(with: url!) { (data, _, error) in
            guard let data = data else {
                let image = UIImage()
                completion(image, error)
                return
            }
            let image = UIImage(data: data, scale: 1)
            completion(image, error)
        }
        task.resume()
    }
}
