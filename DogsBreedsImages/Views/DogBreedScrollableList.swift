//
//  DogBreedScrollableList.swift
//  DogsBreedsImages
//
//  Created by Diego Hernan Peñalba on 05/06/2023.
//

import SwiftUI

struct DogBreedScrollableList: View {
    
    @Environment(\.colorScheme) var colorScheme
    
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
                                //TODO: happens if you send "" ?
                                //Response: Nothing will be shown, it will remain the placeholder on the DogBreedCell.
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
        //TODO: Did you implement localization?
        //Response: No, because I didnt thought of that. The content of the data is mostly proper nouns.
        .navigationBarTitle("Dog Breeds")
        .background(colorScheme == .dark ? Color.black : Color.cyan)
        //By replacing the .onAppear modifier with .task, you are ensuring that the viewModel.fetchBreeds() function is called as a task when the view is created or reappeared. This allows the asynchronous fetch operation to be executed in a structured and controlled manner.
        .task {
            await viewModel.fetchBreeds()
        }
    }
}

struct BreedListView_Previews: PreviewProvider {
    static var previews: some View {
        DogBreedScrollableList(viewModel: DogBreedViewModel())
    }
}
