//
//  ListItemView.swift
//  DogBreeds
//
//  Created by Diego Hernan Peñalba on 12/06/2023.
//

import SwiftUI

struct ListItemView: View {
    let imageURL: String
    let text: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView()
            }
            .padding()
            Text(text.capitalized)
                .font(.subheadline)
                .frame(maxWidth: .infinity, maxHeight:.infinity)
                .background(.cyan)
                .foregroundColor(.white)
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(.cyan)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray)
        )
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBreed = Breed(name: "Beagle", images: ["https://example.com/beagle.jpg"])
        return ListItemView(imageURL: sampleBreed.images.first ?? "", text: sampleBreed.name)
            .previewLayout(.fixed(width: 200, height: 200))
            .padding()
            .background(Color.gray)
    }
}
