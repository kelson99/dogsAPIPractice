//
//  ProfileViewController.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/20/21.
//

import UIKit
import CoreData
import PieCharts


class ProfileViewController: UIViewController, PieChartDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var chartView: PieChart!
    
    var blockOperations = [BlockOperation]()
    var dogBreedDict = [String : Int]()
    
    lazy var fetchResultsController: NSFetchedResultsController<SavedDog> = {

        let fetchRequest: NSFetchRequest<SavedDog> = SavedDog.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "breed", ascending: true)]
//        fetchRequest.predicate = NSPredicate(format: "user.name == %@", user?.name ?? "")

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)

        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }

        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chartView.models = createModels()
        chartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        
        chartView.delegate = self
        
        sortDogBreedByCount()
    }
    
    func sortDogBreedByCount() {
        if let resultsFromFetch = fetchResultsController.fetchedObjects {
            for x in resultsFromFetch {
                if let dogBreed = x.breed {
                    if dogBreedDict[dogBreed] == nil {
                        dogBreedDict[dogBreed] = 1
                    } else {
                        dogBreedDict[dogBreed] = 1
                    }
                }
            }
        }
        
        let sortedDict = dogBreedDict.sorted { (one, two) -> Bool in
            one.value < two.value
        }
        print(sortedDict)
    }

    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }
    
    fileprivate func createModels() -> [PieSliceModel] {
        let alpha: CGFloat = 0.5
        
        return [
            PieSliceModel(value: 3, color: UIColor.yellow.withAlphaComponent(alpha)),
            PieSliceModel(value: 6, color: UIColor.blue.withAlphaComponent(alpha)),
            PieSliceModel(value: 1, color: UIColor.green.withAlphaComponent(alpha))
        ]
    }
    
    
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
    
    
        

}
