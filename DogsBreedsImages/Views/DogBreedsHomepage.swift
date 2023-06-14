//
//  DogBreedsHomepage.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import SwiftUI

//TODO: homepage is a name from the web.
struct DogBreedsHomepage: View {
    @StateObject private var viewModel = DogBreedViewModel()
    
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
