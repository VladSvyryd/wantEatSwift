//
//  TagModel.swift
//  wantEat
//
//  Created by Vlad Svyryd on 02.01.20.
//  Copyright © 2020 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import SwiftUI

struct TagModel: Identifiable, Equatable {
    var id = UUID()
    var index: Int
    var size: CGFloat = CGFloat(10 + Int.random(in: 20 ..< 50))
    var color: Color = Color.gray
}
