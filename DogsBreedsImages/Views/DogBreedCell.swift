//
//  DogBreedCell.swift
//  DogBreeds
//
//  Created by Diego Hernan Peñalba on 12/06/2023.
//

import Kingfisher
import SwiftUI

struct DogBreedCell: View {
    let imageURL: String?
    let text: String
    
    var body: some View {
        VStack {
            if let imageURL = imageURL {
                KFImage.url(URL(string: imageURL))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            }
            
            Text(text.capitalized)
                .font(.subheadline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemGray))
                .foregroundColor(.white)
        }
        .padding(.vertical)
        .background(Color(UIColor.systemGray))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.white))
        )
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBreed = DogBreed(name: "Beagle", images: ["https://example.com/beagle.jpg"])
        return DogBreedCell(imageURL: sampleBreed.images.first ?? "", text: sampleBreed.name)
            .previewLayout(.fixed(width: 200, height: 200))
            .padding()
            .background(Color.gray)
    }
}
