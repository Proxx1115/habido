import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/badge_module.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  BadgeBloc() : super(BadgeInit());

  @override
  Stream<BadgeState> mapEventToState(BadgeEvent event) async* {
    if (event is GetBadgeListEvent) {
      yield* _mapGetBadgeListEventToState();
    }
  }

  Stream<BadgeState> _mapGetBadgeListEventToState() async* {
    try {
      yield BadgeListLoading();

      var res = await ApiManager.badgeList();
      print("nextBadge ");
      print("Bagde response:${res.badgeList} ");
      if (res.code == ResponseCode.Success) {
        print("nextBadge 2");

        yield BadgeListSuccess(res.badgeList!);
      } else {
        yield BadgeListEmpty();
      }
    } catch (e) {
      yield BadgeListFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class BadgeEvent extends Equatable {
  const BadgeEvent();

  @override
  List<Object> get props => [];
}

class GetBadgeListEvent extends BadgeEvent {}

/// BLOC STATES
abstract class BadgeState extends Equatable {
  const BadgeState();

  @override
  List<Object> get props => [];
}

class BadgeInit extends BadgeState {}

/// MOOD MONTHLY REASON STATES

class BadgeListLoading extends BadgeState {}

class BadgeListEmpty extends BadgeState {}

class BadgeListSuccess extends BadgeState {
  final List<BadgeModule> badgeList;

  const BadgeListSuccess(
    this.badgeList,
  );

  @override
  List<Object> get props => [badgeList];

  @override
  String toString() => 'BadgeListSuccess { badgeList: $badgeList}';
}

class BadgeListFailed extends BadgeState {
  final String message;

  const BadgeListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
