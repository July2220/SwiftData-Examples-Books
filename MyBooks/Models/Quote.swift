//
//  Quote.swift
//  MyBooks
//
//  Created by july on 2024/3/18.
//

import Foundation
import SwiftData

@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
    var book: Book?
}
