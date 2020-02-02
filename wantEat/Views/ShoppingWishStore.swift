//
//  ShoppingWishStore.swift
//  wantEat
//
//  Created by Vlad Svyryd on 19.12.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//


import Foundation
import SwiftUI
import CoreData
// deprecated was used to connect with Core Data to manipulate Data
class ShoppingWishStore{
    public static func defaultItems() -> [ShoppingWish]{
        let store = NSPersistentContainer(name: "ItemStore")
        store.loadPersistentStores { (desc, err) in
            if let err = err {
                fatalError("core data error: \(err)")
            }
        }
        let context = store.viewContext
        let item = ShoppingWish(context: context)
        
        return [
            item,
            
        ]
    }
}

