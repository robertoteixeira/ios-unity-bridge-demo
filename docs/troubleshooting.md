# Troubleshooting

## UnityFramework not found

Check that Unity was exported for iOS and the framework was copied into the native iOS project.

## Build fails because of signing

Check the development team and bundle identifier in Xcode.

## Unity does not load

Check:

- UnityFramework is embedded correctly.
- Data folder is copied correctly.
- AppDelegate forwards lifecycle events if needed.
- Unity is initialized only once.

## iOS messages do not reach Unity

Check:

- The Unity GameObject name is correct.
- The C# receiver method name is correct.
- The method accepts a single string parameter.

## Unity callbacks do not reach iOS

Check:

- Native iOS plugin exists under `Assets/Plugins/iOS`.
- C# uses `DllImport("__Internal")`.
- The function name matches the Objective-C++ implementation.