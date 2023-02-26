import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/user_provider.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';

final userProvider = ChangeNotifierProvider<UserProvider>(
    (ref) => UserProvider(UserRepository()));
