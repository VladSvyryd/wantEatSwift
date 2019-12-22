//
//  File.swift
//  wantEat
//
//  Created by Vlad Svyryd on 22.12.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//


import Foundation
import Combine

class ImageDownloader: ObservableObject{
    // if downloadedData changes, event will be published and UI will be updated
    @Published var downloadedData: Data? = nil
    
    func downloadImage(url: String){
        // check if link works
        guard let imageURL = URL(string: url) else{
            fatalError("Invalid URL")
        }
     DispatchQueue.global().async {
        // get async data
        let data = try? Data(contentsOf: imageURL)
          DispatchQueue.main.async {
            // set data
            self.downloadedData = data
            }
        }
    }
}
