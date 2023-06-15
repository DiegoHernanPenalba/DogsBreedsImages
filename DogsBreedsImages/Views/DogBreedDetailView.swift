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
                    //Response: I didnt though of it, because I didnt have any issue with the UI.
                    //TODO: food for thought: what happens if you keep adding kingfisher references everywhere and later we switch to another system? problems? solutions?
                    //Response: If we later switch to another system the code mantenance wolud be harder, so based on OPP principles a good solution would be to encapsulate the kingsfisher functionality
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
