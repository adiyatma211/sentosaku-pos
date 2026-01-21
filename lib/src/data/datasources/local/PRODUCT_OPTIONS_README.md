# Product Options Feature Documentation

## Overview
The Product Options feature allows you to add optional product customizations with checkboxes (for multiple selection) or radio buttons (for single selection). This is similar to how modern POS systems work, allowing customers to customize their orders with options like "Less Sugar", "Normal", "No Sugar", toppings, spice levels, etc.

## Database Schema

### Tables

#### ProductOptions
Defines the option categories (e.g., "Sugar Level", "Ice Level", "Toppings")

- `id`: Primary key
- `uuid`: Unique identifier
- `name`: Option name (e.g., "Sugar Level")
- `selectionType`: Selection type - 'single' (radio buttons) or 'multiple' (checkboxes)
- `sortOrder`: Display order
- `isActive`: Whether the option is active
- `createdAt`, `updatedAt`: Timestamps
- `isDeleted`: Soft delete flag
- `syncStatus`: Sync status

#### ProductOptionValues
Defines the values for each option (e.g., "Less Sugar", "Normal", "No Sugar")

- `id`: Primary key
- `uuid`: Unique identifier
- `optionId`: Reference to ProductOptions
- `name`: Value name (e.g., "Less Sugar")
- `priceAdjustment`: Additional price (+/- amount)
- `sortOrder`: Display order
- `isDefault`: Whether this is the default value
- `isActive`: Whether the value is active
- `createdAt`, `updatedAt`: Timestamps
- `isDeleted`: Soft delete flag
- `syncStatus`: Sync status

#### ProductOptionAssignments
Links options to products

- `id`: Primary key
- `uuid`: Unique identifier
- `productId`: Reference to Products
- `optionId`: Reference to ProductOptions
- `sortOrder`: Display order
- `isRequired`: Whether the option is required
- `isActive`: Whether the assignment is active
- `createdAt`, `updatedAt`: Timestamps
- `isDeleted`: Soft delete flag
- `syncStatus`: Sync status

## Usage

### Creating Product Options

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';

// Get the DAO
final productOptionDao = db.productOptionDao;

// Create an option (e.g., "Sugar Level")
final sugarLevelOptionId = await productOptionDao.createProductOption(
  ProductOptionsCompanion(
    uuid: const Value('sugar-level-uuid'),
    name: const Value('Sugar Level'),
    selectionType: const Value('single'), // Single selection (radio buttons)
    sortOrder: const Value(1),
    isActive: const Value(true),
  ),
);

// Create values for the option
await productOptionDao.createProductOptionValue(
  ProductOptionValuesCompanion(
    uuid: const Value('less-sugar-uuid'),
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
    uuid: const Value('normal-sugar-uuid'),
    optionId: Value(sugarLevelOptionId),
    name: const Value('Normal'),
    priceAdjustment: const Value(0),
    sortOrder: const Value(2),
    isDefault: const Value(true), // Default option
    isActive: const Value(true),
  ),
);
```

### Assigning Options to Products

```dart
// Assign an option to a specific product
await productOptionDao.assignOptionToProduct(
  ProductOptionAssignmentsCompanion(
    uuid: Value('assignment-uuid'),
    productId: Value(productId),
    optionId: Value(sugarLevelOptionId),
    sortOrder: Value(1),
    isRequired: const Value(false), // Options are not required
    isActive: const Value(true),
  ),
);
```

### Querying Product Options

```dart
// Get all product options
final options = await productOptionDao.getAllProductOptions();

// Get options for a specific product
final productOptions = await productOptionDao.getProductOptionsForProduct(productId);

// Get options with their values for a product
final optionsWithValues = await productOptionDao.getProductOptionsWithValues(productId);

// Get values for a specific option
final values = await productOptionDao.getOptionValues(optionId);
```

## UI Integration

### ProductCustomizationDialog

The [`ProductCustomizationDialog`](../../presentation/widgets/product_customization_dialog.dart) has been updated to display product options:

- **Single Selection** (`selectionType: 'single'`): Displays as radio buttons
- **Multiple Selection** (`selectionType: 'multiple'`): Displays as checkboxes
- **Price Adjustments**: Shows price changes (+/-) for each option
- **Default Values**: Automatically selects default options

### Cart Integration

Selected options are stored in the cart item's `notes` field as JSON:

```json
{
  "ingredients": {
    "1_Less Sugar": 0.5,
    "1_Normal": 1.0
  },
  "options": {
    "1": 2,
    "3": 5
  },
  "customNotes": "Extra hot please"
}
```

## Sample Data

A sample data script is provided in [`sample_product_options_data.dart`](./sample_product_options_data.dart) with:

### Beverage Options
- **Sugar Level**: Less Sugar, Normal, No Sugar
- **Ice Level**: No Ice, Less Ice, Normal Ice, Extra Ice
- **Toppings**: Boba (+Rp 5,000), Jelly (+Rp 3,000), Pudding (+Rp 4,000), Whipped Cream (+Rp 2,000)

### Food Options
- **Spice Level**: No Spice, Mild, Medium, Hot
- **Extra Toppings**: Extra Cheese (+Rp 5,000), Extra Meat (+Rp 10,000), Extra Egg (+Rp 3,000)

### Creating Sample Data

```dart
import '../sample_product_options_data.dart';

// Create all sample data
await SampleProductOptionsData.createAllSampleData(db);

// Create only beverage options
await SampleProductOptionsData.createSampleBeverageOptions(db);

// Create only food options
await SampleProductOptionsData.createSampleFoodOptions(db);

// Assign options to a product
await SampleProductOptionsData.assignOptionsToProduct(db, productId);
```

## Features

### Selection Types

1. **Single Selection** (`'single'`)
   - Only one value can be selected
   - Displayed as radio buttons
   - Example: Sugar Level (Less Sugar, Normal, No Sugar)

2. **Multiple Selection** (`'multiple'`)
   - Multiple values can be selected
   - Displayed as checkboxes
   - Example: Toppings (Boba, Jelly, Pudding, Whipped Cream)

### Price Adjustments

Each option value can have a price adjustment:
- Positive value: Increases the price (e.g., +Rp 5,000 for Boba)
- Negative value: Decreases the price (e.g., -Rp 2,000 for discount)
- Zero value: No price change

The total price is calculated as:
```
Total = (Base Price + Sum of Selected Option Adjustments) × Quantity
```

### Required vs Optional Options

- **Required Options**: Must be selected before adding to cart
- **Optional Options**: Can be skipped (default behavior)

## Best Practices

1. **Organize Options Logically**: Group related options together (e.g., Sugar Level, Ice Level for beverages)
2. **Set Default Values**: Always mark one value as default for single-selection options
3. **Price Adjustments**: Use price adjustments sparingly and make them clear to customers
4. **Sort Order**: Use sort order to display options in a logical sequence
5. **Active/Inactive**: Use `isActive` flag to temporarily disable options without deleting them

## Future Enhancements

- [ ] Option groups/categories
- [ ] Conditional options (e.g., show "Milk Type" only for coffee)
- [ ] Option dependencies (e.g., "Extra Toppings" only available for certain sizes)
- [ ] Image support for option values
- [ ] Stock tracking for option values
- [ ] Option templates for quick setup
