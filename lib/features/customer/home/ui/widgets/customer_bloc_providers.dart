import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/logic/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/home/logic/home_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/logic/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/logic/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/logic/reviews_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/logic/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/logic/wishlist_cubit.dart';
import 'package:flutter/material.dart';

class CustomerBlocProviders extends StatelessWidget {
  final Widget child;

  const CustomerBlocProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CustomerCubit()..getCustomerdata()),
        BlocProvider(
          create: (context) => HomeCubit()
            ..getFeaturedProducts()
            ..getTopRatedProducts(),
        ),
        BlocProvider(create: (context) => SearchCubit()..getCategories()),
        BlocProvider(
          create: (context) => WishListCubit()..getWishlistProducts(),
        ),
        BlocProvider(create: (context) => CartCubit()..getcartProducts()),
        BlocProvider(create: (context) => OrderCubit()..getAllOrders()),
        BlocProvider(create: (context) => ReviewsCubit()),
      ],
      child: child,
    );
  }
}
