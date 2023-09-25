import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/constant/assets_manager.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';
import '../../../shared/style/colors_manager.dart';

Widget myCounter(int index) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: ColorManager.darkbasic, width: 2.0.w),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppPadding.p8, AppPadding.p0, AppPadding.p0, AppPadding.p0),
            child: Text(
              index.toString(),
              style: TextStyle(fontSize: AppSize.s15.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SvgPicture.asset(ImageAssets.scroll,
              color: ColorManager.basic, width: 20.w),
        ],
      ),
    ),
  );
}




