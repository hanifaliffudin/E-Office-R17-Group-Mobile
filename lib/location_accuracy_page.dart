import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:militarymessenger/controllers/state_controllers.dart';

class LocationAccuracyPage extends StatefulWidget {
  const LocationAccuracyPage({Key? key}) : super(key: key);

  @override
  State<LocationAccuracyPage> createState() => _LocationAccuracyPageState();
}

class _LocationAccuracyPageState extends State<LocationAccuracyPage> {
  final StateController _stateController = Get.put(StateController());

  // @override
  // Widget build(BuildContext context) {
  //   final mq = MediaQuery.of(context);
  //   final bottomOffset = mq.viewInsets.bottom + mq.padding.bottom;
  //     // You can play with some different Curves:
  //   const curve = Curves.easeOutQuad;
  //     // and timings:
  //   const durationMS = 275;
  //     // Also, you can add different setup for Android
  //   return Scaffold(
  //     // !!! Important part > to disable default scaffold insets (which is not animated)
  //     resizeToAvoidBottomInset: false,
  //     appBar: AppBar(title: Text('Keyboard Animation')),
  //     body: AnimatedContainer(
  //       curve: curve,
  //       duration: const Duration(milliseconds: durationMS),
  //       padding: EdgeInsets.only(bottom: bottomOffset),
  //       child: SafeArea(
  //         bottom: false, // !!! Important part > we are adding SafeArea.bottom above with " + mq.padding.bottom"
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: ListView(
  //                 children: List.generate(100, (i) => Container(
  //                   height: 24.0,
  //                   child: Text(i.toString()),
  //                 )),
  //               ),
  //             ),
  //             Align(
  //               alignment: Alignment.bottomLeft,
  //               child: Container(
  //                 color: Colors.grey[100],
  //                 padding: const EdgeInsets.symmetric(vertical: 6),
  //                 child: Row(
  //                   children: [
  //                     SizedBox(
  //                       width: 60,
  //                       child: Icon(Icons.add_a_photo),
  //                     ),
  //                     Flexible(
  //                       child: TextField(
  //                         style: Theme.of(context).textTheme.titleMedium,
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: 'Enter text...',
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 60,
  //                       child: Icon(Icons.send),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Obx(
          () => Text(
            '${_stateController.locationAccuracy}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}