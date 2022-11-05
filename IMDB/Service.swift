//
//  Service.swift
//  IMDB
//
//  Created by Матвей Матюшко on 05.11.2022.
//

import Foundation
import UIKit

struct Service {
    
    
    func getDataURL(title: String, completion: @escaping ([[String:String]]?, Error?) -> Void){
        let titleWithoutSpaces = title.replacingOccurrences(of: " ", with: "%20")
        let notValidUrl = "https://imdb-api.com/API/Search/k_qzrg3gpg/"
        let validUrl = notValidUrl + titleWithoutSpaces
        let url = URL(string: validUrl)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let someDictionaryFromJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let arrayOfFilms = someDictionaryFromJSON?["results"] as? [[String:String]]
            completion(arrayOfFilms , error)
            
        }
        task.resume()
    }
    
        
}
