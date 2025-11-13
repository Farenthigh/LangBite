//
//  ProfileView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var fav: FavoritesManager
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.fill").resizable().frame(width: 88, height: 88).foregroundColor(.blue)
                    Text("Thunwa").font(.title2).bold()
                    Text("thunwa@gmail.com").font(.caption).foregroundColor(.secondary)
                }
                .padding(.top, 30)
                
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Favorite (\(fav.favorites.count))").font(.headline).padding(.horizontal)
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(fav.favorites, id: \.self) { f in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(f).bold()
                                        Text("250 words").font(.caption).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "heart.fill").foregroundColor(.red)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)).shadow(radius: 2))
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
#Preview {
    ProfileView()
}
