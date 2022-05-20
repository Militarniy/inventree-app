/*
 * Unit tests for the API class
 */

import "package:test/test.dart";
import "package:inventree/user_profile.dart";

void main() {

  setUp(() async {
    // Ensure we have a user profile available
    // This profile will match the dockerized InvenTree setup, running locally

    // To start with, there should not be *any* profiles available
    var profiles = await UserProfileDBManager().getAllProfiles();

    for (var prf in profiles) {
      UserProfileDBManager().deleteProfile(prf);
    }

    // Check that there are *no* profiles in the database
    profiles = await UserProfileDBManager().getAllProfiles();
    expect(profiles.length, equals(0));

    // Now, create one!
    bool result = await UserProfileDBManager().addProfile(UserProfile(
      name: "Test Profile",
      username: "testuser",
      password: "testpassword""",
      server: "http://localhost:12345",
      selected: true,
    ));

    expect(result, equals(true));

    // Ensure we have one profile available
    // expect(profiles.length, equals(1));
    profiles = await UserProfileDBManager().getAllProfiles();

    expect(profiles.length, equals(1));

    int key = -1;

    // Find the first available profile
    for (var p in profiles) {
      if (p.key != null) {
        key = p.key ?? key;
        break;
      }
    }

    // Select the profile
    await UserProfileDBManager().selectProfile(key);
  });

  // Run a set of tests for user profile functionality
  group("Profile Tests:", () {

    test("Add Invalid Profiles", () async {
      // Add a profile with missing data
      bool result = await UserProfileDBManager().addProfile(
        UserProfile(
          username: "what",
          password: "why",
        )
      );

      expect(result, equals(false));

      // Add a profile with a name that already exists
      result = await UserProfileDBManager().addProfile(
        UserProfile(
          name: "Test Profile",
          username: "xyz",
          password: "hunter42",
        )
      );

      expect(result, equals(false));

      // Check that the number of protocols available is still the same
      var profiles = await UserProfileDBManager().getAllProfiles();

      expect(profiles.length, equals(1));
    });

    test("Profile Name Check", () async {
      bool result = await UserProfileDBManager().profileNameExists("doesnotexist");
      expect(result, equals(false));

      result = await UserProfileDBManager().profileNameExists("Test Profile");
      expect(result, equals(true));
    });

    // Ensure that we can select a user profile
    test("Select Profile", () async {
      final prf = await UserProfileDBManager().getSelectedProfile();

      expect(prf, isNot(null));

      expect(prf?.name, equals("Test Profile"));
      expect(prf?.username, equals("testuser"));
      expect(prf?.password, equals("testpassword"));
      expect(prf?.server, equals("http://localhost:12345"));
    });
  });

}