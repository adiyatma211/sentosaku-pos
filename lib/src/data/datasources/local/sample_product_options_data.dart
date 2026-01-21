import 'package:drift/drift.dart';
import 'app_database.dart';

/// Sample data script for creating product options like "Less Sugar", "Normal", etc.
/// This script demonstrates how to create product options with checkboxes.
class SampleProductOptionsData {
  /// Create sample product options for beverages
  static Future<void> createSampleBeverageOptions(AppDatabase db) async {
    final productOptionDao = db.productOptionDao;
    
    // 1. Create "Sugar Level" option (single selection)
    final sugarLevelOptionId = await productOptionDao.createProductOption(
      ProductOptionsCompanion(
        uuid: const Value('sugar-level-option-uuid'),
        name: const Value('Sugar Level'),
        selectionType: const Value('single'), // Single selection (radio buttons)
        sortOrder: const Value(1),
        isActive: const Value(true),
      ),
    );
    
    // 2. Create values for "Sugar Level" option
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('less-sugar-value-uuid'),
        optionId: Value(sugarLevelOptionId),
        name: const Value('Less Sugar'),
        priceAdjustment: const Value(0), // No price adjustment
        sortOrder: const Value(1),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('normal-sugar-value-uuid'),
        optionId: Value(sugarLevelOptionId),
        name: const Value('Normal'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(2),
        isDefault: const Value(true), // Default option
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('no-sugar-value-uuid'),
        optionId: Value(sugarLevelOptionId),
        name: const Value('No Sugar'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(3),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    // 3. Create "Ice Level" option (single selection)
    final iceLevelOptionId = await productOptionDao.createProductOption(
      ProductOptionsCompanion(
        uuid: const Value('ice-level-option-uuid'),
        name: const Value('Ice Level'),
        selectionType: const Value('single'),
        sortOrder: const Value(2),
        isActive: const Value(true),
      ),
    );
    
    // 4. Create values for "Ice Level" option
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('no-ice-value-uuid'),
        optionId: Value(iceLevelOptionId),
        name: const Value('No Ice'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(1),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('less-ice-value-uuid'),
        optionId: Value(iceLevelOptionId),
        name: const Value('Less Ice'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(2),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('normal-ice-value-uuid'),
        optionId: Value(iceLevelOptionId),
        name: const Value('Normal Ice'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(3),
        isDefault: const Value(true),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('extra-ice-value-uuid'),
        optionId: Value(iceLevelOptionId),
        name: const Value('Extra Ice'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(4),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    // 5. Create "Toppings" option (multiple selection)
    final toppingsOptionId = await productOptionDao.createProductOption(
      ProductOptionsCompanion(
        uuid: const Value('toppings-option-uuid'),
        name: const Value('Toppings'),
        selectionType: const Value('multiple'), // Multiple selection (checkboxes)
        sortOrder: const Value(3),
        isActive: const Value(true),
      ),
    );
    
    // 6. Create values for "Toppings" option
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('boba-value-uuid'),
        optionId: Value(toppingsOptionId),
        name: const Value('Boba'),
        priceAdjustment: const Value(5000), // +Rp 5,000
        sortOrder: const Value(1),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('jelly-value-uuid'),
        optionId: Value(toppingsOptionId),
        name: const Value('Jelly'),
        priceAdjustment: const Value(3000), // +Rp 3,000
        sortOrder: const Value(2),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('pudding-value-uuid'),
        optionId: Value(toppingsOptionId),
        name: const Value('Pudding'),
        priceAdjustment: const Value(4000), // +Rp 4,000
        sortOrder: const Value(3),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('whipped-cream-value-uuid'),
        optionId: Value(toppingsOptionId),
        name: const Value('Whipped Cream'),
        priceAdjustment: const Value(2000), // +Rp 2,000
        sortOrder: const Value(4),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    print('Sample beverage options created successfully!');
  }
  
  /// Assign options to a specific product
  static Future<void> assignOptionsToProduct(AppDatabase db, int productId) async {
    final productOptionDao = db.productOptionDao;
    
    // Get all product options
    final options = await productOptionDao.getAllProductOptions();
    
    // Assign all options to the product
    for (var option in options) {
      await productOptionDao.assignOptionToProduct(
        ProductOptionAssignmentsCompanion(
          uuid: Value('assignment-${option.id}-$productId-uuid'),
          productId: Value(productId),
          optionId: Value(option.id),
          sortOrder: Value(option.sortOrder),
          isRequired: const Value(false), // Options are not required
          isActive: const Value(true),
        ),
      );
    }
    
    print('Options assigned to product $productId successfully!');
  }
  
  /// Create sample product options for food items
  static Future<void> createSampleFoodOptions(AppDatabase db) async {
    final productOptionDao = db.productOptionDao;
    
    // 1. Create "Spice Level" option (single selection)
    final spiceLevelOptionId = await productOptionDao.createProductOption(
      ProductOptionsCompanion(
        uuid: const Value('spice-level-option-uuid'),
        name: const Value('Spice Level'),
        selectionType: const Value('single'),
        sortOrder: const Value(1),
        isActive: const Value(true),
      ),
    );
    
    // 2. Create values for "Spice Level" option
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('no-spice-value-uuid'),
        optionId: Value(spiceLevelOptionId),
        name: const Value('No Spice'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(1),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('mild-spice-value-uuid'),
        optionId: Value(spiceLevelOptionId),
        name: const Value('Mild'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(2),
        isDefault: const Value(true),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('medium-spice-value-uuid'),
        optionId: Value(spiceLevelOptionId),
        name: const Value('Medium'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(3),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('hot-spice-value-uuid'),
        optionId: Value(spiceLevelOptionId),
        name: const Value('Hot'),
        priceAdjustment: const Value(0),
        sortOrder: const Value(4),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    // 3. Create "Extra Toppings" option (multiple selection)
    final extraToppingsOptionId = await productOptionDao.createProductOption(
      ProductOptionsCompanion(
        uuid: const Value('extra-toppings-option-uuid'),
        name: const Value('Extra Toppings'),
        selectionType: const Value('multiple'),
        sortOrder: const Value(2),
        isActive: const Value(true),
      ),
    );
    
    // 4. Create values for "Extra Toppings" option
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('extra-cheese-value-uuid'),
        optionId: Value(extraToppingsOptionId),
        name: const Value('Extra Cheese'),
        priceAdjustment: const Value(5000), // +Rp 5,000
        sortOrder: const Value(1),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('extra-meat-value-uuid'),
        optionId: Value(extraToppingsOptionId),
        name: const Value('Extra Meat'),
        priceAdjustment: const Value(10000), // +Rp 10,000
        sortOrder: const Value(2),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    await productOptionDao.createProductOptionValue(
      ProductOptionValuesCompanion(
        uuid: const Value('extra-egg-value-uuid'),
        optionId: Value(extraToppingsOptionId),
        name: const Value('Extra Egg'),
        priceAdjustment: const Value(3000), // +Rp 3,000
        sortOrder: const Value(3),
        isDefault: const Value(false),
        isActive: const Value(true),
      ),
    );
    
    print('Sample food options created successfully!');
  }
  
  /// Example usage: Create all sample data
  static Future<void> createAllSampleData(AppDatabase db) async {
    print('Creating sample product options data...');
    
    // Create beverage options
    await createSampleBeverageOptions(db);
    
    // Create food options
    await createSampleFoodOptions(db);
    
    print('All sample product options data created successfully!');
  }
}
