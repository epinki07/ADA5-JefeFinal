"""Prepare ignored Flutter and Xcode settings from the iOS Firebase download."""

import argparse
import json
import plistlib
import re
from pathlib import Path


APP = Path(__file__).resolve().parents[1]
OUTPUT = APP / "firebase.ios.local.json"
XCCONFIG = APP / "ios/Flutter/FirebaseLocal.xcconfig"
BUNDLE_ID = re.compile(r"[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+")
GOOGLE_CLIENT = re.compile(r"[A-Za-z0-9-]+\.apps\.googleusercontent\.com")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("plist", type=Path)
    parser.add_argument("--output", type=Path, default=OUTPUT)
    parser.add_argument("--xcconfig", type=Path, default=XCCONFIG)
    args = parser.parse_args()
    try:
        with args.plist.open("rb") as source:
            data = plistlib.load(source)
        config = {
            "FIREBASE_API_KEY": data["API_KEY"],
            "FIREBASE_APP_ID": data["GOOGLE_APP_ID"],
            "FIREBASE_SENDER_ID": data["GCM_SENDER_ID"],
            "FIREBASE_PROJECT_ID": data["PROJECT_ID"],
            "FIREBASE_IOS_BUNDLE_ID": data["BUNDLE_ID"],
        }
        if not all(isinstance(value, str) and value.strip() for value in config.values()):
            raise ValueError("A required Firebase field is empty.")
        if ":ios:" not in config["FIREBASE_APP_ID"] or not BUNDLE_ID.fullmatch(data["BUNDLE_ID"]):
            raise ValueError("A valid iOS app and bundle ID are required.")
        xcconfig = [f'ADA5_BUNDLE_ID = {data["BUNDLE_ID"]}']
        client_id = data.get("CLIENT_ID")
        reversed_id = data.get("REVERSED_CLIENT_ID")
        if client_id or reversed_id:
            if not isinstance(client_id, str) or not GOOGLE_CLIENT.fullmatch(client_id):
                raise ValueError("The iOS Google client ID is invalid.")
            if ".".join(reversed(client_id.split("."))) != reversed_id:
                raise ValueError("The iOS Google URL scheme does not match its client ID.")
            config["GOOGLE_IOS_CLIENT_ID"] = client_id
            xcconfig.append(f"ADA5_GOOGLE_URL_SCHEME = {reversed_id}")
    except (OSError, ValueError, TypeError, KeyError, plistlib.InvalidFileException) as error:
        parser.exit(1, f"Unable to use the iOS Firebase download. {error}\n")

    args.output.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
    args.xcconfig.write_text("\n".join(xcconfig) + "\n", encoding="utf-8")
    print("Saved the local Flutter and Xcode options.")


if __name__ == "__main__":
    main()
