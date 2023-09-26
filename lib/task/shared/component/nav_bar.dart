import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:daily_tasks/task/shared/constant/constant_values_manager.dart';
import 'package:daily_tasks/task/shared/constant/padding_margin_values_manager.dart';

import '../../presentation/router/app_router.dart';
import '../constant/assets_manager.dart';
import '../constant/strings_manager.dart';
import '../style/colors_manager.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:
            Text('', style: Theme.of(context).textTheme.bodyMedium),
            accountEmail:
            Text('', style: Theme.of(context).textTheme.bodyMedium),
            decoration: BoxDecoration(
              // color: Colors.blue,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: const AssetImage(
                    ImageAssets.drawer,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          ListTile(
            leading: SvgPicture.asset(
              ImageAssets.settings,
              color: ColorManager.darkBasicOverlay,
              width: 35,
            ),
            title: const Text(AppStrings.settings,
                style: TextStyle(fontSize: AppSize.s15)),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.settings);
            },
          ),
          const Divider(),
          ListTile(
            leading: SvgPicture.asset(
              ImageAssets.reports,
              color: ColorManager.darkBasicOverlay,
              width: 35,
            ),
            title: const Text(AppStrings.allreports,
                style: TextStyle(fontSize: AppSize.s15)),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.settings);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

}
