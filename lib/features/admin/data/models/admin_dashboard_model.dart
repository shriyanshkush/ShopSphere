class AdminDashboardModel {
  final int totalOrders;
  final int totalUsers;
  final double totalRevenue;


  AdminDashboardModel({
    required this.totalOrders,
    required this.totalUsers,
    required this.totalRevenue,
  });


  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalOrders: json['overview']['totalOrders'],
      totalUsers: json['overview']['totalUsers'],
      totalRevenue: json['overview']['totalEarnings'].toDouble(),
    );
  }
}