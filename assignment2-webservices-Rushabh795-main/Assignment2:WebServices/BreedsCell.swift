//
//  BreedsCell.swift
//  Assignment2:WebServices
//
//  Created by Rushabh Shah on 2022-10-20.
//

import UIKit

class BreedsCell: UITableViewCell {

    @IBOutlet weak var breedTitle: UILabel!
    @IBOutlet weak var subBreedTitles: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    func setUpView(with dog: ViewController.Dog, imgUrl: String) {
        breedTitle.text = dog.name
        subBreedTitles.text = dog.subBreed?.joined(separator: ",") ?? ""
        
        if let url = URL(string:imgUrl), let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                dogImage.image = image
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
