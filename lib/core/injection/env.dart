enum Environment { development, production, staging, testing }

extension EnvironmentExtension on Environment {
  String get value {
    switch (this) {
      case Environment.development:
        return 'development';
      case Environment.production:
        return 'production';
      case Environment.staging:
        return 'staging';
      case Environment.testing:
        return 'testing';
    }
  }

  String get baseURL {
    switch (this) {
      case Environment.development:
        return '192.168.1.14';
      case Environment.production:
        return 'sunscan-production.up.railway.app';
      case Environment.staging:
        return 'https://staging.com';
      case Environment.testing:
        return 'https://testing.com';
    }
  }

  int? get basePort {
    switch (this) {
      case Environment.development:
        return 8080;
      case Environment.production:
      case Environment.staging:
      case Environment.testing:
        return null;
    }
  }

  String get baseScheme {
    switch (this) {
      case Environment.development:
        return 'http';
      case Environment.production:
        return 'https';
      case Environment.staging:
        return 'https';
      case Environment.testing:
        return 'https';
    }
  }

  String get apiKey {
    switch (this) {
      case Environment.development:
        return 'SUNSCAN_INTERNAL_123_CHANGE_ME';
      case Environment.production:
        return 'SUNSCAN_INTERNAL_123_CHANGE_ME';
      case Environment.staging:
        return 'STAGING_API_KEY_789';
      case Environment.testing:
        return 'TESTING_API_KEY_012';
    }
  }

  String get baseURLFull {
    switch (this) {
      case Environment.development:
        return 'https://';
      case Environment.production:
        return 'https://';
      case Environment.staging:
        return 'https://staging.com';
      case Environment.testing:
        return 'https://testing.com';
    }
  }

  bool get isDevelopMode {
    switch (this) {
      case Environment.development:
        return true;
      case Environment.production:
        return false;
      case Environment.staging:
        return false;
      case Environment.testing:
        return true;
    }
  }
}
