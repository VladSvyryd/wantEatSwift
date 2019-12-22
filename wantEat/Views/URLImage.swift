//
//  URKImage.swift
//  wantEat
//
//  Created by Vlad Svyryd on 22.12.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct URLImage: View {
    //
    let url: String
    @ObservedObject private var imageDownloader = ImageDownloader()
    init(url: String){
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }
    
    var body: some View {
        if let imageData = self.imageDownloader.downloadedData{
            let img = UIImage(data: imageData)
            return VStack{Image(uiImage: img!).resizable().aspectRatio(1,contentMode: .fit)}
            
        }else {
            return (VStack(alignment: .center){
                
                Image("").resizable().aspectRatio(1,contentMode: .fit)
                
            })
        }
    }
}

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage( url:"https://spoonacular.com/recipeImages/716429-312x231.jpg") .padding(.bottom)
                   
                       .frame(width: 110, height: 95)
                       .cornerRadius(10)
        .border(Color.black)
    }
}
