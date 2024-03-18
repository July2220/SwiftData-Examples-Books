//
//  GenresStackView.swift
//  MyBooks
//
//  Created by july on 2024/3/18.
//

import SwiftUI

struct GenresStackView: View {
    let genres: [Genre]
    
    var body: some View {
        HStack {
            ForEach(genres.sorted(using: KeyPathComparator(\Genre.name))) { genre in
                Text(genre.name)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5).fill(genre.hexColor))
            }
        }
    }
}

#Preview {
    let previewGenres = Genre.sampleGenres
    return GenresStackView(genres: previewGenres)
}
