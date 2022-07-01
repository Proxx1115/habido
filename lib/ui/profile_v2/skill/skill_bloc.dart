import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/skill.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

class SkillBloc extends Bloc<SkillEvent, SkillState> {
  SkillBloc() : super(SkillInit());

  @override
  Stream<SkillState> mapEventToState(SkillEvent event) async* {
    if (event is GetSkillListEvent) {
      yield* _mapGetSkillListEventToState();
    }
  }

  Stream<SkillState> _mapGetSkillListEventToState() async* {
    try {
      yield SkillListLoading();

      var res = await ApiManager.skillList();
      print("skillList -->>>:${res.skillList} ");
      if (res.code == ResponseCode.Success) {
        print("skill done ");
        yield SkillListSuccess(res.skillList!);
      } else {
        yield SkillListEmpty();
      }
    } catch (e) {
      yield SkillListFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class SkillEvent extends Equatable {
  const SkillEvent();

  @override
  List<Object> get props => [];
}

class GetSkillListEvent extends SkillEvent {}

/// BLOC STATES
abstract class SkillState extends Equatable {
  const SkillState();

  @override
  List<Object> get props => [];
}

class SkillInit extends SkillState {}

/// MOOD MONTHLY REASON STATES

class SkillListLoading extends SkillState {}

class SkillListEmpty extends SkillState {}

class SkillListSuccess extends SkillState {
  final List<Skill> badgeList;

  const SkillListSuccess(
    this.badgeList,
  );

  @override
  List<Object> get props => [badgeList];

  @override
  String toString() => 'BadgeListSuccess { badgeList: $badgeList}';
}

class SkillListFailed extends SkillState {
  final String message;

  const SkillListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
