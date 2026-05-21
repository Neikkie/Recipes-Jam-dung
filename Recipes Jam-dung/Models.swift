import Foundation

struct MealListResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String

    var id: String { idMeal }
    var thumbnailURL: URL? { URL(string: strMealThumb) }

    var mealTimeCategory: String {
        let n = strMeal.lowercased()
        let breakfastKeywords = ["porridge", "fritter", "saltfish", "callaloo", "ackee"]
        if breakfastKeywords.contains(where: { n.contains($0) }) { return "Breakfast" }
        if n.contains("dumpling") && !n.contains("festival") { return "Breakfast" }
        let lunchKeywords = ["patty", "patties", "soup", "festival", "spice bun", "tamarind", "pepper shrimp", "steamed"]
        if lunchKeywords.contains(where: { n.contains($0) }) { return "Lunch" }
        return "Dinner"
    }
}

struct MealDetailResponse: Codable {
    let meals: [MealDetail]?
}

struct MealDetail: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    let strYoutube: String?
    let strSource: String?

    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?

    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?

    var id: String { idMeal }

    var thumbnailURL: URL? {
        guard let thumb = strMealThumb else { return nil }
        return URL(string: thumb)
    }

    var youtubeURL: URL? {
        guard let youtube = strYoutube, !youtube.isEmpty else { return nil }
        return URL(string: youtube)
    }

    var ingredients: [(ingredient: String, measure: String)] {
        let pairs: [(String?, String?)] = [
            (strIngredient1, strMeasure1), (strIngredient2, strMeasure2),
            (strIngredient3, strMeasure3), (strIngredient4, strMeasure4),
            (strIngredient5, strMeasure5), (strIngredient6, strMeasure6),
            (strIngredient7, strMeasure7), (strIngredient8, strMeasure8),
            (strIngredient9, strMeasure9), (strIngredient10, strMeasure10),
            (strIngredient11, strMeasure11), (strIngredient12, strMeasure12),
            (strIngredient13, strMeasure13), (strIngredient14, strMeasure14),
            (strIngredient15, strMeasure15), (strIngredient16, strMeasure16),
            (strIngredient17, strMeasure17), (strIngredient18, strMeasure18),
            (strIngredient19, strMeasure19), (strIngredient20, strMeasure20),
        ]
        return pairs.compactMap { ingredient, measure in
            guard let ingredient = ingredient, !ingredient.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
            return (ingredient: ingredient, measure: measure?.trimmingCharacters(in: .whitespaces) ?? "")
        }
    }
}
