import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/group/add_geo_fence.dart';

class ConfidantCard extends ConsumerWidget {
  final Confidant _confidant;
  final Group _group;
  final bool isLastCard;
  const ConfidantCard(this._confidant, this._group, this.isLastCard, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onDoubleTap: () {
        ref.read(groupsProvider).connectToGroup(_group.id);
        Navigator.pushNamed(context, AddGeoFenceScreen.routeName,
            arguments: {"user": _confidant.details, "group": _group});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: !isLastCard
            ? const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: .5)))
            : null,
        child: Row(
          children: [
            Container(
              child: Icon(Icons.person, color: Colors.white,),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_confidant.details.firstname} ${_confidant.details.lastname}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  // const Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: const [
                  //     Icon(
                  //       Icons.location_on,
                  //       size: 15,
                  //     ),
                  //     Text(
                  //       "UWI, Mona",
                  //       style: TextStyle(fontSize: 10),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
