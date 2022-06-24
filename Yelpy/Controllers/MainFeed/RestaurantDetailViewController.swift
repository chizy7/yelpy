//
//  RestaurantDetailViewController.swift
//  Yelpy
//
//  Created by Chizaram Chibueze on 2/10/22.
//  Copyright © 2022 memo. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantDetailViewController: UIViewController {

    // ––––– TODO: Configure outlets
    // NOTE: Make sure to set images to "Content Mode: Aspect Fill" on the
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    
    // Initialize restaurant variable
    var r: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureOutlets()
    }
    
    // Configure Outlets
    func configureOutlets() {
        nameLabel.text = r.name
        reviewsLabel.text = String(r.reviews)
        starImage.image = Stars.dict[r.rating]!
        headerImage.af.setImage(withURL: r.imageURL!)
        
        // Adding tint opacity to image to make text stand out
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tintView.frame = CGRect(x: 0, y: 0, width: headerImage.frame.width, height: headerImage.frame.height)
        
        headerImage.addSubview(tintView)
    }

}
