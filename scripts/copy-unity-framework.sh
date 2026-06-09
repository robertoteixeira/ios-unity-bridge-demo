cat > scripts/copy-unity-framework.sh <<'EOF'
#!/bin/bash

set -e

UNITY_EXPORT_PATH="build/unity-ios-export"
IOS_PROJECT_PATH="ios/iOSUnityBridgeDemo"
UNITY_FRAMEWORK_SOURCE="${UNITY_EXPORT_PATH}/UnityFramework"
UNITY_DATA_SOURCE="${UNITY_EXPORT_PATH}/Data"

echo "UnityFramework copy script"
echo "Unity export path: ${UNITY_EXPORT_PATH}"
echo "iOS project path: ${IOS_PROJECT_PATH}"

if [ ! -d "$UNITY_EXPORT_PATH" ]; then
  echo "Unity export not found at ${UNITY_EXPORT_PATH}"
  echo "Export the Unity iOS project before running this script."
  exit 1
fi

if [ ! -d "$IOS_PROJECT_PATH" ]; then
  echo "iOS project not found at ${IOS_PROJECT_PATH}"
  echo "Create the native iOS project before running this script."
  exit 1
fi

echo "Placeholder only."
echo "Later this script will copy UnityFramework and Data into the native iOS app."
EOF