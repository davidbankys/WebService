//
//  ViewController.swift
//  Assignment2:WebServices
//
//  Created by Cambrian on 2022-10-19.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var breeds: [Dog] = [Dog]()
    var dogImages = [String]()
    var selectedBreed = NSMutableDictionary()
    
    struct Dog {
        let name: String
        let subBreed: [String]?
    }
    
    struct DogImage: Codable {
        let message: [String]?
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedsCell") as! BreedsCell
        cell.setUpView(with: breeds[indexPath.row], imgUrl: dogImages[indexPath.row])
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateDogDetails" {
            let dogsListVC = segue.destination as! DetailsViewController
            dogsListVC.selectedDog = selectedBreed
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "BreedsCell", bundle: nil), forCellReuseIdentifier: "BreedsCell")
        tableView.delegate = self
        tableView.dataSource = self
        loadBreeds()
    }

    
    func loadDogsImage() {
        APIRequest().requestDogsImageAPIInfo { [weak self] result in
            switch result {
            case .success(let dogs):
                if let images = dogs.message {
                    self?.dogImages = images
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    func loadBreeds() {
        APIRequest().requestAPIInfo { [weak self] result in
            switch result {
            case .success(let dogs):
                self?.breeds = dogs
                DispatchQueue.main.async {
                    self?.loadDogsImage()
                }
            case .failure(_):
                break
            }
        }
    }
    
    struct APIRequest {
        
        let urlString = "https://dog.ceo/api/breeds/list/all"
        let dogsImageUrl = "https://dog.ceo/api/breed/hound/images"
        
        //create method to get decode the json
        func requestAPIInfo(completion: @escaping(Result<[Dog], Error>) -> Void) {
            
            let dataTask = URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
                
                guard error == nil else {
                    print (error!.localizedDescription)
                    print ("stuck in data task")
                    return
                }
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    var breeds = [Dog]()
                    guard let breedsJson = json["message"] as? [String: [String]] else { return }
                    for breedName in breedsJson.keys {
                        let subBreed = breedsJson[breedName]
                        let dog = Dog(name: breedName, subBreed: subBreed)
                        breeds.append(dog)
                    }
                    completion(.success(breeds))
                } catch {
                    print("error")
                }
            }
            dataTask.resume()
        }
        
        //create method to get decode the json
        func requestDogsImageAPIInfo(completion: @escaping(Result<DogImage, Error>) -> Void) {
            
            let dataTask = URLSession.shared.dataTask(with: URL(string: dogsImageUrl)!) { (data, response, error) in
                
                guard error == nil else {
                    print (error!.localizedDescription)
                    print ("stuck in data task")
                    return
                }
                
                
                do {
                    if let data = data,
                       let dogImagesList = try? JSONDecoder().decode(DogImage.self, from: data) {
                        completion(.success(dogImagesList))
                    }
                } catch {
                    print("error")
                }
            }
            dataTask.resume()
        }
    }
}
