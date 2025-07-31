class AppConstants {
  // API Configuration
  static const String supabaseUrl = 'https://jwtomtctdnzfujozilrr.supabase.co';
  static const String streamAuthEndpoint = '/functions/v1/stream-auth';
  static const String streamApiKey = 'sptu4vrhtpjh';
  
  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String streamTokenKey = 'stream_token';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxUsernameLength = 20;
} 