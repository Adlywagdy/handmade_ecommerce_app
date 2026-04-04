import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/orders_screen/widget/order_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../models/orders_model.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});


  // Filter orders by status (null = All)
  List<OrderModel> _filterOrders(OrderStatus? status) => status == null
      ? _orders : _orders.where((o) => o.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Orders',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: blackDegree,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: commonColor,
            unselectedLabelColor: subTitleColor,
            indicatorColor: commonColor,
            overlayColor: WidgetStateProperty.all(
                Colors.grey.withValues(alpha: 0.15)),
            indicatorWeight: 3,
            labelStyle:
            TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
            TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Active'),
              Tab(text: 'Delivered'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: Column(
          children: [
            CustomSearchBar(
              hintText: 'Search order ID or name',
              onChanged: (value) {},
            ),
            Expanded(
              child: TabBarView(
                children: [

                  OrdersList(orders: _filterOrders(null)),
                  OrdersList(orders: _filterOrders(OrderStatus.pending)),
                  OrdersList(orders: _filterOrders(OrderStatus.active)),
                  OrdersList(orders: _filterOrders(OrderStatus.delivered)),
                  OrdersList(orders: _filterOrders(OrderStatus.cancelled)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: TextStyle(fontSize: 14.sp, color: subTitleColor),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: orders.length,
      itemBuilder: (c, i) => OrderCard(
        order: orders[i],
        onTap: () {},
      ),
    );
  }
}

final _orders = [
  const OrderModel(
    orderId: '#AY-9402',
    customerName: 'Sarah Johnson',
    sellerName: 'Artisan Crafts',
    date: 'Oct 24, 2023',
    price: 125.00,
    status: OrderStatus.pending,
  ),
  const OrderModel(
    orderId: '#AY-9388',
    customerName: 'Michael Chen',
    sellerName: 'Cairo Weaves',
    date: 'Oct 23, 2023',
    price: 240.50,
    status: OrderStatus.active,
  ),
  const OrderModel(
    orderId: '#AY-9350',
    customerName: 'Elena Rodriguez',
    sellerName: 'Desert Pottery',
    date: 'Oct 21, 2023',
    price: 89.00,
    status: OrderStatus.delivered,
  ),
  const OrderModel(
    orderId: '#AY-9312',
    customerName: 'David Smith',
    sellerName: 'Atlas Rugs',
    date: 'Oct 19, 2023',
    price: 310.00,
    status: OrderStatus.cancelled,
  ),
  const OrderModel(
    orderId: '#AY-9299',
    customerName: 'Amina Khalidi',
    sellerName: 'Nile Silks',
    date: 'Oct 18, 2023',
    price: 45.00,
    status: OrderStatus.delivered,
  ),
];
