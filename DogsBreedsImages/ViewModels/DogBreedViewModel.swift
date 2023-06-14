import Foundation
import SwiftUI
import Combine
//TODO: is this a DogBreedError, or a DogBreedViewModel.Error? you can embed it in the VM too
enum DogBreedError: Error {
    case breedFetchFailed
    case imageFetchFailed
}

class DogBreedViewModel: ObservableObject {
    @Published var breeds: [DogBreed] = []
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchBreeds() async {
        do {
            let breeds = try await DogBreedsAPI.shared.fetchBreeds()
            //TODO: why this dispatch?
            DispatchQueue.main.async {
                self.breeds = breeds.map { DogBreed(name: $0) }
                //TODO: why this task?
                Task {
                    do {
                        try await self.fetchImages()
                    } catch {
                        self.fetchError(error, breed: nil)
                    }
                }
            }
        } catch {
            self.fetchError(error, breed: nil)
        }
    }
    
    private func fetchImages() async throws {
        for index in breeds.indices {
            let breed = breeds[index]
            //TODO: what happens if the first getRandomImage takes a loooooot of time?
            let imageURL = try await DogBreedsAPI.shared.getRandomImageURL(for: breed.name)
            DispatchQueue.main.async {
                //TODO: why didn't you use weak self?
                if let breedIndex = self.breeds.firstIndex(where: { $0.id == breed.id }) {
                    self.breeds[breedIndex].images.append(imageURL)
                } else {
                    self.fetchError(DogBreedError.breedFetchFailed, breed: breed)
                }
            }
        }
    }

    //TODO: fetchError? fetch from where? is this name correct?
    private func fetchError(_ error: Error, breed: DogBreed?) {
        if let breed = breed {
            switch error {
            case DogBreedError.imageFetchFailed:
                errorMessage = "Error fetching image for breed \(breed.name)"
            default:
                errorMessage = "An unknown error occurred fetching images"
            }
        } else {
            switch error {
            case DogBreedError.breedFetchFailed:
                errorMessage = "Error fetching breeds"
            default:
                errorMessage = "An unknown error occurred fetching breeds"
            }
        }
    }
}
