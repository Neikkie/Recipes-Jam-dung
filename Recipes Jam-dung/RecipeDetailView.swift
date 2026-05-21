import SwiftUI

struct RecipeDetailView: View {
    let meal: Meal
    let service: RecipeService
    @EnvironmentObject var favoritesStore: FavoritesStore

    @State private var detail: MealDetail?
    @State private var isLoading = true
    @State private var selectedTab = 0

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                heroSection
                contentSection
                    .padding(.top, -22)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                heartButton
            }
        }
        .task {
            detail = await service.fetchMealDetail(id: meal.idMeal)
            isLoading = false
        }
    }

    // MARK: - Heart Button

    private var heartButton: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                favoritesStore.toggle(meal)
            }
        } label: {
            Image(systemName: favoritesStore.isFavorite(meal) ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundColor(favoritesStore.isFavorite(meal) ? .red : .white)
                .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 1)
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            CachedImageView(url: meal.thumbnailURL)
                .frame(height: 340)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 340)

            VStack(alignment: .leading, spacing: 8) {
                if let category = detail?.strCategory {
                    Text(category.uppercased())
                        .font(.caption).fontWeight(.bold)
                        .foregroundColor(.yellow).tracking(1.5)
                }
                Text(meal.strMeal)
                    .font(.title2).fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 38)
        }
        .frame(height: 340)
    }

    // MARK: - Content Card

    private var contentSection: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 10).padding(.bottom, 8)

            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading recipe...")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
            } else if let detail {
                Picker("", selection: $selectedTab) {
                    Text("Ingredients").tag(0)
                    Text("Instructions").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16).padding(.bottom, 16)

                if selectedTab == 0 {
                    ingredientsSection(detail: detail)
                } else {
                    instructionsSection(detail: detail)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    // MARK: - Ingredients

    private func ingredientsSection(detail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(detail.ingredients.enumerated()), id: \.offset) { index, item in
                HStack(spacing: 14) {
                    Text("\(index + 1)")
                        .font(.caption).fontWeight(.bold).foregroundColor(.white)
                        .frame(width: 26, height: 26)
                        .background(Color.green).clipShape(Circle())
                    Text(item.ingredient).fontWeight(.medium)
                    Spacer()
                    Text(item.measure).foregroundColor(.secondary).font(.subheadline)
                }
                .padding(.horizontal, 20).padding(.vertical, 12)
                if index < detail.ingredients.count - 1 {
                    Divider().padding(.leading, 60)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal, 16).padding(.bottom, 32)
    }

    // MARK: - Instructions

    private func instructionsSection(detail: MealDetail) -> some View {
        let steps = parseSteps(detail.strInstructions ?? "")
        return VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 14) {
                    Text("\(index + 1)")
                        .font(.caption).fontWeight(.bold).foregroundColor(.white)
                        .frame(width: 26, height: 26)
                        .background(Color.indigo).clipShape(Circle())
                        .padding(.top, 2)
                    Text(step).font(.body).lineSpacing(5)
                }
                .padding(.horizontal, 20).padding(.vertical, 12)
                if index < steps.count - 1 {
                    Divider().padding(.leading, 60)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal, 16).padding(.bottom, 32)
    }

    private func parseSteps(_ instructions: String) -> [String] {
        instructions
            .components(separatedBy: CharacterSet.newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
