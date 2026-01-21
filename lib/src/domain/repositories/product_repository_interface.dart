import '../entities/ingredient.dart';
import '../entities/product.dart';

abstract class ProductRepositoryInterface {
  // Product CRUD operations
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getActiveProducts();
  Future<List<Product>> getProductsByCategory(int categoryId);
  Future<Product?> getProductById(int id);
  Future<Product?> getProductByUuid(String uuid);
  Future<Product?> getProductBySku(String sku);
  Future<Product?> getProductByBarcode(String barcode);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<bool> deleteProduct(int id);
  Future<bool> softDeleteProduct(int id);
  
  // Product stock operations
  Future<bool> updateProductStock(int productId, int quantity);
  Future<bool> adjustProductStock(int productId, int adjustment, String reason);
  Future<List<Product>> getLowStockProducts();
  Future<List<Product>> getOutOfStockProducts();
  
  // Variant operations
  Future<List<Variant>> getAllVariants();
  Future<List<Variant>> getVariantsByProduct(int productId);
  Future<Variant?> getVariantById(int id);
  Future<Variant?> getVariantByUuid(String uuid);
  Future<Variant> createVariant(Variant variant);
  Future<Variant> updateVariant(Variant variant);
  Future<bool> deleteVariant(int id);
  Future<bool> softDeleteVariant(int id);
  
  // Variant stock operations
  Future<bool> updateVariantStock(int variantId, int quantity);
  Future<bool> adjustVariantStock(int variantId, int adjustment, String reason);
  
  // Ingredient operations
  Future<List<Ingredient>> getAllIngredients();
  Future<List<Ingredient>> getActiveIngredients();
  Future<Ingredient?> getIngredientById(int id);
  Future<Ingredient?> getIngredientByUuid(String uuid);
  Future<Ingredient> createIngredient(Ingredient ingredient);
  Future<Ingredient> updateIngredient(Ingredient ingredient);
  Future<bool> deleteIngredient(int id);
  Future<bool> softDeleteIngredient(int id);
  
  // Recipe operations
  Future<List<Recipe>> getAllRecipes();
  Future<List<Recipe>> getRecipesByProduct(int productId);
  Future<Recipe?> getRecipeById(int id);
  Future<Recipe?> getRecipeByUuid(String uuid);
  Future<Recipe> createRecipe(Recipe recipe);
  Future<Recipe> updateRecipe(Recipe recipe);
  Future<bool> deleteRecipe(int id);
  Future<bool> softDeleteRecipe(int id);
  
  // Search operations
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> searchProductsByCategory(int categoryId, String query);
}