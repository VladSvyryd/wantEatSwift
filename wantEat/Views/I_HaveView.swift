//
//  I_HaveView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 16.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct I_HaveView: View {
    @State private var rotateCamera = false
    var body: some View {
    
        VStack{
            Text("I have")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
                .padding(4)
            Image("list")
                .frame(width: 300, height: 300)
            .clipped()
            .cornerRadius(30)
            
                .shadow(radius:rotateCamera ?  30 : 200)
                .rotationEffect(.degrees(rotateCamera ? 12 : -12 ), anchor: .center)
                .animation(Animation.spring().repeatForever(autoreverses: true))
                
        }
        
        .onAppear(){
            self.rotateCamera.toggle()
        }
    }
}

struct I_HaveView_Previews: PreviewProvider {
    static var previews: some View {
        I_HaveView()
    }
}
