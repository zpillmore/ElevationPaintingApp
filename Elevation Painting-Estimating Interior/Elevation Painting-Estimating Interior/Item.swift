//
//  Item.swift
//  Elevation Painting-Estimating Interior
//
//  Created by Zach Pillmore on 1/15/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
