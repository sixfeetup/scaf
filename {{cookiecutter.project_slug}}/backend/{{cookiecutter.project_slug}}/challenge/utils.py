import http.client
import json
import logging
import time

from django.conf import settings

from .models import Challenge

logger = logging.getLogger(__name__)


def report_readiness():
    if Challenge.objects.filter(is_completed=True).exists():
        logger.info("Challenge already completed")
        return

    base_url = settings.CHALLENGE_BASE_URL.replace("https://", "")
    conn = http.client.HTTPSConnection(base_url)
    payload = json.dumps(
        {
            "sessionid": settings.CHALLENGE_SESSION_ID,
            "end": "{:.6f}".format(time.time()),
        }
    )
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {settings.CHALLENGE_JWT_TOKEN}",
    }
    conn.request("POST", "/Prod/report", payload, headers)
    res = conn.getresponse()
    data = res.read().decode("utf-8")
    logger.info("Response[%d]: %s", res.status, data)

    if res.status == 200:
        Challenge.objects.create(is_completed=True)
        logger.info("Challenge completed")
