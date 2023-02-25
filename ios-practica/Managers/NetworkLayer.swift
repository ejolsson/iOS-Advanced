//
//  NetworkLayer.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/28/22.
//  Used for API connection

import Foundation

enum NetworkError: Error {
    case malformedURL
    case noData
    case statusCode(code: Int?)
    case decodingFailed
    case unknown
} // complete

final class NetworkLayer {
    
    static let shared = NetworkLayer()
    
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
     
        let loginString = "\(email):\(password)"
        let loginData: Data = loginString.data(using: .utf8)!
        let base64 = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else { // if nil, continue
                completion(nil, error) // if != nil, stop, generate error
                return // exit function
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completion(nil, NetworkError.statusCode(code: statusCode))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(token, nil) // L10 3:27:30
        }
        
        task.resume()
    } // Oscar style
    
    func fetchHeros(token: String?, completion: @escaping ([Hero]?, Error?) -> Void) {
        
        // local function definitions
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard let heros = try? JSONDecoder().decode([Hero].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(heros, nil)
        }
        
        task.resume()
    } // Oscar style, Used in: HerosListVC, Purpose: api call, grab hero data
  
    func fetchTransformations(token: String?, heroId: String?, completion: @escaping ([Transformation]?, Error?) -> Void) {
                
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: heroId ?? "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            } // complete
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completion(nil, NetworkError.statusCode(code: statusCode))
                print("Error loading URL: Status error --> ", (response as? HTTPURLResponse)?.statusCode ?? -1)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard let transformations = try? JSONDecoder().decode([Transformation].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(transformations, nil)
        }
        
        task.resume()
    } // Used in: DetailsVC, Purpose: api call, grab data, Oscar style
    
    func fetchLocations (token: String?, heroId: String?, completion: @escaping ([Place]?, Error?) -> Void) {
        
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/locations") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: heroId ?? "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completion(nil, NetworkError.statusCode(code: statusCode))
                print("Error loading URL: Status error --> ", (response as? HTTPURLResponse)?.statusCode ?? -1)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
                       
            guard let places = try? JSONDecoder().decode([Place].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(places, nil)
        }
        
        task.resume()
    } // My style, Oscar-based.
    
    func getHeroes(token: String?, completion: @escaping ([Hero], Error?) -> Void) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all") else {
            completion([], NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion([], NetworkError.unknown)
                return
            }
            
            guard let data = data else {
                completion([], NetworkError.noData)
                return
            }
            
            guard let response = try? JSONDecoder().decode([Hero].self, from: data) else {
                completion([], NetworkError.decodingFailed)
                return
            }
            completion(response, nil)
        }
        
        task.resume()
    } // fm Wait proj
    
    func getLocalization(token: String?, with id: String, completion: @escaping ([Place], Error?) -> Void) { // "token: String?" was used before
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/locations") else {
            completion([], NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: id)]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            guard error == nil else {
                completion([], NetworkError.unknown)
                return
            }
            
            guard let data = data else {
                completion([], NetworkError.noData)
                return
            }
            
            guard let response = try? JSONDecoder().decode([Place].self, from: data) else {
                completion([], NetworkError.decodingFailed)
                return
            }
            
            completion(response, nil)
        }
        
        task.resume()
    } // import this into project
}

//struct Place {
//    let name: String
//    let latitude: Double
//    let longitude: Double
//    let image: String
//}
