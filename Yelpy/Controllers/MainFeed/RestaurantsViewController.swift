//
//  ViewController.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import UIKit
import AlamofireImage
import Lottie
import SkeletonView

class RestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var restaurantsArray: [Restaurant] = [] // Initialize restaurantsArray
    
    // Search Bar Outlet + Variable for filtered Results
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredRestaurants: [Restaurant] = []
    
    // Variable inits
    var animationView: AnimationView?
    var refresh = true
    
    let yelpRefresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimations()
        
        // Table view
        tableView.visibleCells.forEach { $0.showSkeleton() }
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self // Search Bar Delegate
        
        getAPIData() // To get data from API
        
        yelpRefresh.addTarget(self, action: #selector(getAPIData), for: .valueChanged)
        tableView.refreshControl = yelpRefresh
    }
    
    // Update API results to get an array of restaurant objects + restaurantArray variable + filteredRestaurants
    @objc func getAPIData() {
        API.getRestaurants() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.restaurantsArray = restaurants
            self.filteredRestaurants = restaurants
            self.tableView.reloadData()
            
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.stopAnimations), userInfo: nil, repeats: false)
            
            self.yelpRefresh.endRefreshing()
        }
    }
    
}

extension RestaurantsViewController: SkeletonTableViewDataSource {
    func startAnimations() {
        // start Skeleton
        view.isSkeletonable = true
        
        animationView = .init(name: "4762-food-carousel")
        // Set the size to the frame
        // animationView!.frame = view.bounds
        animationView!.frame = CGRect(x: view.frame.width / 3, y: 156, width: 100, height: 100)
        
        // fit the animation
        animationView!.contentMode = .scaleAspectFit
        view.addSubview(animationView!)
        
        // ____ Set animation loop mode
        animationView!.loopMode = .loop
        
        // Animation speed - Larger number = faster
        animationView!.animationSpeed = 5
        
        // Play animation
        animationView!.play()
    }
    
    @objc func stopAnimations() {
        // Stop Animation
        animationView?.stop()
        // Change the subview to last and remove the current subview
        view.subviews.last?.removeFromSuperview()
        view.hideSkeleton()
        refresh = false
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "RestaurantCell"
    }
}
    
    // TableView Functionality
    // Segue for passing restaurant to details view controller
extension RestaurantsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRestaurants.count
    }
    // Configure cell using MVC
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Restaurant Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        
        // set cell's restaurant
        cell.r = filteredRestaurants[indexPath.row]
        
        // Initialize skeleton view everytime cell gets intialized
        cell.showSkeleton()
        
        // Stop animations after like .5 seconds
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            cell.stopSkeletonAnimation()
            cell.hideSkeleton()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let r = filteredRestaurants[indexPath.row]
            let detailViewController = segue.destination as! RestaurantDetailViewController
            detailViewController.r = r
        }
    }
        
}
    
    
    // Protocol + Functionality for Searching
    // UISearchResultsUpdating informs the class of text changes happening in the UISearchBar
extension RestaurantsViewController: UISearchBarDelegate {
        
    // Search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredRestaurants = restaurantsArray.filter { (r: Restaurant) -> Bool in
                return r.name.lowercased().contains(searchText.lowercased())
            }
        }
        else {
            filteredRestaurants = restaurantsArray
        }
        tableView.reloadData()
    }
    
    // Show cancel button when typing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    // Logic for searchBar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false // remove cancel button
        searchBar.text = "" // reset search text
        searchBar.resignFirstResponder() // remove keyboard
        filteredRestaurants = restaurantsArray // reset results to display
        tableView.reloadData()
    }
    
}



