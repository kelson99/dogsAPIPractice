//
//  ViewController.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/18/21.
//

import UIKit

class DogsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var images = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var photoFetchQueue = OperationQueue()
    let controller = DogModelController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.fetchRandomDogImages(numberOf: 10) { (images, error) in
            if let error = error {
                NSLog("Error fetching photos for random: \(error)")
        }
            if let images = images {
                self.images = images.message
            }
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }

    
    // MARK: - UICollection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? DogReusableCollectionViewCell ?? DogReusableCollectionViewCell()
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.item)
    }
    
    // Make collection view cells fill as much available width as possible
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        var totalUsableWidth = collectionView.frame.width
        let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        totalUsableWidth -= inset.left + inset.right
        
        let minWidth: CGFloat = 150.0
        let numberOfItemsInOneRow = Int(totalUsableWidth / minWidth)
        totalUsableWidth -= CGFloat(numberOfItemsInOneRow - 1) * flowLayout.minimumInteritemSpacing
        let width = totalUsableWidth / CGFloat(numberOfItemsInOneRow)
        return CGSize(width: width, height: width)
    }
    
    // Add margins to the left and right side
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
    }
    
    // Implement cancellation
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoReference = images[indexPath.item]
        //operations[photoReference.id]?.cancel()
    }
    
    
    
    func loadImage(forCell cell: DogReusableCollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoReference = images[indexPath.row]
        
        let fetchOp = FetchPhotoOperation(photoReference: URL(string: photoReference)!)
        
        
        let completionOP = BlockOperation {
            if let data = fetchOp.imageData {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
        
        photoFetchQueue.addOperation(fetchOp)
        completionOP.addDependency(fetchOp)
        
        OperationQueue.main.addOperation(completionOP)
    }
}

