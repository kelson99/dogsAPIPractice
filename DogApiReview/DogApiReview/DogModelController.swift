//
//  DogModelController.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/18/21.
//

import Foundation

class DogModelController {
    
    func fetchDogImagesForSpecies(named species: String, using session: URLSession = URLSession.shared, completion: @escaping (DogImages?, Error?) -> Void) {
        let url = self.url(forDogBreedImages: species)
        fetch(from: url) { (arr: DogImages?, error: Error?) in
            completion(arr, nil)
        }
    }
    
    
    private func fetch<T: Codable>(from url: URL,
                                   using session: URLSession = URLSession.shared,
                                   completion: @escaping (T?, Error?) -> Void) { session.dataTask(with: url) { (data, response, error) in
                                    
                                    if let error = error {
                                        completion(nil, error)
                                        return
                                    }
                                    
                                    guard let data = data else {
                                        completion(nil, NSError(domain: "com.KelsonHartle.DogApiReview.ErrorDomain", code: -1, userInfo: nil))
                                        return
                                    }
                                    
                                    do {
                                        let jsonDecoder = JSONDecoder()
                                        let decodedObject = try jsonDecoder.decode(T.self, from: data)
                                        completion(decodedObject, nil)
                                    } catch {
                                        completion(nil, error)
                                    }
                                    
                                   }.resume()
    
    
    }
    
    
    private let baseURL = URL(string:"https://dog.ceo/api")!
    
    private func fetchAllDogBreedsNames() -> URL {
        var url = baseURL
        url.appendPathComponent("breeds/list/all")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        return urlComponents.url!
    }
    
    private func url(forRandomDogImages numberOfImages: Int) -> URL {
        var url = baseURL
        url.appendPathComponent("breeds/image/random/\(numberOfImages)")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        return urlComponents.url!
    }
    
    private func url(forDogBreedImages dogBreed: String) -> URL {
        var url = baseURL
        url.appendPathComponent("breed/\(dogBreed)/images")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        return urlComponents.url!
    }
}
