//
//  Breeds.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import Foundation

struct Breed: Identifiable {
    let id = UUID()
    let name: String
    var images: [String] = []
}
