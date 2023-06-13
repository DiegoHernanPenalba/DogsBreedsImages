import Foundation
import SwiftUI
import Combine
import Alamofire

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
            DispatchQueue.main.async {
                self.breeds = breeds.map { DogBreed(name: $0) }
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
            let imageURL = try await DogBreedsAPI.shared.getRandomImageURL(for: breed.name)
            DispatchQueue.main.async {
                if let breedIndex = self.breeds.firstIndex(where: { $0.id == breed.id }) {
                    self.breeds[breedIndex].images.append(imageURL)
                } else {
                    self.fetchError(DogBreedError.breedFetchFailed, breed: breed)
                }
            }
        }
    }
    
    private func fetchError(_ error: Error, breed: DogBreed?) {
        if let breed = breed {
            switch error {
            case DogBreedError.imageFetchFailed:
                errorMessage = "Error fetching image for breed \(breed.name)"
            default:
                errorMessage = "An unknown error occurred"
            }
        } else {
            switch error {
            case DogBreedError.breedFetchFailed:
                errorMessage = "Error fetching breeds"
            default:
                errorMessage = "An unknown error occurred"
            }
        }
    }
}
