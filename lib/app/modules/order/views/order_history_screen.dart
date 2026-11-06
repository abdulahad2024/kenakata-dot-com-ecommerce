import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class OrderHistoryScreen extends GetView<OrderController> {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('আমার অর্ডারসমূহ')),
      body: RefreshIndicator(
        onRefresh: controller.fetchOrderData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Status Cards
              Obx(() {
                final counts = controller.statusCounts.value;
                if (counts == null) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusCountTile('অপেক্ষমাণ', counts.pending, Colors.orange),
                      _statusCountTile('প্রসেসিং', counts.processing, Colors.blue),
                      _statusCountTile('ডেলিভার্ড', counts.delivered, Colors.green),
                      _statusCountTile('বাতিলকৃত', counts.cancelled, Colors.red),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),
              const Text('সাম্প্রতিক অর্ডারসমূহ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: CustomShimmer(width: double.infinity, height: 110, borderRadius: 16),
                    ),
                  );
                }

                if (controller.orders.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('কোনো অর্ডার পাওয়া যায়নি।'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status).withAlpha(30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _getBengaliStatusText(order.status),
                                  style: TextStyle(
                                    color: _getStatusColor(order.status),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('তারিখ: ${order.createdAt}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${order.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ],
                              ),
                              if (order.status.toLowerCase() == 'pending')
                                TextButton(
                                  onPressed: () => controller.cancelOrder(order.id),
                                  child: const Text('অর্ডার বাতিল করুন', style: TextStyle(color: AppColors.error)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCountTile(String title, int count, Color color) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  String _getBengaliStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return 'ডেলিভার্ড';
      case 'processing':
        return 'প্রসেসিং';
      case 'cancelled':
        return 'বাতিলকৃত';
      default:
        return 'অপেক্ষমাণ';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
