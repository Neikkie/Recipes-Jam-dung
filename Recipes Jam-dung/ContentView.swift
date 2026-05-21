import SwiftUI

// MARK: - Root

struct ContentView: View {
    @StateObject private var service = RecipeService()
    @EnvironmentObject var favoritesStore: FavoritesStore

    var body: some View {
        TabView {
            RecipeListTab(service: service)
                .tabItem { Label("Recipes", systemImage: "fork.knife") }

            FavoritesView(service: service)
                .tabItem { Label("Favourites", systemImage: "heart.fill") }
                .badge(favoritesStore.favorites.isEmpty ? 0 : favoritesStore.favorites.count)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(.green)
    }
}

// MARK: - Recipe List Tab

struct RecipeListTab: View {
    let service: RecipeService
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private let categories = ["Breakfast", "Lunch", "Dinner"]

    var filteredMeals: [Meal] {
        var meals = service.meals
        if !searchText.isEmpty {
            meals = meals.filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
        }
        if let category = selectedCategory {
            meals = meals.filter { $0.mealTimeCategory == category }
        }
        return meals
    }

    var categorizedMeals: [(category: String, meals: [Meal])] {
        let grouped = Dictionary(grouping: filteredMeals, by: { $0.mealTimeCategory })
        let activeCats = selectedCategory.map { [$0] } ?? categories
        return activeCats.compactMap { cat in
            guard let meals = grouped[cat], !meals.isEmpty else { return nil }
            return (category: cat, meals: meals)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                Group {
                    if service.isLoading {
                        loadingView
                    } else if let error = service.errorMessage {
                        errorView(message: error)
                    } else {
                        recipeContent
                    }
                }
            }
            .navigationTitle("Jam-dung")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 7) {
                        if let icon = UIImage(named: "AppIcon") {
                            Image(uiImage: icon)
                                .resizable()
                                .frame(width: 28, height: 28)
                                .cornerRadius(7)
                        }
                        Text("Jam-dung")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("🇯🇲")
                            .font(.subheadline)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search recipes...")
            .task { await service.fetchJamaicanRecipes() }
        }
    }

    // MARK: Filter Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", emoji: "🍴", isSelected: selectedCategory == nil) {
                    withAnimation(.spring(response: 0.3)) { selectedCategory = nil }
                }
                ForEach(categories, id: \.self) { cat in
                    FilterChip(title: cat, emoji: categoryEmoji(cat), isSelected: selectedCategory == cat) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = selectedCategory == cat ? nil : cat
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    // MARK: Recipe Content

    private var recipeContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                filterChips
                if filteredMeals.isEmpty {
                    emptySearch
                } else {
                    VStack(alignment: .leading, spacing: 28) {
                        ForEach(categorizedMeals, id: \.category) { section in
                            VStack(alignment: .leading, spacing: 12) {
                                sectionHeader(category: section.category)
                                LazyVGrid(columns: columns, spacing: 14) {
                                    ForEach(section.meals) { meal in
                                        NavigationLink(destination: RecipeDetailView(meal: meal, service: service)) {
                                            RecipeCardView(meal: meal)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }

    // MARK: Section Header

    private func sectionHeader(category: String) -> some View {
        HStack(spacing: 10) {
            Text(categoryEmoji(category)).font(.title2)
            VStack(alignment: .leading, spacing: 3) {
                Text(category).font(.title2).fontWeight(.bold)
                Capsule().fill(categoryColor(category)).frame(width: 32, height: 3)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: Empty / Loading / Error

    private var emptySearch: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 56))
                .foregroundColor(.secondary.opacity(0.5))
            Text("No recipes found")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    private var loadingView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { _ in
                        SkeletonView().frame(width: 80, height: 36).cornerRadius(20)
                    }
                }
                .padding(.horizontal, 16).padding(.vertical, 8)

                VStack(alignment: .leading, spacing: 28) {
                    ForEach(0..<3, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 12) {
                            SkeletonView().frame(width: 130, height: 26).cornerRadius(6).padding(.horizontal, 16)
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(0..<4, id: \.self) { _ in
                                    SkeletonView().frame(height: 180).cornerRadius(16)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 56)).foregroundStyle(.orange)
            Text("Couldn't load recipes").font(.title3).fontWeight(.semibold)
            Text(message).font(.subheadline).foregroundColor(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 32)
            Button {
                Task { await service.fetchJamaicanRecipes() }
            } label: {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.green).foregroundColor(.white).cornerRadius(14)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Helpers

    func categoryEmoji(_ category: String) -> String {
        switch category {
        case "Breakfast": return "☀️"
        case "Lunch":     return "🍽️"
        case "Dinner":    return "🌙"
        default:          return "🍴"
        }
    }

    func categoryColor(_ category: String) -> Color {
        switch category {
        case "Breakfast": return .orange
        case "Lunch":     return .green
        case "Dinner":    return .indigo
        default:          return .primary
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(emoji)
                Text(title).fontWeight(.semibold)
            }
            .font(.subheadline)
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(isSelected ? Color.green : Color(.secondarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            .shadow(color: isSelected ? Color.green.opacity(0.35) : .clear, radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Skeleton View

struct SkeletonView: View {
    @State private var animating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [Color.secondary.opacity(0.1), Color.secondary.opacity(0.22), Color.secondary.opacity(0.1)],
                    startPoint: animating ? .topLeading : .bottomTrailing,
                    endPoint: animating ? .bottomTrailing : .topLeading
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: true)) {
                    animating = true
                }
            }
    }
}

// MARK: - Recipe Card

struct RecipeCardView: View {
    let meal: Meal
    @EnvironmentObject var favoritesStore: FavoritesStore

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CachedImageView(url: meal.thumbnailURL)
                .frame(height: 180)
                .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.72)], startPoint: .center, endPoint: .bottom)

            if favoritesStore.isFavorite(meal) {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(7)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .padding(8)
                    }
                    Spacer()
                }
            }

            Text(meal.strMeal)
                .font(.subheadline).fontWeight(.bold)
                .foregroundColor(.white).lineLimit(2)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                .padding(10)
        }
        .frame(height: 180)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesStore())
}
