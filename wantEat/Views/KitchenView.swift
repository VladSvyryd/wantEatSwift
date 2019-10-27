//
//  SwiftUIView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 16.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct RandomRecipe: Identifiable{
    var id: Int
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
    let buttonTitles:[String] = ["breakfast","lunch","dinner","dessert"]
    @State var activeScrollView: Int = 2
    @State var activeButton = 0
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
                    ForEach(0..<buttonTitles.count){  i in
                        GeometryReader{ geometry in
                            Button(action:{
                                self.activeButton = i
                            }){
                                Text("\(self.buttonTitles[i])")
                            }
                        }
                    }
                }
            Spacer()
           
        }
         
        
        
    }
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
            
            Image(category.imageUrl).frame(width: 200, height: 300).cornerRadius(10).shadow(radius: 10).aspectRatio(contentMode: .fit)
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
