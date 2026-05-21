import SwiftUI

struct FavoritesView: View {
    let service: RecipeService
    @EnvironmentObject var favoritesStore: FavoritesStore

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                if favoritesStore.favorites.isEmpty {
                    emptyState
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(favoritesStore.favorites) { meal in
                                NavigationLink(destination: RecipeDetailView(meal: meal, service: service)) {
                                    RecipeCardView(meal: meal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Favourites ❤️")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary.opacity(0.4))
            Text("No favourites yet")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Tap the heart on any recipe\nto save it here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
