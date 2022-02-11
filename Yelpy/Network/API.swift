//
//  File.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import Foundation


struct API {
    

    
    static func getRestaurants(completion: @escaping ([Restaurant]?) -> Void) {
        
        // ––––– TODO: Add your own API key!
        let apikey = "dVbmyeBFLZAeAoNoUkE-rKfhVa91E2l4GPh_v_bt1SY8_K9cQJflxGVII08l-2dvLVUxdIhygi-kpwYZzCSMphM5uIQtTqFH7ZmFOAB7KGuSILMsPbiZcaWlNmUAYnYx"
        
        // Coordinates for San Francisco
        let lat = 37.773972
        let long = -122.431297
        
        // Client ID
        // 
        
        
        let url = URL(string: "https://api.yelp.com/v3/transactions/delivery/search?latitude=\(lat)&longitude=\(long)")!
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Insert API Key to request
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                // Get data from API and return it using completion
                // 1. Convert json response to a dictionary
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // 2. Grab the businesses data and convert it to an array of dictionaries for each restaurant
                let restDict = dataDictionary["businesses"] as! [[String: Any]]
                
                let restaurants = restDict.map({ Restaurant.init(dict: $0) })
                
//                //Using for loop | Variable to store array of Restaurants
//                var restaurants: [Restaurant] = []
//                // Use each restaurant dictionary to initialize Restaurant object
//                for dictionary in dataDictionarie {
//                    let restaurant = Restaurant.init(dict: dictionary as! [String : Any])
//                    restaurants.append(restaurant) // add to restaurants array
//                }
                
                return completion(restaurants)
                
                }
            }
        
            task.resume()
        
        }
    }

    
