cat > scripts/clean.sh <<'EOF'
#!/bin/bash

set -e

echo "Cleaning generated build folders..."

rm -rf build
rm -rf unity-ios-export

echo "Clean complete."
EOF