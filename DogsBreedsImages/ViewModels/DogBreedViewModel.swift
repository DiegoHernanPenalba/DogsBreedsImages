import Foundation
import SwiftUI
import Combine

class DogBreedViewModel: ObservableObject {
    @Published var breeds: [DogBreed] = []
    @Published var errorMessage: String?
    
    // TODO: Is this a DogBreedError, or a DogBreedViewModel.Error? You can embed it in the VM too
    enum DogBreedViewModelError: Error {
        case breedFetchFailed
        case imageFetchFailed
    }
    
    func fetchBreeds() async {
        do {
            let breeds = try await DogBreedsAPI.shared.fetchBreeds()
            // TODO: Why this dispatch?
            // Response: Because the UI update happens on the main thread.
            DispatchQueue.main.async {
                self.breeds = breeds.map { DogBreed(name: $0) }
                // TODO: Why this task?
                // Response: Because we want to fetch the breed images on a background thread.
                Task {
                    [weak self] in
                    guard let self = self else { return }
                    
                    do {
                        try await self.fetchImages()
                    } catch {
                        self.breedDataFetchingError(error, breed: nil)
                    }
                }
            }
        } catch {
            self.breedDataFetchingError(error, breed: nil)
        }
    }
    
    //TODO: what happens if the first getRandomImage takes a loooooot of time?
    //Respopnse: It will freeze the UI. I will search for a better practice. (chatGptSolution)
    private func fetchImages() async throws {
        try await withThrowingTaskGroup(of: (DogBreed, String).self) { [weak self] group in
            guard let self = self else { return }
            
            for index in self.breeds.indices {
                let breed = self.breeds[index]
                group.addTask {
                    let imageURL = try await DogBreedsAPI.shared.getRandomImageURL(for: breed.name)
                    return (breed, imageURL)
                }
            }
            
            for try await (breed, imageURL) in group {
                DispatchQueue.main.async {
                    //TODO: why didn't you use weak self?
                    //Because I use dispatch the main queue. But I could ensure to not hold the reference by using it.
                    [weak self] in
                    guard let self = self else { return }
                    //This guard let statement Is used because you once told me it was a good practice.
                        
                        if let breedIndex = self.breeds.firstIndex(where: { $0.id == breed.id }) {
                            self.breeds[breedIndex].images.append(imageURL)
                        } else {
                            self.breedDataFetchingError(DogBreedViewModelError.breedFetchFailed, breed: breed)
                        }
                    }
                }
            }
        }
        
        // TODO: fetchError? Fetch from where? Is this name correct?
        // RESPONSE: I also thought about naming it dataFetchError or apiFetchError.
        private func breedDataFetchingError(_ error: Error, breed: DogBreed?) {
            if let breed = breed {
                switch error {
                case DogBreedViewModelError.imageFetchFailed:
                    errorMessage = "Error fetching image for breed \(breed.name)"
                default:
                    errorMessage = "An unknown error occurred fetching images"
                }
            } else {
                switch error {
                case DogBreedViewModelError.breedFetchFailed:
                    errorMessage = "Error fetching breeds"
                default:
                    errorMessage = "An unknown error occurred fetching breeds"
                }
            }
        }
    }
