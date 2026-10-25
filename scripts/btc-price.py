#!/usr/bin/env python3
"""Print a BTC/USD spot quote from Coinbase's public API."""

import json
import sys
from datetime import datetime, timezone
from decimal import Decimal, InvalidOperation
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

URL = "https://api.coinbase.com/v2/prices/BTC-USD/spot"


def main() -> int:
    request = Request(URL, headers={"Accept": "application/json", "User-Agent": "arch-amber-crt/0.1"})
    try:
        with urlopen(request, timeout=8) as response:
            payload = json.load(response)
        amount = Decimal(payload["data"]["amount"])
        if amount <= 0:
            raise ValueError("non-positive price")
    except (HTTPError, URLError, TimeoutError, OSError, ValueError, KeyError, TypeError, InvalidOperation, json.JSONDecodeError) as exc:
        print(f"BTC/USD: цена сейчас недоступна ({type(exc).__name__}); проверь интернет позже.")
        return 1

    stamp = datetime.now(timezone.utc).astimezone().strftime("%Y-%m-%d %H:%M %Z")
    print(f"BTC / USD    ${amount:,.2f}")
    print(f"Источник: Coinbase Spot  |  получено: {stamp}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
