#!/usr/bin/env bash
# Capture live Traditional Rangoli screens from the iPhone 6.9" and iPad 13" simulators.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUNDLE="com.sreedhar.TraditionalRangoli"
SCHEME="TraditionalRangoli"
PROJECT="$ROOT/TraditionalRangoli.xcodeproj"
RAW="$ROOT/AppStore/Screenshots/raw"
DERIVED="$ROOT/.store-derived"

SCENES=(
  "home:01-home.png:3.4"
  "learn:02-learn.png:2.2"
  "studio:03-studio.png:2.0"
  "create:04-create.png:3.2"
  "color:05-color.png:2.0"
  "saved:06-saved.png:2.6"
)

udid_for() {
  python3 - "$1" <<'PY'
import re, subprocess, sys
name = sys.argv[1]
out = subprocess.check_output(["xcrun", "simctl", "list", "devices", "available"], text=True)
for line in out.splitlines():
    if name not in line:
        continue
    match = re.search(r"\(([0-9A-F-]{36})\)", line, re.I)
    if match:
        print(match.group(1))
        raise SystemExit(0)
raise SystemExit(1)
PY
}

prepare_device() {
  local udid="$1"
  xcrun simctl boot "$udid" >/dev/null 2>&1 || true
  for _ in $(seq 1 20); do
    if xcrun simctl list devices | grep -q "$udid.*Booted"; then
      break
    fi
    sleep 1
  done
  xcrun simctl ui "$udid" appearance light >/dev/null
  xcrun simctl status_bar "$udid" override \
    --time "9:41" \
    --wifiBars 3 \
    --cellularMode active \
    --cellularBars 4 \
    --batteryState charged \
    --batteryLevel 100 \
    --operatorName "" >/dev/null || true
}

install_app() {
  local udid="$1"
  local dest="$2"
  if [[ "${SKIP_BUILD:-}" != "1" ]]; then
    xcodebuild \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -configuration Debug \
      -destination "$dest" \
      -derivedDataPath "$DERIVED" \
      CODE_SIGNING_ALLOWED=NO \
      build
  fi
  local app
  app="$(find "$DERIVED" -name "TraditionalRangoli.app" -type d | head -n 1)"
  xcrun simctl install "$udid" "$app"
}

capture_on() {
  local udid="$1"
  local folder="$2"
  mkdir -p "$folder"
  xcrun simctl privacy "$udid" grant tracking "$BUNDLE" >/dev/null 2>&1 || true

  for item in "${SCENES[@]}"; do
    local scene="${item%%:*}"
    local rest="${item#*:}"
    local file="${rest%%:*}"
    local wait="${rest##*:}"
    xcrun simctl terminate "$udid" "$BUNDLE" >/dev/null 2>&1 || true
    SIMCTL_CHILD_RANGOLI_SCREENSHOT="$scene" xcrun simctl launch --terminate-running-process "$udid" "$BUNDLE" >/dev/null
    sleep "$wait"
    xcrun simctl io "$udid" screenshot "$folder/$file"
    echo "wrote $folder/$file"
  done
}

IPHONE_NAME="${IPHONE_NAME:-iPhone 16 Pro Max}"
IPAD_NAME="${IPAD_NAME:-iPad Pro 13-inch (M4)}"

IPHONE_UDID="$(udid_for "$IPHONE_NAME" || true)"
if [[ -z "${IPHONE_UDID}" ]]; then
  IPHONE_NAME="iPhone 15 Pro Max"
  IPHONE_UDID="$(udid_for "$IPHONE_NAME" || true)"
fi
if [[ -z "${IPHONE_UDID}" ]]; then
  IPHONE_NAME="iPhone 17 Pro Max"
  IPHONE_UDID="$(udid_for "$IPHONE_NAME")"
fi

echo "iPhone: $IPHONE_NAME ($IPHONE_UDID)"
prepare_device "$IPHONE_UDID"
install_app "$IPHONE_UDID" "platform=iOS Simulator,id=$IPHONE_UDID"
capture_on "$IPHONE_UDID" "$RAW/iphone"

IPAD_UDID="$(udid_for "$IPAD_NAME" || true)"
if [[ -z "${IPAD_UDID}" ]]; then
  IPAD_NAME="iPad Pro 13-inch (M5)"
  IPAD_UDID="$(udid_for "$IPAD_NAME" || true)"
fi
if [[ -z "${IPAD_UDID}" ]]; then
  IPAD_NAME="iPad Pro (12.9-inch) (6th generation)"
  IPAD_UDID="$(udid_for "$IPAD_NAME" || true)"
fi

if [[ -n "${IPAD_UDID}" ]]; then
  echo "iPad: $IPAD_NAME ($IPAD_UDID)"
  SKIP_BUILD=1
  prepare_device "$IPAD_UDID"
  install_app "$IPAD_UDID" "platform=iOS Simulator,id=$IPAD_UDID"
  capture_on "$IPAD_UDID" "$RAW/ipad"
else
  echo "No 13-inch iPad simulator found; iPhone captures will fill iPad posters."
fi

echo "Done. Raw captures are in $RAW"
