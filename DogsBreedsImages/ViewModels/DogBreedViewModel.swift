import Foundation
import SwiftUI
import Combine



class DogBreedViewModel: ObservableObject {
    @Published var breeds: [DogBreed] = []
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    //TODO: is this a DogBreedError, or a DogBreedViewModel.Error? you can embed it in the VM too
    enum DogBreedViewModelError: Error {
        case breedFetchFailed
        case imageFetchFailed
    }
    
    func fetchBreeds() async {
        do {
            let breeds = try await DogBreedsAPI.shared.fetchBreeds()
            //TODO: why this dispatch?
            //Response: Because the UI update happen on the main thread.
            DispatchQueue.main.async {
                self.breeds = breeds.map { DogBreed(name: $0) }
                //TODO: why this task?
                //Response: because I wanted to fetch the breed on the back thread
                Task {
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
    
    private func fetchImages() async throws {
        for index in breeds.indices {
            let breed = breeds[index]
            //TODO: what happens if the first getRandomImage takes a loooooot of time?
            let imageURL = try await DogBreedsAPI.shared.getRandomImageURL(for: breed.name)
            DispatchQueue.main.async { [weak self] in
                //This guard let statement Is used because you once told me it was a good practice.
                guard let self = self else {
                    return
                }
                //TODO: why didn't you use weak self?
                //Because I use dispatch the main queue. But I could ensure to not hold the reference by using it.
                if let breedIndex = self.breeds.firstIndex(where: { $0.id == breed.id }) {
                    self.breeds[breedIndex].images.append(imageURL)
                } else {
                    self.breedDataFetchingError(DogBreedViewModelError.breedFetchFailed, breed: breed)
                }
            }
        }
    }
    
    //TODO: fetchError? fetch from where? is this name correct?
    //RESPONSE: I also though about naming it dataFetchError or apiFetchError.
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
