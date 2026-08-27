#!/usr/bin/env python3
"""Fail if Home / Explore / Saved chrome falls back to English."""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from l10n_full import FULL  # noqa: E402


def test_chinese_screenshot_strings() -> None:
    zh = FULL["chinese"]
    assert zh["exploreCollections"] == "探索合集"
    assert zh["familyFloral"] == "花卉"
    assert zh["festivalOnam"] == "欧南节"
    assert zh["pattern.onam-pookalam.title"] == "欧南节花毯"
    assert zh["searchHint"] != "Search pulli, sikku, Pongal…"
    assert zh["sectionTraditional"] != "TRADITIONAL"
    assert "Onam Pookalam" not in zh["pattern.onam-pookalam.title"]
    assert zh["emptyGalleryTitle"] != "Your rangoli gallery is waiting."


def test_generator_rejects_english_leftovers() -> None:
    subprocess.check_call([sys.executable, str(ROOT / "generate_l10n.py")])


if __name__ == "__main__":
    test_chinese_screenshot_strings()
    test_generator_rejects_english_leftovers()
    print("test_l10n.py ok")
