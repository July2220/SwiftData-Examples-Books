//
//  ContentView.swift
//  MyBooks
//
//  Created by july on 2024/3/15.
//

import SwiftUI
import SwiftData

enum SortOrder: String, Identifiable, CaseIterable {
    case title = "Title"
    case author = "Author"
    case status = "Status"
    case dateAdded = "Date Added"
    
    var id: Self {
        self
    }
}

struct BookListView: View {
    
    @State private var createNewBook = false
    @State private var sortOrder = SortOrder.dateAdded
    @State private var filter = ""
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                Picker("", selection: $sortOrder) {
                    ForEach(SortOrder.allCases) { sortOrder in
                        Text("Sort by \(sortOrder.rawValue)")
                            .tag(sortOrder)
                    }
                }
                .buttonStyle(.borderless)
            }
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: Text("Filter on title or author"))
                .navigationTitle("My Books")
                .toolbar {
                    Button {
                        createNewBook = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                .sheet(isPresented: $createNewBook) {
                    NewBookView()
                        .presentationDetents([.medium])
                }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    let genres = Genre.sampleGenres
    preview.addExamples(books)
    preview.addExamples(genres)
    return BookListView()
        .modelContainer(preview.container)
}
