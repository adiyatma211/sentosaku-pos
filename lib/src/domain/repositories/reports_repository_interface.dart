import 'package:dartz/dartz.dart';
import '../entities/failure.dart';

abstract class ReportsRepositoryInterface {
  // Daily sales reports
  Future<Either<Failure, Map<String, dynamic>>> getDailySalesReport(DateTime date);
  Future<Either<Failure, Map<String, dynamic>>> getDailySalesReportRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getDailySalesBreakdown(DateTime date);
  Future<Either<Failure, List<Map<String, dynamic>>>> getHourlySalesBreakdown(DateTime date);

  // Payment method summaries
  Future<Either<Failure, Map<String, dynamic>>> getPaymentMethodSummary(DateTime date);
  Future<Either<Failure, Map<String, dynamic>>> getPaymentMethodSummaryRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getPaymentMethodBreakdown(DateTime date);
  Future<Either<Failure, List<Map<String, dynamic>>>> getPaymentMethodBreakdownRange(
    DateTime startDate,
    DateTime endDate,
  );

  // Best-selling products reports
  Future<Either<Failure, List<Map<String, dynamic>>>> getBestSellingProducts(
    DateTime startDate,
    DateTime endDate, {
    int? limit,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getBestSellingProductsByCategory(
    DateTime startDate,
    DateTime endDate,
    int categoryId,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getBestSellingProductsByRevenue(
    DateTime startDate,
    DateTime endDate, {
    int? limit,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getBestSellingProductsByQuantity(
    DateTime startDate,
    DateTime endDate, {
    int? limit,
  });

  // Ingredient usage reports
  Future<Either<Failure, List<Map<String, dynamic>>>> getIngredientUsageReport(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getIngredientUsageByProduct(
    DateTime startDate,
    DateTime endDate,
    int productId,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getMostUsedIngredients(
    DateTime startDate,
    DateTime endDate, {
    int? limit,
  });
  Future<Either<Failure, Map<String, dynamic>>> getIngredientCostAnalysis(
    DateTime startDate,
    DateTime endDate,
  );

  // Gross profit estimation
  Future<Either<Failure, Map<String, dynamic>>> getGrossProfitReport(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, Map<String, dynamic>>> getGrossProfitByCategory(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getProductProfitabilityReport(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getLowProfitProducts(
    DateTime startDate,
    DateTime endDate, {
    double? threshold,
  });

  // Stock movement reports
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockMovementReport(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockMovementByType(
    DateTime startDate,
    DateTime endDate,
    String movementType,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockMovementByProduct(
    DateTime startDate,
    DateTime endDate,
    int productId,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockMovementByIngredient(
    DateTime startDate,
    DateTime endDate,
    int ingredientId,
  );
  Future<Either<Failure, Map<String, dynamic>>> getStockMovementSummary(
    DateTime startDate,
    DateTime endDate,
  );

  // Inventory valuation reports
  Future<Either<Failure, Map<String, dynamic>>> getInventoryValuationReport();
  Future<Either<Failure, Map<String, dynamic>>> getInventoryValuationByCategory();
  Future<Either<Failure, List<Map<String, dynamic>>>> getInventoryAgingReport();
  Future<Either<Failure, List<Map<String, dynamic>>>> getDeadStockReport({
    int? daysThreshold,
  });

  // Sales trend analysis
  Future<Either<Failure, List<Map<String, dynamic>>>> getSalesTrendReport(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getWeeklySalesTrend(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getMonthlySalesTrend(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getYearlySalesTrend(
    DateTime startDate,
    DateTime endDate,
  );

  // Customer analysis reports
  Future<Either<Failure, List<Map<String, dynamic>>>> getCustomerSpendingReport(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getCustomerFrequencyReport(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, Map<String, dynamic>>> getCustomerAnalysisReport(
    DateTime startDate,
    DateTime endDate,
  );

  // Report export functionality
  Future<Either<Failure, String>> exportReportToPdf(
    Map<String, dynamic> reportData,
    String reportType,
    String fileName,
  );
  Future<Either<Failure, String>> exportReportToExcel(
    Map<String, dynamic> reportData,
    String reportType,
    String fileName,
  );
  Future<Either<Failure, String>> exportReportToCsv(
    List<Map<String, dynamic>> reportData,
    String fileName,
  );

  // Report scheduling and automation
  Future<Either<Failure, void>> scheduleReport(
    String reportType,
    String frequency,
    List<String> recipients,
    Map<String, dynamic> parameters,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getScheduledReports();
  Future<Either<Failure, void>> updateScheduledReport(
    int scheduleId,
    Map<String, dynamic> parameters,
  );
  Future<Either<Failure, void>> deleteScheduledReport(int scheduleId);

  // Report templates
  Future<Either<Failure, List<Map<String, dynamic>>>> getReportTemplates();
  Future<Either<Failure, Map<String, dynamic>>> getReportTemplate(int templateId);
  Future<Either<Failure, Map<String, dynamic>>> createReportTemplate(
    Map<String, dynamic> templateData,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateReportTemplate(
    int templateId,
    Map<String, dynamic> templateData,
  );
  Future<Either<Failure, void>> deleteReportTemplate(int templateId);
}