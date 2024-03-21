//
//  EditBookView.swift
//  MyBooks
//
//  Created by july on 2024/3/15.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book: Book
    @State private var status: Status
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var comment = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var recommendedBy = ""
    @State private var showGenres = false
    
    init(book: Book) {
        self.book = book
        _status = State(initialValue: Status(rawValue: book.status)!)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Status")
                    Spacer()
                    Picker("Status", selection: $status) {
                        ForEach(Status.allCases) { status in
                            Text(status.descr).tag(status)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    GroupBox {
                        LabeledContent {
                            switch status {
                            case .onShelf:
                                DatePicker("", selection: $dateAdded, displayedComponents: .date)
                            case .inProgress, .completed:
                                DatePicker("", selection: $dateAdded, in: ...dateAdded, displayedComponents: .date)
                            }
                            
                        } label: {
                            Text("Date Added")
                        }
                        
                        if status == .inProgress || status == .completed {
                            LabeledContent {
                                DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                            } label: {
                                Text("Date Started")
                            }
                        }
                        
                        if status == .completed {
                            LabeledContent {
                                DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
                            } label: {
                                Text("Date Completed")
                            }
                        }
                    }
                    .foregroundStyle(.secondary)
                    .onChange(of: status) { oldValue, newValue in
                        if newValue == .onShelf {
                            dateStarted = Date.distantPast
                            dateCompleted = Date.distantPast
                        } else if newValue == .inProgress && oldValue == .completed {
                            dateCompleted = Date.distantPast
                        } else if newValue == .inProgress && oldValue == .onShelf {
                            dateStarted = Date.now
                        } else if newValue == .completed && oldValue == .onShelf {
                            dateCompleted = Date.now
                            dateStarted = dateAdded
                        } else {
                            dateCompleted = Date.now
                        }
                    }
                    Divider()
                    LabeledContent {
                        RatingsView(maxRating: 5, currentRating: $rating, width: 30)
                    } label: {
                        Text("Rating")
                    }
                    LabeledContent {
                        TextField("", text: $title)
                    } label: {
                        Text("Title").foregroundStyle(.secondary)
                    }
                    LabeledContent {
                        TextField("", text: $author)
                    } label: {
                        Text("Author").foregroundStyle(.secondary)
                    }
                    LabeledContent {
                        TextField("", text: $recommendedBy)
                    } label: {
                        Text("Recommended By").foregroundStyle(.secondary)
                    }
                    Divider()
                    Text("Comment").foregroundStyle(.secondary)
                    
                    TextEditor(text: $comment)
                        .frame(minHeight: 200)
                        .padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
                    if let genres = book.genres {
                        ViewThatFits {
                            GenresStackView(genres: genres)
                            ScrollView(.horizontal, showsIndicators: false) {
                                GenresStackView(genres: genres)
                            }
                        }
                    }
                    HStack(alignment: .center, spacing: 10) {
                        Button("Genres", systemImage: "bookmark.fill") {
                            showGenres.toggle()
                        }
                        .sheet(isPresented: $showGenres) {
                            GenresView(book: book)
                        }
                        
                        NavigationLink {
                            QuoteListView(book: book)
                        } label: {
                            let count = book.quotes?.count ?? 0
                            Label("\(count) Quotes", systemImage: "quote.opening")
                        }
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                }
                .textFieldStyle(.roundedBorder)
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if changed {
                    Button("Update") {
                        //update the context
                        book.status = status.rawValue
                        book.rating  = rating
                        book.title = title
                        book.author = author
                        book.comment = comment
                        book.dateAdded = dateAdded
                        book.dateStarted = dateStarted
                        book.dateCompleted = dateCompleted
                        book.recommendedBy = recommendedBy
                        dismiss()
                    }
                    .buttonStyle(.borderless)
                }
            }
            .onAppear {
                rating = book.rating
                title = book.title
                author = book.author
                comment = book.comment
                dateAdded = book.dateAdded
                dateStarted = book.dateStarted
                dateCompleted = book.dateCompleted
                recommendedBy = book.recommendedBy
            }
        }
    }
    
    var changed: Bool {
        status != Status(rawValue: book.status)!
        || rating != book.rating
        || title != book.title
        || author != book.author
        || comment != book.comment
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
        || recommendedBy != book.recommendedBy
    }
}

#Preview {
    let preview = Preview(Book.self)
    return NavigationStack {
        EditBookView(book: Book.sampleBooks[2])
            .modelContainer(preview.container)
    }
}
