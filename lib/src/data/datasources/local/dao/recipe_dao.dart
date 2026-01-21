import 'package:drift/drift.dart';
import '../app_database.dart';

part 'recipe_dao.g.dart';

@DriftAccessor(tables: [Recipes, Ingredients])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  // Get all recipes for a specific product
  Future<List<Recipe>> getRecipesByProductId(int productId) {
    return (select(recipes)
          ..where((tbl) => tbl.productId.equals(productId))
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
  }

  // Get recipes with ingredient details for a product
  Future<List<Map<String, dynamic>>> getRecipesWithIngredients(int productId) async {
    final query = select(recipes).join([
      innerJoin(ingredients, ingredients.id.equalsExp(recipes.ingredientId)),
    ]);
    query.where(recipes.productId.equals(productId));
    query.where(recipes.isDeleted.equals(false));
    query.where(ingredients.isActive.equals(true));
    
    final results = await query.get();
    return results.map((result) {
      final recipe = result.readTable(recipes);
      final ingredient = result.readTable(ingredients);
      return {
        'recipe': recipe,
        'ingredient': ingredient,
      };
    }).toList();
  }

  // Get recipe by ID
  Future<Recipe?> getRecipeById(int id) {
    return (select(recipes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Create a new recipe
  Future<int> createRecipe(RecipesCompanion recipe) {
    return into(recipes).insert(recipe);
  }

  // Update a recipe
  Future<bool> updateRecipe(Recipe recipe) {
    return update(recipes).replace(recipe);
  }

  // Delete a recipe (soft delete)
  Future<int> deleteRecipe(int id) {
    return (update(recipes)..where((tbl) => tbl.id.equals(id)))
        .write(RecipesCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
  }

  // Delete all recipes for a product
  Future<int> deleteRecipesByProductId(int productId) {
    return (update(recipes)..where((tbl) => tbl.productId.equals(productId)))
        .write(RecipesCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
  }

  // Batch create recipes for a product
  Future<void> createBulkRecipes(List<RecipesCompanion> recipes) {
    return batch((batch) => batch.insertAll(this.recipes, recipes));
  }
}
