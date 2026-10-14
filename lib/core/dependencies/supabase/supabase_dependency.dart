import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDependency {
  static Future<void> supabaseInitDependency() async {
    await Supabase.initialize(
      url: 'https://wadafytqtditmiltzrar.supabase.co/rest/v1/',
      publishableKey: 'sb_publishable_6sH_LaFFQE5rZzfIv1Zv_w_w7lov1Gp',
    );
  }
}
