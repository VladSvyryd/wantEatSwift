//
//  ToBuyItem.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 07.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import CoreData

public class ToBuyItem:NSManagedObject, Identifiable {
    @NSManaged public var name:String?
    @NSManaged public var didbuy:Bool?
    @NSManaged public var amount:Double?
    @NSManaged public var date:Date?
    @NSManaged public var measure:String?
    
}
