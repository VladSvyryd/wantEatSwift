//
//  playground.swift
//  wantEat
//
//  Created by Vlad Svyryd on 12.01.20.
//  Copyright © 2020 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct playground: View {
    @State var t = true
    @State var isLoading = false
    //var spinner = UIActivityIndicatorView(style: .whiteLarge)
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var body: some View {
        VStack{
            Toggle(isOn: $t) {
                       Text("For me")
                   }
          Spinner()
            Button(action: {
                self.isLoading.toggle()
            }, label: {
                Text("push")
            })
            Text("Nothing found").font(.largeTitle).fontWeight(.bold).foregroundColor(Color.gray)
        }
       
    }
}
struct Spinner: View {
    @State var isLoading = true
     var body: some View {
        Circle()
                        .trim(from: 0.5, to: 1)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow, .blue, .purple, .red]), center: .center), lineWidth: 4)
                       
                       .frame(width:80, height: 80)
                  
                       .rotationEffect(.degrees(!isLoading ? 0 : -360), anchor: .center)
                       
                       .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                   
                       .onAppear(){
                           self.isLoading.toggle()
                   }
    }
}


struct playground_Previews: PreviewProvider {
    static var previews: some View {
        playground()
    }
}
