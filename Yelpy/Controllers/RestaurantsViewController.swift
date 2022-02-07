//
//  ViewController.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // ––––– TODO: Add storyboard Items (i.e. tableView + Cell + configurations for Cell + cell outlets)
    // ––––– TODO: Next, place TableView outlet here
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        getAPIData()
    }
    
    // ––––– TODO: Update API to get an array of restaurant objects
    func getAPIData() {
        API.getRestaurants() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            print (restaurants)
            self.restaurantsArray = restaurants
        }
    }
    
    // –––––– TODO: Initialize restaurantsArray
    var restaurantsArray: [[String:Any?]] = []
    
    // ––––– TODO: Add tableView datasource + delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        
        let restaurant = restaurantsArray[indexPath.row]
        
        // Set name and phone of cell label
        cell.nameLabel.text = restaurant["name"] as? String
        
        // Set Image of restaurant
        if let imageUrlString = restaurant["image_url"] as? String {
            let imageUrl = URL(string: imageUrlString)
            cell.restaurantImage.af.setImage(withURL: imageUrl!)
        }
        
        return cell
    }
    
    
    
    
    // ––––– TODO: Get data from API helper and retrieve restaurants
    

}

// ––––– TODO: Create tableView Extension and TableView Functionality


