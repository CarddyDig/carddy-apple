//
//  Item.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
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
