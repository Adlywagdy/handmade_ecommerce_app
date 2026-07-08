import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/screens/orders_screen/widget/orders_list.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../logic/admin_cubit.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

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
            AppLocalizations.of(context)!.admOrders,
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
              Colors.grey.withValues(alpha: 0.15),
            ),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.admOrdersTabAll),
              Tab(text: AppLocalizations.of(context)!.admOrdersTabPending),
              Tab(text: AppLocalizations.of(context)!.admOrdersTabActive),
              Tab(text: AppLocalizations.of(context)!.admOrdersTabDelivered),
              Tab(text: AppLocalizations.of(context)!.admOrdersTabCancelled),
            ],
          ),
        ),
        body: Column(
          children: [
            CustomSearchBar(
              hintText: AppLocalizations.of(context)!.admSearchOrderPlaceholder,
              onChanged: (v) => context.read<AdminCubit>().setOrdersQuery(v),
            ),
            Expanded(
              child: BlocBuilder<AdminCubit, AdminState>(
                builder: (context, state) {
                  final cubit = context.read<AdminCubit>();
                  if (cubit.ordersList.isEmpty && state is GetOrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cubit.ordersList.isEmpty && state is GetOrdersError) {
                    return Center(child: Text(state.error));
                  }
                  return TabBarView(
                    children: List.generate(
                      5,
                      (tab) => OrdersList(orders: cubit.ordersByTab(tab)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
