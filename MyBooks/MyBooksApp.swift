//
//  MyBooksApp.swift
//  MyBooks
//
//  Created by july on 2024/3/15.
//

import SwiftUI
import SwiftData

@main
struct MyBooksApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
        .modelContainer(container)
    }
    
    init() {
        let schema = Schema([Book.self])
        let config = ModelConfiguration("MyBooks", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
