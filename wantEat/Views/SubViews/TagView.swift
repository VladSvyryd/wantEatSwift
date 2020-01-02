//
//  TagView.swift
//  wantEat
//
//  Created by Vlad Svyryd on 02.01.20.
//  Copyright © 2020 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct TagView: View {
    let rectangle: TagModel
    let scrollDirection: Axis.Set
    
    var body: some View {
        ZStack { Rectangle()
            .foregroundColor(self.rectangle.color)
            .frame(width: self.scrollDirection == .horizontal ? self.rectangle.size : nil, height: self.scrollDirection == .vertical ? CGFloat(self.rectangle.index * 3) : nil)
            .cornerRadius(8)
            
            Text("\(self.rectangle.index)")
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 1, x: 1, y: 1)
        }
        
        
        
        
    }
}
