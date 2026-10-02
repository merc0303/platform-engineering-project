from app import app


def test_health():
    assert app.test_client().get("/healthz").data == b"ok"


def test_index():
    assert app.test_client().get("/").json["service"]


def test_metrics():
    assert b"http_requests_total" in app.test_client().get("/metrics").data
