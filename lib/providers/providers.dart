import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/group_provider.dart';
import 'package:safezone_frontend/providers/location_provider.dart';
import 'package:safezone_frontend/providers/user_provider.dart';
import 'package:safezone_frontend/repositories/group_repository.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';
import 'package:safezone_frontend/utils/location_util.dart';

final userProvider = ChangeNotifierProvider<UserProvider>(
    (ref) => UserProvider(UserRepository()));

final groupsProvider = ChangeNotifierProvider<GroupProvider>(
    (ref) => GroupProvider(GroupRepository(), ref.read(userProvider)));

//final locationProvider =
//    ChangeNotifierProvider<LocationProvider>((ref) => LocationProvider(locationUtil));
