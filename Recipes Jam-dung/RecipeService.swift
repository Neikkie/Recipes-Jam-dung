import Foundation
import Combine

@MainActor
class RecipeService: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Full details keyed by meal ID, populated from local JSON
    private var localDetails: [String: MealDetail] = [:]

    init() {
        loadFromBundle()
    }

    // MARK: - Bundle Load (instant, no network)

    private func loadFromBundle() {
        guard
            let url = Bundle.main.url(forResource: "jamaican_recipes", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let response = try? JSONDecoder().decode(MealDetailResponse.self, from: data),
            let details = response.meals
        else { return }

        for detail in details {
            localDetails[detail.idMeal] = detail
        }

        meals = details.map {
            Meal(idMeal: $0.idMeal, strMeal: $0.strMeal, strMealThumb: $0.strMealThumb ?? "")
        }
    }

    // MARK: - Public API

    func fetchJamaicanRecipes() async {
        // Data already loaded from bundle — nothing to do
        guard meals.isEmpty else { return }

        // Only reaches here if the bundle file failed to load
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?a=Jamaican") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            meals = try JSONDecoder().decode(MealListResponse.self, from: data).meals
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchMealDetail(id: String) async -> MealDetail? {
        // Serve from local bundle instantly
        if let local = localDetails[id] { return local }

        // Fallback to network if somehow missing
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return nil }
        return try? await JSONDecoder().decode(
            MealDetailResponse.self,
            from: URLSession.shared.data(from: url).0
        ).meals?.first
    }
}
