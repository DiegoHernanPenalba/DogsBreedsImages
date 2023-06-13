//
//  ContentView.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import SwiftUI

struct DogBreedsHomepage: View {
    @StateObject private var viewModel = BreedViewModel()
    
    var body: some View {
        NavigationView {
            DogBreedScrollableList(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DogBreedsHomepage()
    }
}
