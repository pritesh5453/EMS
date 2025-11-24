import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// EMS app ke bottom tabs
enum BottomTab { home, attendance, profile }

/// Global bottom navigation controller
final bottomTabProvider = StateProvider<BottomTab>((ref) => BottomTab.home);
