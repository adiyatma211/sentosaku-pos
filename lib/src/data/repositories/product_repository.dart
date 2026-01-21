import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../datasources/local/app_database.dart' as db;
import '../../domain/entities/ingredient.dart' as ingredient_entity;
import '../../domain/entities/product.dart' as entity;
import '../../domain/repositories/product_repository_interface.dart';

class ProductRepository implements ProductRepositoryInterface {
  final db.AppDatabase _database;
  
  ProductRepository(this._database);
  
  // Product CRUD operations
  @override
  Future<List<entity.Product>> getAllProducts() async {
    final products = await (_database.select(_database.products)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    
    return products.map(_mapProductToEntity).toList();
  }
  
  @override
  Future<List<entity.Product>> getActiveProducts() async {
    final products = await (_database.select(_database.products)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true)))
        .get();
    
    return products.map(_mapProductToEntity).toList();
  }
  
  @override
  Future<List<entity.Product>> getProductsByCategory(int categoryId) async {
    final products = await (_database.select(_database.products)
          ..where((tbl) => tbl.isDeleted.equals(false) &
                           tbl.isActive.equals(true) &
                           tbl.categoryId.equals(categoryId)))
        .get();
    
    return products.map(_mapProductToEntity).toList();
  }
  
  @override
  Future<entity.Product?> getProductById(int id) async {
    final product = await (_database.select(_database.products)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return product != null ? _mapProductToEntity(product) : null;
  }
  
  @override
  Future<entity.Product?> getProductByUuid(String uuid) async {
    final product = await (_database.select(_database.products)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return product != null ? _mapProductToEntity(product) : null;
  }
  
  @override
  Future<entity.Product?> getProductBySku(String sku) async {
    final product = await (_database.select(_database.products)
          ..where((tbl) => tbl.sku.equals(sku) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return product != null ? _mapProductToEntity(product) : null;
  }
  
  @override
  Future<entity.Product?> getProductByBarcode(String barcode) async {
    final product = await (_database.select(_database.products)
          ..where((tbl) => tbl.barcode.equals(barcode) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return product != null ? _mapProductToEntity(product) : null;
  }
  
  @override
  Future<entity.Product> createProduct(entity.Product product) async {
    final productCompanion = db.ProductsCompanion.insert(
      uuid: product.uuid,
      sku: product.sku,
      barcode: Value(product.barcode),
      name: product.name,
      description: Value(product.description),
      categoryId: product.categoryId,
      price: product.price,
      cost: product.cost,
      stockQuantity: Value(product.stockQuantity),
      minStockLevel: Value(product.minStockLevel),
      maxStockLevel: Value(product.maxStockLevel),
      unit: Value(product.unit),
      image: Value(product.image),
      isActive: Value(product.isActive),
      isTrackStock: Value(product.isTrackStock),
    );
    
    final id = await _database.into(_database.products).insert(productCompanion);
    final insertedProduct = await getProductById(id);
    
    if (insertedProduct == null) {
      throw Exception('Failed to create product');
    }
    
    return insertedProduct;
  }
  
  @override
  Future<entity.Product> updateProduct(entity.Product product) async {
    final productCompanion = db.ProductsCompanion(
      uuid: Value(product.uuid),
      sku: Value(product.sku),
      barcode: Value(product.barcode),
      name: Value(product.name),
      description: Value(product.description),
      categoryId: Value(product.categoryId),
      price: Value(product.price),
      cost: Value(product.cost),
      stockQuantity: Value(product.stockQuantity),
      minStockLevel: Value(product.minStockLevel),
      maxStockLevel: Value(product.maxStockLevel),
      unit: Value(product.unit),
      image: Value(product.image),
      isActive: Value(product.isActive),
      isTrackStock: Value(product.isTrackStock),
      updatedAt: Value(DateTime.now()),
    );
    
    await _database.update(_database.products).replace(productCompanion);
    final updatedProduct = await getProductByUuid(product.uuid);
    
    if (updatedProduct == null) {
      throw Exception('Failed to update product');
    }
    
    return updatedProduct;
  }
  
  @override
  Future<bool> deleteProduct(int id) async {
    await (_database.delete(_database.products)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  @override
  Future<bool> softDeleteProduct(int id) async {
    await (_database.update(_database.products)
        ..where((tbl) => tbl.id.equals(id)))
        .write(db.ProductsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  // Product stock operations
  @override
  Future<bool> updateProductStock(int productId, int quantity) async {
    await (_database.update(_database.products)
        ..where((tbl) => tbl.id.equals(productId)))
        .write(db.ProductsCompanion(
          stockQuantity: Value(quantity),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  @override
  Future<bool> adjustProductStock(int productId, int adjustment, String reason) async {
    final product = await getProductById(productId);
    if (product == null) {
      throw Exception('Product not found');
    }
    
    final newQuantity = product.stockQuantity + adjustment;
    
    // Update product stock
    await updateProductStock(productId, newQuantity);
    
    // Create stock movement record
    await _database.into(_database.stockMovements).insert(
      db.StockMovementsCompanion.insert(
        uuid: Uuid().v4(),
        productId: productId,
        movementType: adjustment > 0 ? 'adjustment_in' : 'adjustment_out',
        quantity: adjustment.abs(),
        previousQuantity: product.stockQuantity,
        newQuantity: newQuantity,
        reason: Value(reason),
        referenceType: const Value('adjustment'),
      ),
    );
    
    return true;
  }
  
  @override
  Future<List<entity.Product>> getLowStockProducts() async {
    final allProducts = await (_database.select(_database.products)
          ..where((tbl) => tbl.isDeleted.equals(false) &
                           tbl.isActive.equals(true) &
                           tbl.isTrackStock.equals(true)))
        .get();
    
    final lowStockProducts = allProducts.where((product) =>
        product.stockQuantity <= product.minStockLevel).toList();
    
    return lowStockProducts.map(_mapProductToEntity).toList();
  }
  
  @override
  Future<List<entity.Product>> getOutOfStockProducts() async {
    final products = await (_database.select(_database.products)
          ..where((tbl) => tbl.isDeleted.equals(false) &
                           tbl.isActive.equals(true) &
                           tbl.isTrackStock.equals(true) &
                           tbl.stockQuantity.equals(0)))
        .get();
    
    return products.map(_mapProductToEntity).toList();
  }
  
  // Variant operations
  @override
  Future<List<entity.Variant>> getAllVariants() async {
    final variants = await (_database.select(_database.variants)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    
    return variants.map(_mapVariantToEntity).toList();
  }
  
  @override
  Future<List<entity.Variant>> getVariantsByProduct(int productId) async {
    final variants = await (_database.select(_database.variants)
          ..where((tbl) => tbl.isDeleted.equals(false) &
                           tbl.isActive.equals(true) &
                           tbl.productId.equals(productId)))
        .get();
    
    return variants.map(_mapVariantToEntity).toList();
  }
  
  @override
  Future<entity.Variant?> getVariantById(int id) async {
    final variant = await (_database.select(_database.variants)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return variant != null ? _mapVariantToEntity(variant) : null;
  }
  
  @override
  Future<entity.Variant?> getVariantByUuid(String uuid) async {
    final variant = await (_database.select(_database.variants)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return variant != null ? _mapVariantToEntity(variant) : null;
  }
  
  @override
  Future<entity.Variant> createVariant(entity.Variant variant) async {
    final variantCompanion = db.VariantsCompanion.insert(
      uuid: variant.uuid,
      productId: variant.productId,
      name: variant.name,
      sku: Value(variant.sku),
      barcode: Value(variant.barcode),
      price: variant.price,
      cost: variant.cost,
      stockQuantity: Value(variant.stockQuantity),
      sortOrder: Value(variant.sortOrder),
      image: Value(variant.image),
      isActive: Value(variant.isActive),
    );
    
    final id = await _database.into(_database.variants).insert(variantCompanion);
    final insertedVariant = await getVariantById(id);
    
    if (insertedVariant == null) {
      throw Exception('Failed to create variant');
    }
    
    return insertedVariant;
  }
  
  @override
  Future<entity.Variant> updateVariant(entity.Variant variant) async {
    final variantCompanion = db.VariantsCompanion(
      uuid: Value(variant.uuid),
      productId: Value(variant.productId),
      name: Value(variant.name),
      sku: Value(variant.sku),
      barcode: Value(variant.barcode),
      price: Value(variant.price),
      cost: Value(variant.cost),
      stockQuantity: Value(variant.stockQuantity),
      sortOrder: Value(variant.sortOrder),
      image: Value(variant.image),
      isActive: Value(variant.isActive),
      updatedAt: Value(DateTime.now()),
    );
    
    await _database.update(_database.variants).replace(variantCompanion);
    final updatedVariant = await getVariantByUuid(variant.uuid);
    
    if (updatedVariant == null) {
      throw Exception('Failed to update variant');
    }
    
    return updatedVariant;
  }
  
  @override
  Future<bool> deleteVariant(int id) async {
    await (_database.delete(_database.variants)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  @override
  Future<bool> softDeleteVariant(int id) async {
    await (_database.update(_database.variants)
        ..where((tbl) => tbl.id.equals(id)))
        .write(db.VariantsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  // Variant stock operations
  @override
  Future<bool> updateVariantStock(int variantId, int quantity) async {
    await (_database.update(_database.variants)
        ..where((tbl) => tbl.id.equals(variantId)))
        .write(db.VariantsCompanion(
          stockQuantity: Value(quantity),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  @override
  Future<bool> adjustVariantStock(int variantId, int adjustment, String reason) async {
    final variant = await getVariantById(variantId);
    if (variant == null) {
      throw Exception('Variant not found');
    }
    
    final newQuantity = variant.stockQuantity + adjustment;
    
    // Update variant stock
    await updateVariantStock(variantId, newQuantity);
    
    // Create stock movement record
    await _database.into(_database.stockMovements).insert(
      db.StockMovementsCompanion.insert(
        uuid: Uuid().v4(),
        productId: variant.productId,
        variantId: Value(variantId),
        movementType: adjustment > 0 ? 'adjustment_in' : 'adjustment_out',
        quantity: adjustment.abs(),
        previousQuantity: variant.stockQuantity,
        newQuantity: newQuantity,
        reason: Value(reason),
        referenceType: const Value('adjustment'),
      ),
    );
    
    return true;
  }
  
  // Ingredient operations
  @override
  Future<List<ingredient_entity.Ingredient>> getAllIngredients() async {
    final ingredients = await (_database.select(_database.ingredients)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    
    return ingredients.map(_mapIngredientToEntity).toList();
  }
  
  @override
  Future<List<ingredient_entity.Ingredient>> getActiveIngredients() async {
    final ingredients = await (_database.select(_database.ingredients)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true)))
        .get();
    
    return ingredients.map(_mapIngredientToEntity).toList();
  }
  
  @override
  Future<ingredient_entity.Ingredient?> getIngredientById(int id) async {
    final ingredient = await (_database.select(_database.ingredients)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return ingredient != null ? _mapIngredientToEntity(ingredient) : null;
  }
  
  @override
  Future<ingredient_entity.Ingredient?> getIngredientByUuid(String uuid) async {
    final ingredient = await (_database.select(_database.ingredients)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return ingredient != null ? _mapIngredientToEntity(ingredient) : null;
  }
  
  @override
  Future<ingredient_entity.Ingredient> createIngredient(ingredient_entity.Ingredient ingredient) async {
    final ingredientCompanion = db.IngredientsCompanion.insert(
      uuid: ingredient.uuid,
      name: ingredient.name,
      description: Value(ingredient.description),
      unit: Value(ingredient.unit ?? 'pcs'),
      stockQuantity: Value(ingredient.stockQuantity),
      minStockLevel: Value(ingredient.minStockLevel),
      maxStockLevel: Value(ingredient.maxStockLevel),
      cost: ingredient.cost,
      isActive: Value(ingredient.isActive),
    );
    
    final id = await _database.into(_database.ingredients).insert(ingredientCompanion);
    final insertedIngredient = await getIngredientById(id);
    
    if (insertedIngredient == null) {
      throw Exception('Failed to create ingredient');
    }
    
    return insertedIngredient;
  }
  
  @override
  Future<ingredient_entity.Ingredient> updateIngredient(ingredient_entity.Ingredient ingredient) async {
    final ingredientCompanion = db.IngredientsCompanion(
      uuid: Value(ingredient.uuid),
      name: Value(ingredient.name),
      description: Value(ingredient.description),
      unit: Value(ingredient.unit ?? 'pcs'),
      stockQuantity: Value(ingredient.stockQuantity),
      minStockLevel: Value(ingredient.minStockLevel),
      maxStockLevel: Value(ingredient.maxStockLevel),
      cost: Value(ingredient.cost),
      isActive: Value(ingredient.isActive),
      updatedAt: Value(DateTime.now()),
    );
    
    await _database.update(_database.ingredients).replace(ingredientCompanion);
    final updatedIngredient = await getIngredientByUuid(ingredient.uuid);
    
    if (updatedIngredient == null) {
      throw Exception('Failed to update ingredient');
    }
    
    return updatedIngredient;
  }
  
  @override
  Future<bool> deleteIngredient(int id) async {
    await (_database.delete(_database.ingredients)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  @override
  Future<bool> softDeleteIngredient(int id) async {
    await (_database.update(_database.ingredients)
        ..where((tbl) => tbl.id.equals(id)))
        .write(db.IngredientsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  // Recipe operations
  @override
  Future<List<entity.Recipe>> getAllRecipes() async {
    final recipes = await (_database.select(_database.recipes)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    
    return recipes.map(_mapRecipeToEntity).toList();
  }
  
  @override
  Future<List<entity.Recipe>> getRecipesByProduct(int productId) async {
    final recipes = await (_database.select(_database.recipes)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.productId.equals(productId)))
        .get();
    
    return recipes.map(_mapRecipeToEntity).toList();
  }
  
  @override
  Future<entity.Recipe?> getRecipeById(int id) async {
    final recipe = await (_database.select(_database.recipes)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return recipe != null ? _mapRecipeToEntity(recipe) : null;
  }
  
  @override
  Future<entity.Recipe?> getRecipeByUuid(String uuid) async {
    final recipe = await (_database.select(_database.recipes)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return recipe != null ? _mapRecipeToEntity(recipe) : null;
  }
  
  @override
  Future<entity.Recipe> createRecipe(entity.Recipe recipe) async {
    final recipeCompanion = db.RecipesCompanion.insert(
      uuid: recipe.uuid,
      productId: recipe.productId,
      ingredientId: recipe.ingredientId,
      quantity: recipe.quantity,
      unit: recipe.unit,
    );
    
    final id = await _database.into(_database.recipes).insert(recipeCompanion);
    final insertedRecipe = await getRecipeById(id);
    
    if (insertedRecipe == null) {
      throw Exception('Failed to create recipe');
    }
    
    return insertedRecipe;
  }
  
  @override
  Future<entity.Recipe> updateRecipe(entity.Recipe recipe) async {
    final recipeCompanion = db.RecipesCompanion(
      uuid: Value(recipe.uuid),
      productId: Value(recipe.productId),
      ingredientId: Value(recipe.ingredientId),
      quantity: Value(recipe.quantity),
      unit: Value(recipe.unit),
      updatedAt: Value(DateTime.now()),
    );
    
    await _database.update(_database.recipes).replace(recipeCompanion);
    final updatedRecipe = await getRecipeByUuid(recipe.uuid);
    
    if (updatedRecipe == null) {
      throw Exception('Failed to update recipe');
    }
    
    return updatedRecipe;
  }
  
  @override
  Future<bool> deleteRecipe(int id) async {
    await (_database.delete(_database.recipes)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  @override
  Future<bool> softDeleteRecipe(int id) async {
    await (_database.update(_database.recipes)
        ..where((tbl) => tbl.id.equals(id)))
        .write(db.RecipesCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  // Search operations
  @override
  Future<List<entity.Product>> searchProducts(String query) async {
    final products = await (_database.select(_database.products)
          ..where((tbl) => tbl.isDeleted.equals(false) & 
                           tbl.isActive.equals(true) &
                           (tbl.name.contains(query) | tbl.sku.contains(query))))
        .get();
    
    return products.map(_mapProductToEntity).toList();
  }
  
  @override
  Future<List<entity.Product>> searchProductsByCategory(int categoryId, String query) async {
    final products = await (_database.select(_database.products)
          ..where((tbl) => tbl.isDeleted.equals(false) & 
                           tbl.isActive.equals(true) & 
                           tbl.categoryId.equals(categoryId) &
                           (tbl.name.contains(query) | tbl.sku.contains(query))))
        .get();
    
    return products.map(_mapProductToEntity).toList();
  }
  
  // Mapping methods
  entity.Product _mapProductToEntity(db.Product data) {
    return entity.Product(
      id: data.id,
      uuid: data.uuid,
      sku: data.sku,
      barcode: data.barcode,
      name: data.name,
      description: data.description,
      categoryId: data.categoryId,
      price: data.price,
      cost: data.cost,
      stockQuantity: data.stockQuantity,
      minStockLevel: data.minStockLevel,
      maxStockLevel: data.maxStockLevel,
      unit: data.unit,
      image: data.image,
      isActive: data.isActive,
      isTrackStock: data.isTrackStock,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
  
  entity.Variant _mapVariantToEntity(db.Variant data) {
    return entity.Variant(
      id: data.id,
      uuid: data.uuid,
      productId: data.productId,
      name: data.name,
      sku: data.sku,
      barcode: data.barcode,
      price: data.price,
      cost: data.cost,
      stockQuantity: data.stockQuantity,
      sortOrder: data.sortOrder,
      image: data.image,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
  
  ingredient_entity.Ingredient _mapIngredientToEntity(db.Ingredient data) {
    return ingredient_entity.Ingredient(
      id: data.id,
      uuid: data.uuid,
      name: data.name,
      description: data.description,
      unit: data.unit,
      stockQuantity: data.stockQuantity,
      minStockLevel: data.minStockLevel,
      maxStockLevel: data.maxStockLevel,
      cost: data.cost,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
  
  entity.Recipe _mapRecipeToEntity(db.Recipe data) {
    return entity.Recipe(
      id: data.id,
      uuid: data.uuid,
      productId: data.productId,
      ingredientId: data.ingredientId,
      quantity: data.quantity,
      unit: data.unit,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
}