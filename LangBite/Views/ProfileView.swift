import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var vm: VocabularyViewModel
    @EnvironmentObject var auth: AuthViewModel
    
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
                        .environmentObject(auth)
                    
                    FavoritePlaylistList(playlists: favoritePlaylists)
                        .environmentObject(fav)
                        .environmentObject(vm)
                        .environmentObject(auth)
                    
                    FavoriteWordList(words: favoriteWords)
                        .environmentObject(fav)
                        .environmentObject(vm)
                        .environmentObject(auth)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Profile")
        }
        .task {
            // Load favorites from API on appear
            if let userId = auth.currentUser?.ID {
                await fav.fetchFavorites(userId: userId)
            }
        }
        .onAppear {
            Task {
                await fav.fetchFavorites(userId: auth.currentUser?.ID ?? 0)
            }
        }
    }
}

struct ProfileHeader: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var fav: FavoritesViewModel
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
                fav.clear()
            }
            .font(.subheadline)
            .foregroundColor(.red)
        }
    }
}

struct FavoritePlaylistList: View {
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var vm: VocabularyViewModel
    @EnvironmentObject var auth: AuthViewModel
    
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
                            .environmentObject(auth)
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
                            Task {
                                guard let userId = auth.currentUser?.ID else { return }
                                await fav.toggleFavorite(userId: userId, item: item)
                            }
                        } label: {
                            Image(systemName: fav.isPlaylistFavorite(item.value) ? "heart.fill" : "heart")
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
    @EnvironmentObject var auth: AuthViewModel
    
    let words: [FavoriteItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Word Favorite (\(words.count))")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(words) { item in
                NavigationLink {
                    let word = item.word ?? VocabWord(id: 0, word: item.value, meaningThai: "", examples: [])
                    WordDetailView(word: word)
                        .environmentObject(fav)
                        .environmentObject(auth)
                } label: {
                    ProfileWordRow(item: item)
                        .environmentObject(fav)
                        .environmentObject(auth)
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
    @EnvironmentObject var auth: AuthViewModel
    let item: FavoriteItem
    
    var body: some View {
        HStack {
            Text(item.value)
                .font(.body)
                .bold()
            
            Spacer()
            
            Button {
                Task {
                    guard let userId = auth.currentUser?.ID else { return }
                    await fav.toggleFavorite(userId: userId, item: item)
                }
            } label: {
                Image(systemName: fav.isWordFavorite(item.value) ? "heart.fill" : "heart")
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
