import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../entities/failure.dart';

abstract class RecipeRepositoryInterface {
  // Recipe operations
  Future<Either<Failure, List<Recipe>>> getAllRecipes();
  Future<Either<Failure, Recipe>> getRecipeById(int id);
  Future<Either<Failure, Recipe>> getRecipeByUuid(String uuid);
  Future<Either<Failure, List<Recipe>>> getRecipesByProduct(int productId);
  Future<Either<Failure, List<Recipe>>> getRecipesByProductUuid(String productUuid);
  Future<Either<Failure, List<Recipe>>> getRecipesByIngredient(int ingredientId);
  Future<Either<Failure, List<Recipe>>> getRecipesByIngredientUuid(String ingredientUuid);
  Future<Either<Failure, Recipe>> createRecipe(Recipe recipe);
  Future<Either<Failure, Recipe>> updateRecipe(Recipe recipe);
  Future<Either<Failure, void>> deleteRecipe(int id);
  Future<Either<Failure, void>> deleteRecipeByUuid(String uuid);
  Future<Either<Failure, void>> deleteRecipesByProduct(int productId);
  Future<Either<Failure, void>> deleteRecipesByProductUuid(String productUuid);

  // Recipe resolution operations
  Future<Either<Failure, Map<String, dynamic>>> calculateIngredientRequirements(
    int productId,
    int quantity,
  );
  Future<Either<Failure, Map<String, dynamic>>> calculateIngredientRequirementsByUuid(
    String productUuid,
    int quantity,
  );
  Future<Either<Failure, Map<String, dynamic>>> calculateVariantIngredientRequirements(
    int productId,
    int variantId,
    int quantity,
  );
  Future<Either<Failure, Map<String, dynamic>>> calculateVariantIngredientRequirementsByUuid(
    String productUuid,
    String variantUuid,
    int quantity,
  );

  // Recipe cost calculation
  Future<Either<Failure, double>> calculateRecipeCost(int productId);
  Future<Either<Failure, double>> calculateRecipeCostByUuid(String productUuid);
  Future<Either<Failure, double>> calculateVariantRecipeCost(int productId, int variantId);
  Future<Either<Failure, double>> calculateVariantRecipeCostByUuid(
    String productUuid,
    String variantUuid,
  );
  Future<Either<Failure, double>> calculateRecipeCostForQuantity(int productId, int quantity);
  Future<Either<Failure, double>> calculateRecipeCostForQuantityByUuid(
    String productUuid,
    int quantity,
  );

  // Recipe variant support
  Future<Either<Failure, List<Recipe>>> getRecipeVariants(int productId);
  Future<Either<Failure, List<Recipe>>> getRecipeVariantsByUuid(String productUuid);
  Future<Either<Failure, Recipe>> createRecipeVariant(Recipe recipe);
  Future<Either<Failure, Recipe>> updateRecipeVariant(Recipe recipe);
  Future<Either<Failure, void>> deleteRecipeVariant(int recipeId);
  Future<Either<Failure, void>> deleteRecipeVariantByUuid(String recipeUuid);

  // Recipe validation
  Future<Either<Failure, bool>> validateRecipe(Recipe recipe);
  Future<Either<Failure, bool>> validateRecipeForProduct(int productId);
  Future<Either<Failure, bool>> validateRecipeForProductByUuid(String productUuid);
  Future<Either<Failure, List<String>>> getRecipeValidationErrors(Recipe recipe);

  // Recipe duplication
  Future<Either<Failure, Recipe>> duplicateRecipe(int recipeId, int newProductId);
  Future<Either<Failure, Recipe>> duplicateRecipeByUuid(
    String recipeUuid,
    String newProductUuid,
  );

  // Recipe batch operations
  Future<Either<Failure, List<Recipe>>> createBulkRecipes(List<Recipe> recipes);
  Future<Either<Failure, List<Recipe>>> updateBulkRecipes(List<Recipe> recipes);
  Future<Either<Failure, void>> deleteBulkRecipes(List<int> recipeIds);
  Future<Either<Failure, void>> deleteBulkRecipesByUuid(List<String> recipeUuids);

  // Recipe with ingredient details
  Future<Either<Failure, List<Recipe>>> getRecipesWithIngredientDetails();
  Future<Either<Failure, List<Recipe>>> getRecipesByProductWithIngredientDetails(int productId);
  Future<Either<Failure, List<Recipe>>> getRecipesByProductWithIngredientDetailsByUuid(
    String productUuid,
  );
}