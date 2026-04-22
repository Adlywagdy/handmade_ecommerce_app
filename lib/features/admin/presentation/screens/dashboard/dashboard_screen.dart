import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/colors.dart';
import '../../../cubit/admin_cubit.dart';
import 'widgets/dashboard_body.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<AdminCubit>().refreshDashboard(),
          child: BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              final cubit = context.read<AdminCubit>();
              if (cubit.dashboardStats == null && state is GetDashboardDataLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (cubit.dashboardStats == null && state is GetDashboardDataError) {
                return ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
                    SizedBox(height: 200.h),
                    Center(child: Text(state.error)),
                  ],
                );
              }
              return DashboardBody(cubit: cubit);
            },
          ),
        ),
      ),
    );
  }
}