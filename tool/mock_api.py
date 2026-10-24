#!/usr/bin/env python3
"""Throwaway stand-in for the school_pro backend, for UI work only.

Accepts any credentials and returns a synthetic trainer, so the login screen
and the session it stores can be exercised without running Laravel. Delete
this once the real API is reachable.

    python3 tool/mock_api.py              # serves on http://localhost:8000/api
    python3 tool/mock_api.py --port 9000

Point the app at it with:
    flutter run --dart-define=API_BASE_URL=http://localhost:8000/api
"""

import argparse
import json
from http.server import BaseHTTPRequestHandler, HTTPServer

# Synthetic only - never put real trainer or student data in here.
TRAINER = {
    "id": 7,
    "name": "Trainer A",
    "email": "trainer.a@example.com",
    "role": "trainer",
    "user_id": "TR-1001",
    "school_id": 3,
}


class Handler(BaseHTTPRequestHandler):
    def _send(self, status, payload):
        body = json.dumps(payload).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        # Flutter web calls this from another origin.
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self._send(204, {})

    def do_POST(self):
        length = int(self.headers.get("Content-Length") or 0)
        raw = self.rfile.read(length) if length else b""
        try:
            data = json.loads(raw or b"{}")
        except json.JSONDecodeError:
            data = {}

        path = self.path.rstrip("/")

        if path.endswith("/login"):
            identifier = str(data.get("identifier") or "").strip()
            password = str(data.get("password") or "")
            if not identifier or not password:
                return self._send(422, {"message": "Please check your Trainer ID and password."})
            if data.get("role") != "trainer":
                return self._send(403, {"message": "This account is not registered as a trainer."})
            # Any password is accepted; this only exists to unblock the UI.
            user = dict(TRAINER, user_id=identifier)
            return self._send(200, {
                "user": user,
                "access_token": "mock-access-token",
                "refresh_token": "mock-refresh-token",
            })

        if path.endswith("/refresh-token"):
            return self._send(200, {"access_token": "mock-access-token-refreshed"})

        if path.endswith("/logout"):
            return self._send(200, {"message": "Logged out."})

        if path.endswith("/forgot-password"):
            return self._send(200, {"message": "If the e-mail exists, a reset code has been sent."})

        return self._send(404, {"message": "Unknown endpoint."})

    def log_message(self, fmt, *args):
        # flush=True so the request log appears even when stdout is piped.
        print(f"  {self.command} {self.path} -> {args[1]}", flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8000)
    args = parser.parse_args()
    print(
        f"Mock school_pro API on http://localhost:{args.port}/api  "
        "(any password works)",
        flush=True,
    )
    HTTPServer(("0.0.0.0", args.port), Handler).serve_forever()
