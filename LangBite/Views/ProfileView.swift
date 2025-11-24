import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var vm: VocabularyViewModel
    
    
    var favoriteWords: [FavoriteItem] {
        fav.favorites.filter { $0.type == .word }
    }
    
    var favoritePlaylists: [FavoriteItem] {
        fav.favorites.filter { $0.type == .playlist }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    
                    ProfileHeader()
                    
                    FavoritePlaylistList(playlists: favoritePlaylists)
                        .environmentObject(fav)
                        .environmentObject(vm)
                    
                    FavoriteWordList(words: favoriteWords)
                        .environmentObject(fav)
                        .environmentObject(vm)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileHeader: View {
    @EnvironmentObject var auth: AuthViewModel
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 88, height: 88)
                .foregroundColor(.blue)
            
            Text(auth.currentUser?.username ?? "กำลังโหลด..")
                .font(.title2).bold()
            
            Text(auth.currentUser?.email ?? "กำลังโหลด..")
                .font(.caption)
                .foregroundColor(.secondary)
            Button("ออกจากระบบ") {
                auth.Logout()
            }
            .font(.subheadline)
            .foregroundColor(.red)
        }
    }
}

struct FavoritePlaylistList: View {
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var vm: VocabularyViewModel
    
    let playlists: [FavoriteItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Playlist Favorite (\(playlists.count))")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(playlists) { item in
                NavigationLink {
                    if let category = VocabCategory.allCases.first(where: { $0.displayName == item.value }) {
                        WordListView(category: category)
                            .environmentObject(vm)
                            .environmentObject(fav)
                    } else {
                        EmptyView()
                    }
                } label: {
                    HStack {
                        Text(item.value)
                            .foregroundStyle(.black)
                            .bold()
                        Spacer()
                        Button {
                            fav.remove(item)
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 1)
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FavoriteWordList: View {
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var vm: VocabularyViewModel
    
    let words: [FavoriteItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Word Favorite (\(words.count))")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(words) { item in
                NavigationLink {
                    if let w = item.word {
                        WordDetailView(word: w)
                            .environmentObject(fav)
                    }
                } label: {
                    ProfileWordRow(item: item)
                }
                .foregroundStyle(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 1)
                )
                .padding(.horizontal)
            }
        }
    }
}

struct ProfileWordRow: View {
    @EnvironmentObject var fav: FavoritesViewModel
    let item: FavoriteItem
    
    var body: some View {
        HStack {
            Text(item.value)
                .font(.body)
                .bold()
            
            Spacer()
            
            Button {
                fav.remove(item)
            } label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(FavoritesViewModel())
        .environmentObject(VocabularyViewModel())
        .environmentObject(AuthViewModel())
}
