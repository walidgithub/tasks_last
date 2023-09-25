import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/style/colors_manager.dart';
import '../nested_tasks/nested_tasks.dart';

class NestedDetails extends StatefulWidget {
  const NestedDetails({Key? key}) : super(key: key);

  @override
  State<NestedDetails> createState() => _NestedDetailsState();
}

class _NestedDetailsState extends State<NestedDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.darkPrimary,
        title:
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Azkar'),
              Row(
                children: [
                  Text('(10'),
                  SizedBox(
                    width: AppConstants.smallDistance,
                  ),
                  Text('${AppStrings.items.tr()})'),
                ],
              )
            ],
          ),
        ),
        leading:
        Bounceable(
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            onTap:() async {
              await Future.delayed(Duration(milliseconds: AppConstants.durationOfDelay));
            },
            child: const Icon(Icons.keyboard_return)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Relegion')),
          ),
        ],
      ),
      body: bodyContent()
    );
  }

  Widget bodyContent(){
    return Container(
        padding: const EdgeInsets.fromLTRB(5,10,5,10),
        child:
        SingleChildScrollView(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                key: ValueKey(1),
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                        onPressed: (context) => () {
                        },
                        flex: 2,
                        backgroundColor: ColorManager.lightPrimary,
                        foregroundColor: ColorManager.basic,
                        icon: Icons.check,
                        label: 'Done'),
                    SlidableAction(
                        onPressed: (context) => () {
                        },
                        backgroundColor: ColorManager.accent,
                        foregroundColor: ColorManager.basic,
                        icon: Icons.edit,
                        label: 'Edit'),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                        onPressed: (context) => () {},
                        backgroundColor: ColorManager.accent2,
                        foregroundColor: ColorManager.basic,
                        icon: Icons.delete,
                        label: 'Delete'),
                  ],
                ),
                closeOnScroll: false,
                // child: Container(),
                child: NestedTasks(
                  taskName: 'taskName',
                  description: 'description',
                  time: 'time',
                  timer: false,
                  counter: false,
                  wheel: false,
                  nested_id: 1,
                  done: false,
                ),
              );
            },
          ),
        )

    );
  }
}
