import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/group_provider.dart';
import 'package:safezone_frontend/providers/medical_record_provider.dart';
import 'package:safezone_frontend/providers/notification_provider.dart';
import 'package:safezone_frontend/providers/user_provider.dart';
import 'package:safezone_frontend/repositories/group_repository.dart';
import 'package:safezone_frontend/repositories/medical_record_repository.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';

final userProvider = ChangeNotifierProvider<UserProvider>(
    (ref) => UserProvider(UserRepository()));

final groupsProvider = ChangeNotifierProvider<GroupProvider>(
    (ref) => GroupProvider(GroupRepository(), ref.read(userProvider)));

final medicalRecordProvider = ChangeNotifierProvider<MedicalRecordProvider>(
    (ref) => MedicalRecordProvider(MedicalRecordRepository(), ref.read(userProvider)));

final notificationProvider = ChangeNotifierProvider<NotificationProvider>(
    (ref) => NotificationProvider(ref.read(userProvider)));
