/// Get your own App ID at https://dashboard.agora.io/
String get appId {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return const String.fromEnvironment('TEST_APP_ID',
      defaultValue: '8777a2b62fb449c39aec15847a8d267a');
}

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
String get token {
  // Allow pass a `token` as an environment variable with name `TEST_TOEKN` by using --dart-define
  return const String.fromEnvironment('TEST_TOEKN',
      defaultValue: '0068777a2b62fb449c39aec15847a8d267aIABn459UssMZ61kzdXHRWST5ix7/eD6F3XBmRO9oWdDrAxw69csAAAAAEABqGbu4ZbY6YgEAAQBltjpi');
}

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return const String.fromEnvironment(
    'TEST_CHANNEL_ID',
    defaultValue: '12345',
  );
}

/// Your int user ID
const int uid = 0;

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';
