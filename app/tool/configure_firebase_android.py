"""Convert the Firebase Android client file to Flutter compile-time options."""

import argparse
import json
from pathlib import Path


ANDROID_PACKAGE = "com.example.login_rive_animation"
OUTPUT = Path(__file__).resolve().parents[1] / "firebase.android.local.json"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("google_services", type=Path)
    parser.add_argument("--output", type=Path, default=OUTPUT)
    args = parser.parse_args()

    try:
        data = json.loads(args.google_services.read_text(encoding="utf-8"))
        client = next(
            c for c in data["client"]
            if c["client_info"]["android_client_info"]["package_name"] == ANDROID_PACKAGE
        )
        project = data["project_info"]
        config = {
            "FIREBASE_API_KEY": client["api_key"][0]["current_key"],
            "FIREBASE_APP_ID": client["client_info"]["mobilesdk_app_id"],
            "FIREBASE_SENDER_ID": project["project_number"],
            "FIREBASE_PROJECT_ID": project["project_id"],
        }
        web_oauth = next(
            (entry.get("client_id") for entry in client.get("oauth_client", [])
             if entry.get("client_type") == 3),
            None,
        )
        if web_oauth:
            config["GOOGLE_SERVER_CLIENT_ID"] = web_oauth
        if not all(isinstance(value, str) and value.strip() for value in config.values()):
            raise ValueError("Missing a required Firebase client field.")
    except StopIteration:
        parser.exit(1, f"The file has no Android app registered as {ANDROID_PACKAGE}.\n")
    except (OSError, ValueError, TypeError, KeyError, IndexError):
        parser.exit(1, "Download a valid google-services.json from Firebase Project Settings.\n")

    args.output.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
    print(f"Saved the local Flutter configuration to {args.output}.")
    if not web_oauth:
        print("Enable Google sign-in and register the Android fingerprint, then download the file again.")


if __name__ == "__main__":
    main()
