//
//  DogApi.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

struct DogAPI {
    static let shared = DogAPI()
    
    private let baseURL = "https://dog.ceo/api"
    
    private init() {}
    
    func fetchBreeds() async throws -> [String] {
        let url = URL(string: "\(baseURL)/breeds/list/all")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(BreedsResponse.self, from: data)
        return Array(response.message.keys)
    }
    
    func getRandomImageURL(for breed: String) async throws -> String {
        let url = URL(string: "\(baseURL)/breed/\(breed)/images/random")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RandomImageResponse.self, from: data)
        return response.message
    }
}

struct BreedsResponse: Codable {
    let message: [String: [String]]
}

struct RandomImageResponse: Codable {
    let message: String
}
