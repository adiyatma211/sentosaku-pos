import '../../domain/entities/ingredient.dart' as domain_ingredient;
import '../../domain/entities/product.dart' as domain_product;
import '../../domain/entities/stock.dart' as domain_stock;
import 'package:sentosa_pos_v1/src/data/datasources/local/app_database.dart' as db;
import 'package:uuid/uuid.dart';

// Ingredient mappers
domain_ingredient.Ingredient toDomainIngredient(db.Ingredient dbIngredient) {
  return domain_ingredient.Ingredient(
    id: dbIngredient.id,
    uuid: dbIngredient.uuid,
    name: dbIngredient.name,
    description: dbIngredient.description,
    unit: dbIngredient.unit,
    stockQuantity: dbIngredient.stockQuantity,
    minStockLevel: dbIngredient.minStockLevel,
    maxStockLevel: dbIngredient.maxStockLevel,
    cost: dbIngredient.cost,
    isActive: dbIngredient.isActive,
    createdAt: dbIngredient.createdAt,
    updatedAt: dbIngredient.updatedAt,
    isDeleted: dbIngredient.isDeleted,
    syncStatus: dbIngredient.syncStatus,
  );
}

db.Ingredient toDbIngredient(domain_ingredient.Ingredient domainIngredient) {
  return db.Ingredient(
    id: domainIngredient.id,
    uuid: domainIngredient.uuid,
    name: domainIngredient.name,
    description: domainIngredient.description,
    unit: domainIngredient.unit ?? 'pcs',
    stockQuantity: domainIngredient.stockQuantity,
    minStockLevel: domainIngredient.minStockLevel,
    maxStockLevel: domainIngredient.maxStockLevel,
    cost: domainIngredient.cost,
    isActive: domainIngredient.isActive,
    createdAt: domainIngredient.createdAt,
    updatedAt: domainIngredient.updatedAt,
    isDeleted: domainIngredient.isDeleted,
    syncStatus: domainIngredient.syncStatus,
  );
}

// Product mappers
domain_product.Product toDomainProduct(db.Product dbProduct) {
  return domain_product.Product(
    id: dbProduct.id,
    uuid: dbProduct.uuid,
    sku: dbProduct.sku,
    barcode: dbProduct.barcode,
    name: dbProduct.name,
    description: dbProduct.description,
    categoryId: dbProduct.categoryId,
    price: dbProduct.price,
    cost: dbProduct.cost,
    stockQuantity: dbProduct.stockQuantity,
    minStockLevel: dbProduct.minStockLevel,
    maxStockLevel: dbProduct.maxStockLevel,
    unit: dbProduct.unit,
    image: dbProduct.image,
    isActive: dbProduct.isActive,
    isTrackStock: dbProduct.isTrackStock,
    createdAt: dbProduct.createdAt,
    updatedAt: dbProduct.updatedAt,
    isDeleted: dbProduct.isDeleted,
    syncStatus: dbProduct.syncStatus,
  );
}

db.Product toDbProduct(domain_product.Product domainProduct) {
  return db.Product(
    id: domainProduct.id,
    uuid: domainProduct.uuid,
    sku: domainProduct.sku,
    barcode: domainProduct.barcode,
    name: domainProduct.name,
    description: domainProduct.description,
    categoryId: domainProduct.categoryId,
    price: domainProduct.price,
    cost: domainProduct.cost,
    stockQuantity: domainProduct.stockQuantity,
    minStockLevel: domainProduct.minStockLevel,
    maxStockLevel: domainProduct.maxStockLevel,
    unit: domainProduct.unit,
    image: domainProduct.image,
    isActive: domainProduct.isActive,
    isTrackStock: domainProduct.isTrackStock,
    createdAt: domainProduct.createdAt,
    updatedAt: domainProduct.updatedAt,
    isDeleted: domainProduct.isDeleted,
    syncStatus: domainProduct.syncStatus,
  );
}

// Stock mappers
domain_stock.Stock toDomainStock(db.Stock dbStock) {
  return domain_stock.Stock(
    id: dbStock.id,
    uuid: dbStock.uuid,
    productId: dbStock.productId,
    variantId: dbStock.variantId,
    ingredientId: dbStock.ingredientId,
    quantity: dbStock.quantity,
    reservedQuantity: dbStock.reservedQuantity,
    availableQuantity: dbStock.availableQuantity,
    lastUpdated: dbStock.lastUpdated,
    createdAt: dbStock.createdAt,
    updatedAt: dbStock.updatedAt,
    isDeleted: dbStock.isDeleted,
    syncStatus: dbStock.syncStatus,
  );
}

db.Stock toDbStock(domain_stock.Stock domainStock) {
  return db.Stock(
    id: domainStock.id,
    uuid: domainStock.uuid,
    productId: domainStock.productId ?? 0,
    variantId: domainStock.variantId,
    ingredientId: domainStock.ingredientId,
    quantity: domainStock.quantity,
    reservedQuantity: domainStock.reservedQuantity,
    availableQuantity: domainStock.availableQuantity,
    lastUpdated: domainStock.lastUpdated,
    createdAt: domainStock.createdAt,
    updatedAt: domainStock.updatedAt,
    isDeleted: domainStock.isDeleted,
    syncStatus: domainStock.syncStatus,
  );
}

// StockMovement mappers
domain_stock.StockMovement toDomainStockMovement(db.StockMovement dbMovement) {
  return domain_stock.StockMovement(
    id: dbMovement.id,
    uuid: dbMovement.uuid,
    productId: dbMovement.productId,
    variantId: dbMovement.variantId,
    ingredientId: dbMovement.ingredientId,
    movementType: dbMovement.movementType,
    quantity: dbMovement.quantity,
    previousQuantity: dbMovement.previousQuantity,
    newQuantity: dbMovement.newQuantity,
    reason: dbMovement.reason,
    referenceId: dbMovement.referenceId,
    referenceType: dbMovement.referenceType,
    createdAt: dbMovement.createdAt,
    updatedAt: dbMovement.updatedAt,
    isDeleted: dbMovement.isDeleted,
    syncStatus: dbMovement.syncStatus,
  );
}

db.StockMovement toDbStockMovement(domain_stock.StockMovement domainMovement) {
  return db.StockMovement(
    id: domainMovement.id,
    uuid: domainMovement.uuid,
    productId: domainMovement.productId ?? 0,
    variantId: domainMovement.variantId,
    ingredientId: domainMovement.ingredientId,
    movementType: domainMovement.movementType,
    quantity: domainMovement.quantity,
    previousQuantity: domainMovement.previousQuantity,
    newQuantity: domainMovement.newQuantity,
    reason: domainMovement.reason,
    referenceId: domainMovement.referenceId,
    referenceType: domainMovement.referenceType,
    createdAt: domainMovement.createdAt,
    updatedAt: domainMovement.updatedAt,
    isDeleted: domainMovement.isDeleted,
    syncStatus: domainMovement.syncStatus,
  );
}

// Recipe mappers
domain_product.Recipe toDomainRecipe(db.Recipe dbRecipe) {
  return domain_product.Recipe(
    id: dbRecipe.id,
    uuid: dbRecipe.uuid,
    productId: dbRecipe.productId,
    ingredientId: dbRecipe.ingredientId,
    quantity: dbRecipe.quantity,
    unit: dbRecipe.unit,
    createdAt: dbRecipe.createdAt,
    updatedAt: dbRecipe.updatedAt,
    isDeleted: dbRecipe.isDeleted,
    syncStatus: dbRecipe.syncStatus,
  );
}

db.Recipe toDbRecipe(domain_product.Recipe domainRecipe) {
  return db.Recipe(
    id: domainRecipe.id,
    uuid: domainRecipe.uuid,
    productId: domainRecipe.productId,
    ingredientId: domainRecipe.ingredientId,
    quantity: domainRecipe.quantity,
    unit: domainRecipe.unit,
    createdAt: domainRecipe.createdAt,
    updatedAt: domainRecipe.updatedAt,
    isDeleted: domainRecipe.isDeleted,
    syncStatus: domainRecipe.syncStatus,
  );
}
