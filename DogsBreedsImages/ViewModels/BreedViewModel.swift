import Foundation
import SwiftUI
import Combine
import Alamofire

class BreedViewModel: ObservableObject {
    @Published var breeds: [Breed] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchBreeds() async {
        Task {
            do {
                let breeds = try await DogAPI.shared.fetchBreeds()
                DispatchQueue.main.async {
                    self.breeds = breeds.map { Breed(name: $0) }
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
                        self.breeds[index].images.append(imageURL)
                    }
                } catch {
                    print("Error fetching image for breed \(breed.name): \(error)")
                }
            }
        }
    }
}
