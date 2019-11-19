//
//  SwiftUIView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 16.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

class NetworkManager: ObservableObject {
    var didChange = PassthroughSubject<NetworkManager,Never>()
    var receipes = [Receipe](){
        didSet{
            didChange.send(self)
        }
    }
    init(){
        guard let url = URL(string: "ttps://api.spoonacular.com/food/ingredients/autocomplete?query=appl&number=5&apiKey=22a9074551b64e11a4f4ee8bd2f7470f")
            else {return}
        URLSession.shared.dataTask(with: url){ (data,responce,error) in
            if let data = data {
                do{
                    let res = try JSONDecoder().decode([Receipe].self, from: data)
                    // do fetch in main thread
                    DispatchQueue.main.async {
                        
                        self.receipes = res
                        print(self.receipes)
                    }
                }catch let error{
                    print(error)
                }
                
            }
            
            //guard let data = data else{ return }
            //let recepies = try! JSONDecoder().decode([Receipe].self, from: data)
            
            //DispatchQueue.main.async {
            //  print(recepies)
            // self.receipes = recepies
            //}
            
            
            print("completed fetching json")
        }.resume()
        
    }
  
}

struct RandomRecipe: Identifiable{
    var id: Int?
    let title, imageUrl: String
    let ingredients: [String]
}

struct KitchenView: View {
    let categories:[RandomRecipe] = [
        RandomRecipe(id: 0, title: "Schuschluk", imageUrl: "breakfast", ingredients:["Pork", "blood", "catchup", "gas"]),
        RandomRecipe(id: 1, title: "Steak", imageUrl: "lunch",ingredients:["Pork", "blood", "catchup", "gas"]),
        RandomRecipe(id: 2, title: "test", imageUrl: "dinner",ingredients:["Pork", "blood", "catchup", "gas"]),
        RandomRecipe(id: 3, title: "Cake", imageUrl: "dessert",ingredients:["Pork", "blood", "catchup" ,"gas"])
    ]
    let mealCategories:[String] = ["breakfast","lunch","dinner","dessert"]
    @State var activeScrollView: Int = 2
    @State var activeButton = 0
    @State var networkManager = NetworkManager()
    
    
    var body: some View {
        
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center){
                    ForEach(categories) { category in
                        GeometryReader{ geometry in
                            
                            BoxView(category: category)
                                .rotation3DEffect(Angle(degrees:(Double(geometry.frame(in: .global).minX) - (Double(UIScreen.main.bounds.width / 4))) / -5), axis: (x:0, y:10.0 , z:0))
                            
                            
                        }
                        .frame(width: 200, height: 300)
                        
                    }
                }
                    
                .padding(.top,35)
                .padding(.bottom,35)
                .padding(.leading, UIScreen.main.bounds.width / CGFloat(UIScreen.main.bounds.width / 110))
                .padding(.trailing,  UIScreen.main.bounds.width / CGFloat(UIScreen.main.bounds.width / 110))
                
            }
            HStack(alignment: .top){
                ForEach(0..<mealCategories.count){  i in
                    Button(action:{
                        self.activeButton = i
                    }){
                        Text("\(self.mealCategories[i])")
                    }
                    .padding()
                }
            }
            HStack(alignment: .top){
                Text("Popular")
                Spacer()
                Text("...")
            }.padding(.horizontal,30)
            Spacer()
           
            VStack(alignment: .center){
                Text("Stack Begin")
                List(networkManager.receipes, id: \.self){
                obj in
                  
                        Text("dddd")
                    
                }
                Text("Stack End")
                
                
            }
            Spacer()
            
        }
        
        
        
    }
}

struct Receipe: Codable & Hashable {
    var name: String
    var image: String
}

struct Line: View{
    
    var body: some View {
        
        Path { path in
            path.move(to:CGPoint(x: 0,y: 3))
            path.addLine(to:CGPoint(x: 85, y: 3))
            path.addLine(to:CGPoint(x: 85, y: 0))
            path.addLine(to:CGPoint(x: 0, y: 0))
        } .fill(Color.init(red: 0, green: 0, blue: 0, opacity: 0.85))
    }
    
}

struct BoxView: View{
    let category: RandomRecipe
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            Image(category.imageUrl)
                .frame(width: 200, height: 300)
                .cornerRadius(10)
                .shadow(radius: 10)
                .aspectRatio(contentMode: .fit)
            HStack(alignment: .top){
                
                VStack(alignment: .leading){
                    
                    Text(category.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                    
                    HStack{
                        Text(category.ingredients.joined(separator: ", "))
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                }
                .padding()
                .background(Color.init(red: 0, green: 0, blue: 0, opacity: 0.55))
            }
            
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenView()
    }
}
