import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/sellers/widgets/seller_card_widget.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../models/sellers_model.dart';

class SellersScreen extends StatelessWidget {
  const SellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Seller Approvals',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: blackDegree,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: commonColor,
            unselectedLabelColor: subTitleColor,
            indicatorColor: commonColor,
            overlayColor: WidgetStateProperty.all(Colors.grey.withValues(alpha: 0.15)),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: Column(
          children: [
            CustomSearchBar(
              hintText: 'Search sellers...',
              onChanged: (value) {},
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SellersList(
                    sellers: _sellers.where((s) => s.status == SellerStatus.pending).toList(),
                  ),
                  SellersList(
                    sellers: _sellers.where((s) => s.status == SellerStatus.approved).toList(),
                    showActions: false,
                  ),
                  SellersList(
                    sellers: _sellers.where((s) => s.status == SellerStatus.rejected).toList(),
                    showActions: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellersList extends StatelessWidget {
  final List<SellerData> sellers;
  final bool showActions;

  const SellersList({
    super.key,
    required this.sellers,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: sellers.length,
      itemBuilder: (context, index) {
        return SellerCard(seller: sellers[index], showActions: showActions);
      },
    );
  }
}

final _sellers = [
  const SellerData(
    sellerId: 1,
    name: 'Fatima Ahmed',
    email: 'fatima.a@ayady.com',
    specialty: 'Pottery & Ceramics Specialist',
    submittedDate: 'Oct 12, 2023',
    status: SellerStatus.pending,
    badge: 'NEW',
  ),
  const SellerData(
    sellerId: 44,
    name: 'Youssef Mansour',
    email: 'youssef.m@ayady.com',
    specialty: 'Handwoven Carpets',
    submittedDate: 'Oct 14, 2023',
    status: SellerStatus.pending,
    badge: 'URGENT',
  ),
  const SellerData(
    sellerId: 6,
    name: 'Layla Hassan',
    email: 'layla.h@ayady.com',
    specialty: 'Traditional Jewelry',
    submittedDate: 'Oct 15, 2023',
    status: SellerStatus.pending,
  ),
  const SellerData(
    sellerId: 5,
    name: 'Omar El-Sayed',
    email: 'omar.e@ayady.com',
    specialty: 'Leather Crafts',
    submittedDate: 'Sep 20, 2023',
    status: SellerStatus.approved,
  ),
  const SellerData(
    sellerId: 4,
    name: 'Nour Khalil',
    email: 'nour.k@ayady.com',
    specialty: 'Handmade Textiles',
    submittedDate: 'Sep 18, 2023',
    status: SellerStatus.approved,
  ),
  const SellerData(
    sellerId: 22,
    name: 'Ahmed Farid',
    email: 'ahmed.f@ayady.com',
    specialty: 'Mass-produced Goods',
    submittedDate: 'Oct 10, 2023',
    status: SellerStatus.rejected,
  ),
];
