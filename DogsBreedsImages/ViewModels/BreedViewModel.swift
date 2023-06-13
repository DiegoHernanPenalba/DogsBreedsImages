import Foundation
import SwiftUI
import Combine
import Alamofire

class BreedViewModel: ObservableObject {
    @Published var breeds: [DogBreed] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchBreeds() async {
        Task {
            do {
                let breeds = try await DogAPI.shared.fetchBreeds()
                DispatchQueue.main.async {
                    self.breeds = breeds.map { DogBreed(name: $0) }
                    Task {
                        await self.fetchImages()
                    }
                }
            } catch {
                print("Error fetching breeds: \(error)")
            }
        }
    }
    
    private func fetchImages() {
        for index in breeds.indices {
            let breed = breeds[index]
            Task {
                do {
                    let imageURL = try await DogAPI.shared.getRandomImageURL(for: breed.name)
                    DispatchQueue.main.async {
                        if let breedIndex = self.breeds.firstIndex(where: { $0.id == breed.id }) {
                            self.breeds[breedIndex].images.append(imageURL)
                        } else {
                            // Handle the case where the breed no longer exists in the breeds array
                            print("Breed no longer exists: \(breed.name)")
                        }
                    }
                } catch {
                    print("Error fetching image for breed \(breed.name): \(error)")
                }
            }
        }
    }
}
