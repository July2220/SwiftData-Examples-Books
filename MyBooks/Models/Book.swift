//
//  Book.swift
//  MyBooks
//
//  Created by july on 2024/3/15.
//

import SwiftUI
import SwiftData

//将其声明为 SwiftData 模型
@Model
class Book {
    var title: String = ""
    var author: String = ""
    var dateAdded: Date = Date.now
    var dateStarted: Date = Date.distantPast
    var dateCompleted: Date = Date.distantPast
    @Attribute(originalName: "summary")
    var comment: String = ""
    var rating: Int?
    var status: Status.RawValue = Status.onShelf.rawValue
    var recommendedBy: String = ""
    
    //if you want to use the cloudkit, all relation should be optional.
    @Relationship(deleteRule: .cascade)
    var quotes: [Quote]?
    
    //@Relationship(inverse: \Genre.books) 来显式地声明实体之间的关系。
    @Relationship(inverse: \Genre.books)
    var genres: [Genre]?
    
    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,
        comment: String = "",
        rating: Int? = nil,
        status: Status = .onShelf,
        recommendedBy: String = ""
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.comment = comment
        self.rating = rating
        self.status = status.rawValue
        self.recommendedBy = recommendedBy
    }
    
    var icon: Image {
        switch Status(rawValue: status)! {
        case .onShelf:
            Image(systemName: "books.vertical.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "checkmark.circle.fill")
        }
    }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed
    
    var id: Self {
        self
    }
    
    var descr: LocalizedStringResource {
        switch self {
        case .onShelf:
            "On Shelf"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
}
