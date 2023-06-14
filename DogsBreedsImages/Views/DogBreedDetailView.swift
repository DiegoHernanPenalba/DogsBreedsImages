//
//  DogBreedDetailView.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import SwiftUI

struct DogBreedDetailView: View {
    let breed: DogBreed
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(breed.images, id: \.self) { imageURL in
                    //TODO: why kingfisher elsewhere and not here?
                    //TODO: food for thought: what happens if you keep adding kingfisher references everywhere and later we switch to another system? problems? solutions? 
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .padding()
            }
        }
        .navigationTitle(breed.name.capitalized)
        .background(Color(.tertiarySystemBackground))
    }
}

struct BreedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DogBreedDetailView(breed: DogBreed(name: "Beagle"))
    }
}
