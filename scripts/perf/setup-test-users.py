#!/usr/bin/env python3
"""
Generate a pool of test JWT tokens for k6 load tests.

Usage:
    python3 scripts/perf/setup-test-users.py \
        --base-url http://localhost:8080 \
        --count 20 \
        --out scripts/perf/tokens.json

Requires the backend to be running with SPRING_PROFILES_ACTIVE=dev.
The /api/auth/test-token endpoint is only available in dev profile.
"""

import argparse
import json
import sys
import urllib.request
import urllib.error


def fetch_token(base_url: str, username: str) -> str:
    url = f"{base_url}/api/auth/test-token?username={username}"
    req = urllib.request.Request(url, method="POST", data=b"")
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            body = json.loads(resp.read())
            return body["token"]
    except urllib.error.HTTPError as e:
        print(f"  HTTP {e.code} for {username}: {e.read().decode()}", file=sys.stderr)
        raise
    except urllib.error.URLError as e:
        print(f"  Connection error: {e.reason}", file=sys.stderr)
        raise


def main():
    parser = argparse.ArgumentParser(description="Generate test JWT tokens for k6")
    parser.add_argument("--base-url", default="http://localhost:8080", help="Backend base URL")
    parser.add_argument("--count", type=int, default=20, help="Number of test users to create")
    parser.add_argument("--out", default="scripts/perf/tokens.json", help="Output file path")
    parser.add_argument("--prefix", default="perf-test", help="Username prefix")
    args = parser.parse_args()

    print(f"Generating {args.count} test tokens from {args.base_url} ...")
    tokens = []
    for i in range(1, args.count + 1):
        username = f"{args.prefix}-{i}"
        try:
            token = fetch_token(args.base_url, username)
            tokens.append({"username": username, "token": token})
            print(f"  [{i}/{args.count}] {username} OK")
        except Exception:
            print(f"  [{i}/{args.count}] {username} FAILED — aborting", file=sys.stderr)
            sys.exit(1)

    with open(args.out, "w") as f:
        json.dump(tokens, f, indent=2)

    print(f"\nSaved {len(tokens)} tokens to {args.out}")
    print("Remember: tokens.json is gitignored — do not commit it.")


if __name__ == "__main__":
    main()
