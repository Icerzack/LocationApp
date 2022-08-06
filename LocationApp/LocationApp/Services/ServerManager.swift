//
//  ServerInteraction.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 30.06.2022.
//

import Foundation

typealias JSONData = [String:Any]

class ServerManager {
    
    func sendJSON(withJSON json: JSONData, andURL url: URL){
        // Create data object from json dict
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // Create request from string URL
        var request = URLRequest(url: url)
        
        // Select method of request
        request.httpMethod = "POST"

        // Fill the body of request with data
        request.httpBody = jsonData

        // Add additional json-oriented headers for request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create task with options and receive some possible data, response and error back
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
        }

        // Perform the task
        task.resume()
    }
    
}
