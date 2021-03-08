import 'package:flutter/material.dart';

import '../models/country.dart';

/// Returns true when a country should be included in lists / dialogs
/// offered to the user.
typedef ItemFilter = bool Function(Country country);

typedef ItemBuilder = Widget Function(Country country);

