// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:habido_app/bloc/dashboard_bloc.dart';
// import 'package:habido_app/models/skip_user_habit_request.dart';
// import 'package:habido_app/models/user_habit.dart';
// import 'package:habido_app/utils/api/api_helper.dart';
// import 'package:habido_app/utils/api/api_manager.dart';
// import 'package:habido_app/utils/func.dart';
// import 'package:habido_app/utils/localization/localization.dart';
// import 'package:habido_app/utils/shared_pref.dart';
// import 'package:habido_app/utils/showcase_helper.dart';
//
// import 'bloc_manager.dart';
//
// /// ---------------------------------------------------------------------------------------------------------------------------------------------------
// /// BLOC
// /// ---------------------------------------------------------------------------------------------------------------------------------------------------
// class FeedBackCatListBloc extends Bloc<DashboardEvent, DashboardState>{
//   FeedBackCatListBloc(): super(UserhabitInit());
// }
// /// ---------------------------------------------------------------------------------------------------------------------------------------------------
// /// BLOC EVENTS
// /// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
// abstract class FeedBackCatListEvent extends Equatable{
//   const FeedBackCatListEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class GetFeedBackCatList extends FeedBackCatListEvent{
//
// }
// /// ---------------------------------------------------------------------------------------------------------------------------------------------------
// /// BLOC STATES
// /// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
// abstract class FeedBackCatListState extends Equatable{
//   const FeedBackCatListState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class FeedBackCatListInit extends FeedBackCatListState{}
//
// class FeedBackCatListLoading extends FeedBackCatListState{}
//
// class FeedBackCatListDefault extends FeedBackCatListState{}
//
// class GetFeedBackCatListSuccess extends FeedBackCatListState{
//
// }
//
// class GetFeedBackCatListFailed extends FeedBackCatListState{
//   final String message;
//
//   const GetFeedBackCatListFailed(this.message);
//
//   @override
//   List<Object> get props => [message];
//
//   @override
//   String toString() => 'GetFeedBackCatListFailed { message: $message }';
// }