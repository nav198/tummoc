//
//  ImageHelper.swift
//  tummoc
//
//  Created by nav on 01/08/24.
//

import Foundation
import UIKit

func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching image: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        let image = UIImage(data: data)
        DispatchQueue.main.async {
            completion(image)
        }
    }
    
    task.resume()
}
