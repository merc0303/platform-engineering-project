import os
import time

from flask import Flask, jsonify, request
from prometheus_client import (CONTENT_TYPE_LATEST, Counter, Histogram,
                               generate_latest)

NAME = os.getenv("SERVICE_NAME", "users-service")
app = Flask(__name__)
REQS = Counter("http_requests_total", "Requests", ["service", "path", "status"])
LAT = Histogram("http_request_duration_seconds", "Latency", ["service", "path"])
_LEAK = []


@app.get("/")
def index():
    with LAT.labels(NAME, "/").time():
        REQS.labels(NAME, "/", "200").inc()
        return jsonify(service=NAME, version=os.getenv("APP_VERSION", "dev"))


@app.get("/healthz")
def healthz():
    return "ok"


@app.get("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}


# --- chaos endpoints for incident drills (see docs/incident-response.md) ---
@app.get("/chaos/leak")
def leak():
    _LEAK.append(bytearray(10 * 1024 * 1024))
    return jsonify(leaked_mb=len(_LEAK) * 10)


@app.get("/chaos/cpu")
def cpu():
    end = time.time() + float(request.args.get("s", 5))
    while time.time() < end:
        pass
    return "burned"
