// Default entry point - uses dev environment
// Use main_dev.dart or main_prod.dart for explicit environment selection

import 'core/bootstrap/bootstrap.dart';
import 'core/env/env.dart';

void main() => bootstrap(Environment.dev);
