//
//  NetworkManager.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation

//"https://gist.githubusercontent.com/sanjeevkumargautam-nykaa/a2ab56f3a0973bd415a41b10906a0683/raw/15136211cf4e810abaa19dc0ec77641cd518cc26/products.json"

//    https://www.omdbapi.com/?apikey=5932c39c&s=Avenger&page=1

//  "https://www.jsonkeeper.com/b/9LXA"

class NetworkManager {
    
    func fetchData<T: Codable>(urlStr: String, completion: @escaping (Result<T,Error>) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

class ApiHelper {
    static let shared = ApiHelper()
    let apikey = "5932c39c"
}
