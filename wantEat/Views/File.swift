//
//  File.swift
//  wantEat
//
//  Created by Vlad Svyryd on 17.12.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct CoreDataStore{
    
    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: [NSSortDescriptor(key: "dateWasBought", ascending: false)]) var sItems: FetchedResults<ShoppingWish>
}
