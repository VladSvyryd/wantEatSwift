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
        
        VStack(spacing: 20){
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
                    
                }
            }
            HStack(alignment: .center){
                Text("Popular")
                    .font(.headline)
                    
                Spacer()
                Button(action:{
                    
                }){
                    Image("dots").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color.black)
                        .frame(width: 28, height: 6)
                    
                }
               
            }.padding(.horizontal,40)
           
            VStack(spacing: 20){
                HugeButton(image: Image("tomatoes"), name: "salad")
                         HugeButton(image: Image("soup"), name: "soup")
                         HugeButton(image: Image("dips"), name: "sauce")
            }
         Spacer()
        }
        
        
        
    }
}

struct HugeButton: View{
    var image: Image
    var name: String
    @State var clicked = false
    var body: some View {
        Button(action:{
            //self.clicked.toggle()
                       }){
                        ZStack{
                            image.renderingMode(.original).resizable().aspectRatio(1,contentMode: .fill).scaleEffect(   1).frame(width: UIScreen.main.bounds.width - 100, height: 70).cornerRadius(20).blendMode(.screen)
                                .overlay(
                                    !clicked ?  Rectangle().foregroundColor(Color.init(hue: 0, saturation: 0, brightness: 0, opacity: 0.35)).cornerRadius(20) : nil
                            );   Text(name).foregroundColor(Color.white).fontWeight(.semibold).padding(.horizontal,5).cornerRadius(10)
                            
                        }.shadow( color: Color( hue: 0.0, saturation: 0.0, brightness: 0.84), radius:  CGFloat(6), x: CGFloat(0), y: CGFloat(3))
                          
                           
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
                .cornerRadius(15)
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
                .padding(0)
                
            }.frame(width: 200, height: 80)
               
            .background(Color.init(red: 0, green: 0, blue: 0, opacity: 0.55))
             .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenView()
    }
}

