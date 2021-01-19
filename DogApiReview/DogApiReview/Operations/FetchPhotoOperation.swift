//
//  FetchPhotoOperation.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/18/21.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    let photoReference: URL?
    private(set) var imageData: Data?
    let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(photoReference: URL, session: URLSession = URLSession.shared) {
        self.photoReference = photoReference
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let imageURL = photoReference else { return }
        
        let task = session.dataTask(with: imageURL) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
            }
            
            guard let data = data else { return }
            self.imageData = data
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
}
