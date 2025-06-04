class ReportPerformanceMetricsModel {
  // Order Metrics
  int? totalOrders;
  int? completedOrders;
  int? cancelledOrders;
  double? cancellationRate;
  double? averageOrderValue;
  double? averageOrderProcessingTime;
  double? averageDeliveryTime;

  // Revenue Metrics
  double? totalRevenue;
  double? netRevenue;
  double? averageRevenuePerOrder;
  double? revenueGrowthRate;
  double? profitMargin;

  // Customer Metrics
  int? totalCustomers;
  int? newCustomers;
  int? returningCustomers;
  double? customerRetentionRate;
  double? averageCustomerRating;
  int? totalReviews;

  // Product Metrics
  int? totalProducts;
  int? activeProducts;
  int? outOfStockProducts;
  double? averageProductRating;
  double? productReturnRate;

  // Time Period
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  ReportPerformanceMetricsModel({
    // Order Metrics
    this.totalOrders,
    this.completedOrders,
    this.cancelledOrders,
    this.cancellationRate,
    this.averageOrderValue,
    this.averageOrderProcessingTime,
    this.averageDeliveryTime,

    // Revenue Metrics
    this.totalRevenue,
    this.netRevenue,
    this.averageRevenuePerOrder,
    this.revenueGrowthRate,
    this.profitMargin,

    // Customer Metrics
    this.totalCustomers,
    this.newCustomers,
    this.returningCustomers,
    this.customerRetentionRate,
    this.averageCustomerRating,
    this.totalReviews,

    // Product Metrics
    this.totalProducts,
    this.activeProducts,
    this.outOfStockProducts,
    this.averageProductRating,
    this.productReturnRate,

    // Time Period
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  ReportPerformanceMetricsModel.fromJson(Map<String, dynamic> json) {
    // Order Metrics
    totalOrders = json['total_orders'];
    completedOrders = json['completed_orders'];
    cancelledOrders = json['cancelled_orders'];
    cancellationRate = json['cancellation_rate']?.toDouble();
    averageOrderValue = json['average_order_value']?.toDouble();
    averageOrderProcessingTime =
        json['average_order_processing_time']?.toDouble();
    averageDeliveryTime = json['average_delivery_time']?.toDouble();

    // Revenue Metrics
    totalRevenue = json['total_revenue']?.toDouble();
    netRevenue = json['net_revenue']?.toDouble();
    averageRevenuePerOrder = json['average_revenue_per_order']?.toDouble();
    revenueGrowthRate = json['revenue_growth_rate']?.toDouble();
    profitMargin = json['profit_margin']?.toDouble();

    // Customer Metrics
    totalCustomers = json['total_customers'];
    newCustomers = json['new_customers'];
    returningCustomers = json['returning_customers'];
    customerRetentionRate = json['customer_retention_rate']?.toDouble();
    averageCustomerRating = json['average_customer_rating']?.toDouble();
    totalReviews = json['total_reviews'];

    // Product Metrics
    totalProducts = json['total_products'];
    activeProducts = json['active_products'];
    outOfStockProducts = json['out_of_stock_products'];
    averageProductRating = json['average_product_rating']?.toDouble();
    productReturnRate = json['product_return_rate']?.toDouble();

    // Time Period
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // Order Metrics
    if (totalOrders != null) data['total_orders'] = totalOrders;
    if (completedOrders != null) data['completed_orders'] = completedOrders;
    if (cancelledOrders != null) data['cancelled_orders'] = cancelledOrders;
    if (cancellationRate != null) data['cancellation_rate'] = cancellationRate;
    if (averageOrderValue != null)
      data['average_order_value'] = averageOrderValue;
    if (averageOrderProcessingTime != null)
      data['average_order_processing_time'] = averageOrderProcessingTime;
    if (averageDeliveryTime != null)
      data['average_delivery_time'] = averageDeliveryTime;

    // Revenue Metrics
    if (totalRevenue != null) data['total_revenue'] = totalRevenue;
    if (netRevenue != null) data['net_revenue'] = netRevenue;
    if (averageRevenuePerOrder != null)
      data['average_revenue_per_order'] = averageRevenuePerOrder;
    if (revenueGrowthRate != null)
      data['revenue_growth_rate'] = revenueGrowthRate;
    if (profitMargin != null) data['profit_margin'] = profitMargin;

    // Customer Metrics
    if (totalCustomers != null) data['total_customers'] = totalCustomers;
    if (newCustomers != null) data['new_customers'] = newCustomers;
    if (returningCustomers != null)
      data['returning_customers'] = returningCustomers;
    if (customerRetentionRate != null)
      data['customer_retention_rate'] = customerRetentionRate;
    if (averageCustomerRating != null)
      data['average_customer_rating'] = averageCustomerRating;
    if (totalReviews != null) data['total_reviews'] = totalReviews;

    // Product Metrics
    if (totalProducts != null) data['total_products'] = totalProducts;
    if (activeProducts != null) data['active_products'] = activeProducts;
    if (outOfStockProducts != null)
      data['out_of_stock_products'] = outOfStockProducts;
    if (averageProductRating != null)
      data['average_product_rating'] = averageProductRating;
    if (productReturnRate != null)
      data['product_return_rate'] = productReturnRate;

    // Time Period
    if (startDate != null) data['start_date'] = startDate;
    if (endDate != null) data['end_date'] = endDate;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;

    return data;
  }
}
