//
//  SearchCollectionViewController.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/19/21.
//

import UIKit

class SearchCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.fetchDogImagesForSpecies(named: "hound") { (images, error) in
            if let error = error {
                NSLog("Error fetching photos for hound: \(error)")
                return
            }
            
            if let images = images {
                self.images = images.message
            }
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        
        //self.hideKeyboardWhenTappedAround()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? DogReusableCollectionViewCell ?? DogReusableCollectionViewCell()
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "":
            print("")
            
        default:
            print("")
            
            
            
        }
     }
}

extension SearchCollectionViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        controller.fetchDogImagesForSpecies(named: searchTerm.lowercased()) { (images, error) in
            if let error = error {
                NSLog("Error fetching photos for hound: \(error)")
                return
            }
            
            if let images = images {
                self.images = images.message
            }
        }
        view.endEditing(true)
    }
}
