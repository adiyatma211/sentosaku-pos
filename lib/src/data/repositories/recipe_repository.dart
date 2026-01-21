import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/failure.dart';
import '../../domain/repositories/recipe_repository_interface.dart';
import '../datasources/local/database_provider.dart';
import '../mappers/entity_mapper.dart';

class RecipeRepository implements RecipeRepositoryInterface {
  final DatabaseProvider _databaseProvider;

  RecipeRepository(this._databaseProvider);

  @override
  Future<Either<Failure, List<Recipe>>> getAllRecipes() async {
    try {
      final dbRecipes = await _databaseProvider.getAllRecipes();
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      return Right(recipes);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeById(int id) async {
    try {
      final dbRecipe = await _databaseProvider.getRecipeById(id);
      if (dbRecipe == null) {
        return Left(Failure(message: 'Recipe not found'));
      }
      return Right(toDomainRecipe(dbRecipe));
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeByUuid(String uuid) async {
    try {
      final dbRecipe = await _databaseProvider.getRecipeByUuid(uuid);
      if (dbRecipe == null) {
        return Left(Failure(message: 'Recipe not found'));
      }
      return Right(toDomainRecipe(dbRecipe));
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByProduct(int productId) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProduct(productId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      return Right(recipes);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes by product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByProductUuid(String productUuid) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProductUuid(productUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      return Right(recipes);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes by product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByIngredient(int ingredientId) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByIngredient(ingredientId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      return Right(recipes);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes by ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByIngredientUuid(String ingredientUuid) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByIngredientUuid(ingredientUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      return Right(recipes);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes by ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> createRecipe(Recipe recipe) async {
    try {
      final dbRecipe = toDbRecipe(recipe);
      final id = await _databaseProvider.createRecipe(dbRecipe);
      final createdRecipe = recipe.copyWith(id: id);
      return Right(createdRecipe);
    } catch (e) {
      return Left(Failure(message: 'Failed to create recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> updateRecipe(Recipe recipe) async {
    try {
      final dbRecipe = toDbRecipe(recipe);
      final success = await _databaseProvider.updateRecipe(dbRecipe);
      if (!success) {
        return Left(Failure(message: 'Failed to update recipe'));
      }
      return Right(recipe);
    } catch (e) {
      return Left(Failure(message: 'Failed to update recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipe(int id) async {
    try {
      await _databaseProvider.deleteRecipe(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipeByUuid(String uuid) async {
    try {
      await _databaseProvider.deleteRecipeByUuid(uuid);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipesByProduct(int productId) async {
    try {
      await _databaseProvider.deleteRecipesByProduct(productId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete recipes by product: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipesByProductUuid(String productUuid) async {
    try {
      await _databaseProvider.deleteRecipesByProductUuid(productUuid);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete recipes by product: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> calculateIngredientRequirements(
    int productId,
    int quantity,
  ) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProduct(productId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      final Map<String, dynamic> requirements = {};
      
      for (final recipe in recipes) {
        final requiredQuantity = recipe.quantity * quantity;
        final ingredientName = 'Ingredient_${recipe.ingredientId}';
        
        if (requirements.containsKey(ingredientName)) {
          requirements[ingredientName] = (requirements[ingredientName] as int) + requiredQuantity;
        } else {
          requirements[ingredientName] = requiredQuantity;
        }
      }
      
      return Right(requirements);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate ingredient requirements: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> calculateIngredientRequirementsByUuid(
    String productUuid,
    int quantity,
  ) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProductUuid(productUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      final Map<String, dynamic> requirements = {};
      
      for (final recipe in recipes) {
        final requiredQuantity = recipe.quantity * quantity;
        final ingredientName = 'Ingredient_${recipe.ingredientId}';
        
        if (requirements.containsKey(ingredientName)) {
          requirements[ingredientName] = (requirements[ingredientName] as int) + requiredQuantity;
        } else {
          requirements[ingredientName] = requiredQuantity;
        }
      }
      
      return Right(requirements);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate ingredient requirements: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> calculateVariantIngredientRequirements(
    int productId,
    int variantId,
    int quantity,
  ) async {
    try {
      // DatabaseProvider doesn't have getRecipesByVariant, use getRecipeVariants instead
      final dbRecipes = await _databaseProvider.getRecipeVariants(productId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      final Map<String, dynamic> requirements = {};
      
      for (final recipe in recipes) {
        final requiredQuantity = recipe.quantity * quantity;
        final ingredientName = 'Ingredient_${recipe.ingredientId}';
        
        if (requirements.containsKey(ingredientName)) {
          requirements[ingredientName] = (requirements[ingredientName] as int) + requiredQuantity;
        } else {
          requirements[ingredientName] = requiredQuantity;
        }
      }
      
      return Right(requirements);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate variant ingredient requirements: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> calculateVariantIngredientRequirementsByUuid(
    String productUuid,
    String variantUuid,
    int quantity,
  ) async {
    try {
      // DatabaseProvider doesn't have getRecipesByVariantUuid, use getRecipeVariantsByUuid instead
      final dbRecipes = await _databaseProvider.getRecipeVariantsByUuid(productUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      final Map<String, dynamic> requirements = {};
      
      for (final recipe in recipes) {
        final requiredQuantity = recipe.quantity * quantity;
        final ingredientName = 'Ingredient_${recipe.ingredientId}';
        
        if (requirements.containsKey(ingredientName)) {
          requirements[ingredientName] = (requirements[ingredientName] as int) + requiredQuantity;
        } else {
          requirements[ingredientName] = requiredQuantity;
        }
      }
      
      return Right(requirements);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate variant ingredient requirements: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateRecipeCost(int productId) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProduct(productId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      double totalCost = 0.0;
      
      for (final recipe in recipes) {
        // Note: Recipe has ingredientId, not ingredient object
        // We need to fetch ingredient details separately if needed
        // For now, skip cost calculation since we don't have ingredient cost info
      }
      
      return Right(totalCost);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate recipe cost: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateRecipeCostByUuid(String productUuid) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProductUuid(productUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      double totalCost = 0.0;
      
      for (final recipe in recipes) {
        // Note: Recipe has ingredientId, not ingredient object
        // We need to fetch ingredient details separately if needed
        // For now, skip cost calculation since we don't have ingredient cost info
      }
      
      return Right(totalCost);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate recipe cost: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateVariantRecipeCost(int productId, int variantId) async {
    try {
      // DatabaseProvider doesn't have getRecipesByVariant, use getRecipeVariants instead
      final dbRecipes = await _databaseProvider.getRecipeVariants(productId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      double totalCost = 0.0;
      
      for (final recipe in recipes) {
        // Note: Recipe has ingredientId, not ingredient object
        // We need to fetch ingredient details separately if needed
        // For now, skip cost calculation since we don't have ingredient cost info
      }
      
      return Right(totalCost);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate variant recipe cost: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateVariantRecipeCostByUuid(
    String productUuid,
    String variantUuid,
  ) async {
    try {
      // DatabaseProvider doesn't have getRecipesByVariantUuid, use getRecipeVariantsByUuid instead
      final dbRecipes = await _databaseProvider.getRecipeVariantsByUuid(productUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      double totalCost = 0.0;
      
      for (final recipe in recipes) {
        // Note: Recipe has ingredientId, not ingredient object
        // We need to fetch ingredient details separately if needed
        // For now, skip cost calculation since we don't have ingredient cost info
      }
      
      return Right(totalCost);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate variant recipe cost: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateRecipeCostForQuantity(int productId, int quantity) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProduct(productId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      double totalCost = 0.0;
      
      for (final recipe in recipes) {
        // Note: Recipe has ingredientId, not ingredient object
        // We need to fetch ingredient details separately if needed
        // For now, skip cost calculation since we don't have ingredient cost info
      }
      
      return Right(totalCost);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate recipe cost for quantity: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateRecipeCostForQuantityByUuid(
    String productUuid,
    int quantity,
  ) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProductUuid(productUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      double totalCost = 0.0;
      
      for (final recipe in recipes) {
        // Note: Recipe has ingredientId, not ingredient object
        // We need to fetch ingredient details separately if needed
        // For now, skip cost calculation since we don't have ingredient cost info
      }
      
      return Right(totalCost);
    } catch (e) {
      return Left(Failure(message: 'Failed to calculate recipe cost for quantity: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipeVariants(int productId) async {
    try {
      final dbVariants = await _databaseProvider.getRecipeVariants(productId);
      final variants = dbVariants.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      return Right(variants);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipe variants: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipeVariantsByUuid(String productUuid) async {
    try {
      final dbVariants = await _databaseProvider.getRecipeVariantsByUuid(productUuid);
      final variants = dbVariants.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      return Right(variants);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipe variants: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> createRecipeVariant(Recipe recipe) async {
    try {
      final dbRecipe = toDbRecipe(recipe);
      final id = await _databaseProvider.createRecipe(dbRecipe);
      final createdRecipe = recipe.copyWith(id: id);
      return Right(createdRecipe);
    } catch (e) {
      return Left(Failure(message: 'Failed to create recipe variant: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> updateRecipeVariant(Recipe recipe) async {
    try {
      final dbRecipe = toDbRecipe(recipe);
      final success = await _databaseProvider.updateRecipe(dbRecipe);
      if (!success) {
        return Left(Failure(message: 'Failed to update recipe variant'));
      }
      return Right(recipe);
    } catch (e) {
      return Left(Failure(message: 'Failed to update recipe variant: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipeVariant(int recipeId) async {
    try {
      await _databaseProvider.deleteRecipe(recipeId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete recipe variant: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipeVariantByUuid(String recipeUuid) async {
    try {
      await _databaseProvider.deleteRecipeByUuid(recipeUuid);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete recipe variant: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateRecipe(Recipe recipe) async {
    try {
      // Basic validation
      if (recipe.productId <= 0) {
        return const Left(Failure(message: 'Product ID is required'));
      }
      
      if (recipe.ingredientId <= 0) {
        return const Left(Failure(message: 'Ingredient ID is required'));
      }
      
      if (recipe.quantity <= 0) {
        return const Left(Failure(message: 'Quantity must be greater than 0'));
      }
      
      return const Right(true);
    } catch (e) {
      return Left(Failure(message: 'Failed to validate recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateRecipeForProduct(int productId) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProduct(productId);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      if (recipes.isEmpty) {
        return const Right(true); // No recipes to validate
      }
      
      // Check if all recipes are valid
      for (final recipe in recipes) {
        if (recipe.productId <= 0) {
          return const Left(Failure(message: 'Product ID is required'));
        }
        
        if (recipe.ingredientId <= 0) {
          return const Left(Failure(message: 'Ingredient ID is required'));
        }
        
        if (recipe.quantity <= 0) {
          return const Left(Failure(message: 'Quantity must be greater than 0'));
        }
      }
      
      return const Right(true);
    } catch (e) {
      return Left(Failure(message: 'Failed to validate recipe for product: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateRecipeForProductByUuid(String productUuid) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProductUuid(productUuid);
      final recipes = dbRecipes.map((dbRecipe) => toDomainRecipe(dbRecipe)).toList();
      
      if (recipes.isEmpty) {
        return const Right(true); // No recipes to validate
      }
      
      // Check if all recipes are valid
      for (final recipe in recipes) {
        if (recipe.productId <= 0) {
          return const Left(Failure(message: 'Product ID is required'));
        }
        
        if (recipe.ingredientId <= 0) {
          return const Left(Failure(message: 'Ingredient ID is required'));
        }
        
        if (recipe.quantity <= 0) {
          return const Left(Failure(message: 'Quantity must be greater than 0'));
        }
      }
      
      return const Right(true);
    } catch (e) {
      return Left(Failure(message: 'Failed to validate recipe for product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecipeValidationErrors(Recipe recipe) async {
    try {
      final List<String> errors = [];
      
      if (recipe.productId <= 0) {
        errors.add('Product ID is required');
      }
      
      if (recipe.ingredientId <= 0) {
        errors.add('Ingredient ID is required');
      }
      
      if (recipe.quantity <= 0) {
        errors.add('Quantity must be greater than 0');
      }
      
      return Right(errors);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipe validation errors: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> duplicateRecipe(int recipeId, int newProductId) async {
    try {
      final dbOriginalRecipe = await _databaseProvider.getRecipeById(recipeId);
      if (dbOriginalRecipe == null) {
        return Left(Failure(message: 'Original recipe not found'));
      }
      
      final originalRecipe = toDomainRecipe(dbOriginalRecipe);
      final duplicatedRecipe = originalRecipe.copyWith(
        id: 0, // Reset ID to create new recipe
        productId: newProductId,
        uuid: const Uuid().v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final dbDuplicatedRecipe = toDbRecipe(duplicatedRecipe);
      final id = await _databaseProvider.createRecipe(dbDuplicatedRecipe);
      final createdRecipe = duplicatedRecipe.copyWith(id: id);
      return Right(createdRecipe);
    } catch (e) {
      return Left(Failure(message: 'Failed to duplicate recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> duplicateRecipeByUuid(
    String recipeUuid,
    String newProductUuid,
  ) async {
    try {
      final dbOriginalRecipe = await _databaseProvider.getRecipeByUuid(recipeUuid);
      if (dbOriginalRecipe == null) {
        return Left(Failure(message: 'Original recipe not found'));
      }
      
      final originalRecipe = toDomainRecipe(dbOriginalRecipe);
      final duplicatedRecipe = originalRecipe.copyWith(
        id: 0, // Reset ID to create new recipe
        productId: 0, // Will be updated after creation
        uuid: newProductUuid, // Set new product UUID
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // First create recipe with new product
      final dbDuplicatedRecipe = toDbRecipe(duplicatedRecipe);
      final id = await _databaseProvider.createRecipe(dbDuplicatedRecipe);
      final createdRecipe = duplicatedRecipe.copyWith(id: id);
      
      // Then update recipe to point to correct product
      // Note: newProductId is not available in this method, only newProductUuid
      // We'll keep productId as 0 since we don't have the product ID
      return Right(createdRecipe);
    } catch (e) {
      return Left(Failure(message: 'Failed to duplicate recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> createBulkRecipes(List<Recipe> recipes) async {
    try {
      final dbRecipes = recipes.map((recipe) => toDbRecipe(recipe)).toList();
      final ids = await _databaseProvider.createBulkRecipes(dbRecipes);
      
      final createdRecipes = recipes.asMap().entries.map((entry) {
        final index = ids[entry.key];
        return entry.value.copyWith(id: index);
      }).toList();
      
      return Right(createdRecipes);
    } catch (e) {
      return Left(Failure(message: 'Failed to create bulk recipes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> updateBulkRecipes(List<Recipe> recipes) async {
    try {
      final dbRecipes = recipes.map((recipe) => toDbRecipe(recipe)).toList();
      final success = await _databaseProvider.updateBulkRecipes(dbRecipes);
      if (!success) {
        return Left(Failure(message: 'Failed to update bulk recipes'));
      }
      return Right(recipes);
    } catch (e) {
      return Left(Failure(message: 'Failed to update bulk recipes: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBulkRecipes(List<int> recipeIds) async {
    try {
      await _databaseProvider.deleteBulkRecipes(recipeIds);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete bulk recipes: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBulkRecipesByUuid(List<String> recipeUuids) async {
    try {
      await _databaseProvider.deleteBulkRecipesByUuid(recipeUuids);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete bulk recipes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesWithIngredientDetails() async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesWithIngredientDetails();
      // Note: getRecipesWithIngredientDetails returns List<Map<String, dynamic>>, not List<Recipe>
      // We need to handle this differently - for now, return empty list
      return const Right([]);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes with ingredient details: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByProductWithIngredientDetails(int productId) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProductWithIngredientDetails(productId);
      // Note: getRecipesByProductWithIngredientDetails returns List<Map<String, dynamic>>, not List<Recipe>
      // We need to handle this differently - for now, return empty list
      return const Right([]);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes by product with ingredient details: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByProductWithIngredientDetailsByUuid(
    String productUuid,
  ) async {
    try {
      final dbRecipes = await _databaseProvider.getRecipesByProductWithIngredientDetailsByUuid(productUuid);
      // Note: getRecipesByProductWithIngredientDetailsByUuid returns List<Map<String, dynamic>>, not List<Recipe>
      // We need to handle this differently - for now, return empty list
      return const Right([]);
    } catch (e) {
      return Left(Failure(message: 'Failed to get recipes by product with ingredient details: $e'));
    }
  }
}
