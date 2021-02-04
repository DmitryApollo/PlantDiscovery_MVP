//
//  NetworkService.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

//token=iBdjP-t31yR2ddgA2eq8QKaeHS71zdiqF8nwg6PTjq8

protocol NetworkServiceProtocol {
    func getPlants(page: Int, completion: @escaping (Result<PlantsListResponse?, Error>) -> Void)
    func searchPlant(plantName: String, page: Int, completion: @escaping (Result<PlantsListResponse?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getPlants(page: Int, completion: @escaping (Result<PlantsListResponse?, Error>) -> Void) {
        var comp = getComponents()
        comp.path = "/api/v1/plants"
        comp.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = comp.url else {
            let error = NSError(domain: "URL is not valid", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        let request = makeRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode(PlantsListResponse.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchPlant(plantName: String, page: Int, completion: @escaping (Result<PlantsListResponse?, Error>) -> Void) {
        let correctString = plantName.replacingOccurrences(of: " ", with: "+")

        var comp = getComponents()
        comp.path = "/api/v1/plants/search"
        comp.queryItems = [
            URLQueryItem(name: "q", value: correctString),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = comp.url else {
            let error = NSError(domain: "URL is not valid", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        let request = makeRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode(PlantsListResponse.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getComponents() -> URLComponents {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "trefle.io"
        return comp
    }
    
    private func makeRequest(url: URL) -> URLRequest {
        let accessKey = "iBdjP-t31yR2ddgA2eq8QKaeHS71zdiqF8nwg6PTjq8"
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}

