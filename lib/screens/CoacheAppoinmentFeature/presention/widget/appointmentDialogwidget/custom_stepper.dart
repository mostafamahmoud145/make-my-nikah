// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/colorsFile.dart';

class CustomStepper extends StatelessWidget {
  CustomStepper({Key? key, required this.progress, required this.width})
      : super(key: key);
  int progress;
  double width;
  StepperStates? state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            height: convertPtToPx(AppSize.h2).h,
            width: double.infinity,
            color: Color(0xfff7f7f7),
          ),
          Container(
            height: convertPtToPx(AppSize.h2).h,
            width: width * progress,
            decoration: BoxDecoration(
              color: AppColors.greenAccent1,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProgressPoint(
                icon: AssetsManager.calendarClockIconPath,
                icon2: AssetsManager.calendarCheckIconPath,
                state: getState(progress, 0),
                iconSize: convertPtToPx(AppSize.h20).r,
              ),
              ProgressPoint(
                icon: AssetsManager.newDollarIconPath,
                icon2: AssetsManager.newDollarIconPath,
                state: getState(progress, 1),
                iconSize: convertPtToPx(AppSize.h20).r,
              ),
            ],
          ),
        ],
      ),
    );
  }

  StepperStates getState(int progress, int progressPointNumber) {
    switch (progressPointNumber) {
      case 0:
        if (progress == 0) {
          return StepperStates.reached;
        } else {
          return StepperStates.done;
        }
      case 1:
        if (progress == 0) {
          return StepperStates.notReached;
        } else if (progress == 1) {
          return StepperStates.reached;
        } else {
          return StepperStates.done;
        }
      default:
        if (progress == 0 || progress == 1) {
          return StepperStates.notReached;
        } else if (progress == 2) {
          return StepperStates.reached;
        } else {
          return StepperStates.done;
        }
    }
  }
}

class ProgressPoint extends StatelessWidget {
  ProgressPoint(
      {Key? key,
      required this.icon,
      required this.icon2,
      required this.state,
      this.iconSize = AppSize.w26_5})
      : super(key: key);
  String icon;
  String icon2;

  // bool isReached;
  double iconSize;
  StepperStates state;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: convertPtToPx(AppRadius.r19).r,
      backgroundColor: getStepperColor(state),
      child: CircleAvatar(
          radius: convertPtToPx(AppRadius.r18).r,
          backgroundColor: getStepperColor(state),
          child: SvgPicture.asset(
            state == StepperStates.reached ? icon : icon2,
            color: state == StepperStates.reached
                ? AppColors.pink2
                : state == StepperStates.done
                    ? Colors.white
                    : Color(0xffd4d4d4),
            width: iconSize,
          )),
    );
  }

  Color getStepperColor(StepperStates state) {
    switch (state) {
      case StepperStates.reached:
        return Color(0xfff7f7f7);

      case StepperStates.done:
        return AppColors.greenAccent1;

      case StepperStates.notReached:
        return Color(0xfff7f7f7);
    }
  }
}

enum StepperStates { reached, done, notReached }
