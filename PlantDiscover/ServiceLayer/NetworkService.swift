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
        let urlString = "https://trefle.io/api/v1/plants?token=iBdjP-t31yR2ddgA2eq8QKaeHS71zdiqF8nwg6PTjq8&page=\(page)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "URL is not valid", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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

        let urlString = "https://trefle.io/api/v1/plants/search?token=iBdjP-t31yR2ddgA2eq8QKaeHS71zdiqF8nwg6PTjq8&q=\(correctString)&page=\(page)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "No support this title", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
}

