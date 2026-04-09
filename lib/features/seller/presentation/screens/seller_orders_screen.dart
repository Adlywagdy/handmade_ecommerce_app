import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_manage_order_card.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _dummyOrders = [
    {
      'id': 'Order #AY-9241',
      'customer': 'Farah Khalil',
      'items': 2,
      'total': '850.00',
      'status': 'NEW',
      'time': 'Ordered 15 mins ago',
      'buttonText': 'Process Order',
      'isFilled': true,
      'image':
          'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=200&h=200&fit=crop',
    },
    {
      'id': 'Order #AY-9240',
      'customer': 'Youssef Ibrahim',
      'items': 1,
      'total': '420.00',
      'status': 'PROCESSING',
      'time': 'Ordered 2 hours ago',
      'buttonText': 'Update Status',
      'isFilled': false,
      'image':
          'https://images.unsplash.com/photo-1582582621959-48d27397dc69?w=200&h=200&fit=crop',
    },
    {
      'id': 'Order #AY-9238',
      'customer': 'Mona Gad',
      'items': 3,
      'total': '1,200.00',
      'status': 'PROCESSING',
      'time': 'Ordered 5 hours ago',
      'buttonText': 'Update Status',
      'isFilled': false,
      'image':
          'https://images.unsplash.com/photo-1601924582970-9238bcb495d9?w=200&h=200&fit=crop',
    },
    {
      'id': 'Order #AY-9235',
      'customer': 'Ahmed Salem',
      'items': 5,
      'total': '340.00',
      'status': 'URGENT',
      'time': 'Ordered Yesterday',
      'buttonText': 'Ship Order',
      'isFilled': true,
      'image':
          'https://images.unsplash.com/photo-1600857062241-98e5dba7f214?w=200&h=200&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 64.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 4.h, bottom: 4.h),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFCF3EB), // Very light soft brown
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: commonColor, size: 20.w),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
        title: Text(
          'Orders',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: const Color(0xFF334155),
              size: 24.w,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: const Color(0xFF334155),
              size: 24.w,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: commonColor,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Plus Jakarta Sans',
              ),
              indicatorColor: commonColor,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent, // manually added border below
              tabs: const [
                Tab(text: 'Pending (12)'),
                Tab(text: 'Shipped'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(),
          _buildPlaceholderList('Shipped'),
          _buildPlaceholderList('Completed'),
          _buildPlaceholderList('Cancelled'),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _dummyOrders.length,
      itemBuilder: (context, index) {
        final order = _dummyOrders[index];
        return SellerManageOrderCard(
          orderId: order['id'],
          customerName: order['customer'],
          itemCount: order['items'],
          totalAmount: order['total'],
          status: order['status'],
          timeAgo: order['time'],
          buttonText: order['buttonText'],
          isButtonFilled: order['isFilled'],
          imageUrl: order['image'],
          onButtonPressed: () {
            // Handle Action
          },
        );
      },
    );
  }

  Widget _buildPlaceholderList(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48.w,
            color: const Color(0xFF94A3B8),
          ),
          SizedBox(height: 12.h),
          Text(
            'No $tabName Orders',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }
}
