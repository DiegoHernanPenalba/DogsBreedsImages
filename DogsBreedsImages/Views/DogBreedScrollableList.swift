//
//  BreedListView.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import SwiftUI

struct DogBreedScrollableList: View {
    @ObservedObject var viewModel: DogBreedViewModel
    @State private var searchText = ""
    
    let twoColumnsGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var sortedBreeds: [DogBreed] {
        return viewModel.breeds.sorted { $0.name < $1.name }
    }
    
    var filteredBreeds: [DogBreed] {
        if searchText.isEmpty {
            return sortedBreeds
        } else {
            return sortedBreeds.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                SearchBar(searchText: $searchText)
                    .padding(.top, 10)
                
                LazyVGrid(columns: twoColumnsGrid, spacing: 10) {
                    ForEach(filteredBreeds) { breed in
                        NavigationLink(destination: DogBreedDetailView(breed: breed)) {
                            if let imageURL = breed.images.randomElement() {
                                DogBreedCell(imageURL: imageURL, text: breed.name)
                            } else {
                                DogBreedCell(imageURL: "", text: breed.name)
                            }
                        }
                    }
                }
                .padding()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
                }
            }
        }
        .navigationBarTitle("Dog Breeds")
        .background(Color(UIColor.systemBackground))
        .onAppear {
            Task {
                await viewModel.fetchBreeds()
            }
        }
    }
}
struct BreedListView_Previews: PreviewProvider {
    static var previews: some View {
        DogBreedScrollableList(viewModel: DogBreedViewModel())
    }
}
