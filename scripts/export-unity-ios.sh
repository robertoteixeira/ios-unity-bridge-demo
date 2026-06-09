#!/bin/bash
set -e

UNITY_PROJECT_PATH="unity/UnityBridgeDemo"
EXPORT_PATH="build/unity-ios-export"

echo "Unity iOS export script"
echo "Project path: ${UNITY_PROJECT_PATH}"
echo "Export path: ${EXPORT_PATH}"

if [ ! -d "$UNITY_PROJECT_PATH" ]; then
  echo "Unity project not found at ${UNITY_PROJECT_PATH}"
  echo "Create the Unity project before running this script."
  exit 1
fi

mkdir -p build

echo "Placeholder only."
echo "Later this script will call Unity in batch mode to export the iOS project."