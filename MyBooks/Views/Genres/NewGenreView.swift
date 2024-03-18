//
//  NewGenreView.swift
//  MyBooks
//
//  Created by july on 2024/3/18.
//

import SwiftUI

struct NewGenreView: View {
    @State private var name = ""
    @State private var color = Color.red
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Genre name", text: $name)
                ColorPicker("Set the genre color", selection: $color)
                Button {
                    let genre = Genre(name: name, color: color.toHexString()!)
                    context.insert(genre)
                    dismiss()
                } label: {
                    Text("Create")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(name.isEmpty)
            }
            .padding()
            .navigationTitle("New Genre")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NewGenreView()
}
