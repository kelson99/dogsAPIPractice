//
//  PhotoDetailViewController.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/19/21.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var dog: DogToBeSaved?
    var controller: DogModelController?
    
    
    private let borderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let dogImage = UIImageView()
    private let dogBreedLabel = UILabel()
    private let saveButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dog = dog, isViewLoaded else { return }
        do {
            let data = try Data(contentsOf: dog.imageURL)
            dogImage.image = UIImage(data: data)
        } catch {
            NSLog("Error setting up views on detail view controller: \(error)")
        }
        setUpSubViews()
    }
    
    
    
    private func setUpSubViews() {
        view.addSubview(dogImage)
        dogImage.translatesAutoresizingMaskIntoConstraints = false
        dogImage.contentMode = .scaleAspectFit
        dogImage.layer.borderWidth = 3
        dogImage.layer.borderColor = UIColor.blue.cgColor
        
        NSLayoutConstraint.activate([
            dogImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dogImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            dogImage.widthAnchor.constraint(equalToConstant: 400),
            dogImage.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(dogBreedLabel)
        dogBreedLabel.translatesAutoresizingMaskIntoConstraints = false
        dogBreedLabel.text = "Breed: \(dog?.breed.capitalized ?? "Unknown")"
        dogBreedLabel.font = UIFont(name: "Bradley Hand Bold", size: 30)
        
        NSLayoutConstraint.activate([
            dogBreedLabel.topAnchor.constraint(equalTo: dogImage.bottomAnchor, constant: 20),
            dogBreedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = .green
        saveButton.layer.cornerRadius = 4
        saveButton.addTarget(self, action: #selector(saveDog), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: dogBreedLabel.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: dogBreedLabel.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: dogBreedLabel.trailingAnchor)
        ])
    }
    
    
    @objc func saveDog() {
        guard let dog = dog, isViewLoaded else { return }
        do {
            let data = try Data(contentsOf: dog.imageURL)
            controller?.createDogToBeSaved(breed: dog.breed, dogPhoto: data)
        } catch {
            NSLog("Error setting up views on detail view controller: \(error)")
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
