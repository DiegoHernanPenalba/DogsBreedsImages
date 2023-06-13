//
//  BreedListView.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import SwiftUI

struct BreedListView: View {
    @StateObject var viewModel: BreedViewModel
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
                        NavigationLink(destination: BreedDetailView(breed: breed)) {
                            DogBreedCell(imageURL: breed.images.randomElement() ?? "", text: breed.name)
                        }
                    }
                }
                .padding()
                .background(.gray)
            }
        }
        .navigationBarTitle("Dog Breeds")
        .background(.gray)
        .onAppear {
            Task {
                await viewModel.fetchBreeds()
            }
        }
    }
}

struct BreedListView_Previews: PreviewProvider {
    static var previews: some View {
        BreedListView(viewModel: BreedViewModel())
    }
}
