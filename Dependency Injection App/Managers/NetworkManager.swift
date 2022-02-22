//
//  NetworkManager.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/18/22.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "zgy45FWXJz5Oyf5aBhPXC3tmO2qDMi53"
    let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    
    func fetchTrendingData(rating: String, Completed: @escaping(Result<Response, DIError>) -> Void) {
        let endpoint = "https://api.giphy.com/v1/gifs/trending?" + "api_key=\(apiKey)&limit=25" + "&rating=\(rating)"
        guard let url = URL(string: endpoint) else {
            Completed(.failure(.invalidData))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                Completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                Completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                Completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let trendingResponse = try decoder.decode(Response.self, from: data)
                Completed(.success(trendingResponse))
            } catch {
                Completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func fetchSearchData(query: String, Completed: @escaping(Result<Response, DIError>) -> Void) {
        let endpoint = "https://api.giphy.com/v1/gifs/search?" + "api_key=\(apiKey)" + "&q=\(query)" + "&limit=25&offset=0&rating=pg&lang=en"
        guard let url = URL(string: endpoint) else {
            Completed(.failure(.unableToComplete))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                Completed(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                Completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                Completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let searchResponse = try decoder.decode(Response.self, from: data)
                Completed(.success(searchResponse))
            } catch {
                Completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func fetchDataByID(ID: String, completed: @escaping(Result<ResponseResult,DIError>) -> Void) {
        let endpoint = "https://api.giphy.com/v1/gifs/" + "\(ID)?" + "api_key=\(apiKey)"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataByID = try decoder.decode(ResponseResult.self, from: data)
                completed(.success(dataByID))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                      completed(nil)
                      return
                  }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
