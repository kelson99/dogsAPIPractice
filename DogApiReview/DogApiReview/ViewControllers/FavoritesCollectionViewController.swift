//
//  FavoritesCollectionViewController.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/19/21.
//

import UIKit
import CoreData

class FavoritesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    lazy var fetchResultsController: NSFetchedResultsController<SavedDog> = {
        
        let fetchRequest: NSFetchRequest<SavedDog> = SavedDog.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "breed", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            
        } catch {
            fatalError("ERROR")
        }
        
        return frc
        
    }()
    
    private var blockOperations = [BlockOperation]()
    
    var images = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? DogReusableCollectionViewCell ?? DogReusableCollectionViewCell()
        
        let dog = fetchResultsController.object(at: indexPath)
        guard let dogPhoto = dog.dogPhoto else { fatalError() }
        
        cell.imageView.image = UIImage(data: dogPhoto)
        
        return cell
    }
    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let op: BlockOperation
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            op = BlockOperation {self.collectionView.insertItems(at: [newIndexPath])}
            
        case .delete:
            guard let _ = indexPath, let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.collectionView.deleteItems(at: [newIndexPath])}
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.collectionView.moveItem(at: indexPath, to: newIndexPath)}
            
        case .update:
            guard let _ = indexPath, let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.collectionView.reloadItems(at: [newIndexPath])}
            
        default:
            fatalError()
        }
        
        blockOperations.append(op)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates {
            self.blockOperations.forEach { $0.start() }
        } completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        }
    }
    
    deinit {
        for operation in blockOperations {
            operation.cancel()
        }
        self.blockOperations.removeAll(keepingCapacity: false)
    }
}
