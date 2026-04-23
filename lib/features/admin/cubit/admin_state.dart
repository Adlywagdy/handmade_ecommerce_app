part of 'admin_cubit.dart';

sealed class AdminState {}

class AdminInitial extends AdminState {}
///////////////////////////////////////////
class GetSellersLoading extends AdminState {}

class GetSellersSuccess extends AdminState {}

class GetSellersFailure extends AdminState {
  final String error;
  GetSellersFailure(this.error);
}

class GetSellersError extends AdminState {
  final String error;
  GetSellersError(this.error);
}

///////////////////////////////////////////
class GetOrdersLoading extends AdminState {}

class GetOrdersSuccess extends AdminState {}

class GetOrdersFailure extends AdminState {
  final String error;
  GetOrdersFailure(this.error);
}

class GetOrdersError extends AdminState {
  final String error;
  GetOrdersError(this.error);
}



///////////////////////////////////////////
class GetProductsLoading extends AdminState {}

class GetProductsSuccess extends AdminState {}

class GetProductsFailure extends AdminState {
  final String error;
  GetProductsFailure(this.error);
}

class GetProductsError extends AdminState {
  final String error;
  GetProductsError(this.error);
}


///////////////////////////////////////////
class GetSettingsLoading extends AdminState {}

class  GetSettingsSuccess extends AdminState {}

class  GetSettingsFailure extends AdminState {
  final String error;
  GetSettingsFailure(this.error);
}

class  GetSettingsError extends AdminState {
  final String error;
  GetSettingsError(this.error);
}
///////////////////////////////////////////
class GetDashboardDataLoading extends AdminState {}

class GetDashboardDataSuccess extends AdminState {}

class  GetDashboardDataFailure extends AdminState {
  final String error;
  GetDashboardDataFailure(this.error);
}

class GetDashboardDataError extends AdminState {
  final String error;
  GetDashboardDataError(this.error);
}


// ── Update states ───────────────────────────────────────
class UpdateSettingsLoading extends AdminState {}

class UpdateSettingsSuccess extends AdminState {}

class UpdateSettingsFailure extends AdminState {
  final String error;
  UpdateSettingsFailure(this.error);
}

class UpdateSettingsError extends AdminState {
  final String error;
  UpdateSettingsError(this.error);
}
