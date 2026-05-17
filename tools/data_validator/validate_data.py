#!/usr/bin/env python3
"""Validate Mournlight Covenant design data files."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "data"


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def require_keys(item: dict[str, Any], keys: set[str], label: str) -> None:
    missing = keys - set(item)
    require(not missing, f"{label} is missing keys: {', '.join(sorted(missing))}")


def validate_factions() -> set[str]:
    factions = load_json(DATA / "factions" / "factions.json")
    require(isinstance(factions, list), "factions.json must contain a list")
    ids: set[str] = set()
    for faction in factions:
        require_keys(faction, {"id", "name", "theme", "reaction"}, "faction")
        require(faction["id"] not in ids, f"duplicate faction id: {faction['id']}")
        ids.add(faction["id"])
    return ids


def validate_regions(faction_ids: set[str]) -> None:
    regions = load_json(DATA / "regions" / "regions.json")
    require(isinstance(regions, list), "regions.json must contain a list")
    ids: set[str] = set()
    for region in regions:
        require_keys(region, {"id", "name", "faction", "gimmick"}, "region")
        require(region["id"] not in ids, f"duplicate region id: {region['id']}")
        require(region["faction"] in faction_ids, f"unknown faction for region {region['id']}: {region['faction']}")
        ids.add(region["id"])


def validate_omen(path: Path) -> None:
    omen = load_json(path)
    require_keys(
        omen,
        {"id", "name_ko", "name_en", "trigger", "effects", "risk", "reward_multiplier", "hard_counter_allowed"},
        path.name,
    )
    require(1 <= int(omen["risk"]) <= 5, f"{path.name} risk must be between 1 and 5")
    require(float(omen["reward_multiplier"]) >= 1.0, f"{path.name} reward_multiplier must be >= 1.0")
    for effect in omen["effects"]:
        require_keys(effect, {"type", "value"}, f"{path.name} effect")
        if effect["type"] == "enemy_resistance":
            require(float(effect["value"]) <= 0.35, f"{path.name} enemy resistance exceeds hard-counter cap")


def validate_weapon(path: Path) -> None:
    weapon = load_json(path)
    require_keys(weapon, {"id", "name_en", "name_ko", "role", "levels", "evolutions"}, path.name)
    levels = weapon["levels"]
    require(isinstance(levels, list) and len(levels) == 5, f"{path.name} must define 5 weapon levels")
    for expected, level in enumerate(levels, start=1):
        require_keys(level, {"level", "effect"}, f"{path.name} level")
        require(level["level"] == expected, f"{path.name} levels must be sequential from 1 to 5")
    require(len(weapon["evolutions"]) == 2, f"{path.name} must define exactly 2 evolutions")


def main() -> None:
    faction_ids = validate_factions()
    validate_regions(faction_ids)
    for path in sorted((DATA / "omens").glob("*.json")):
        validate_omen(path)
    for path in sorted((DATA / "weapons").glob("*.json")):
        validate_weapon(path)
    print("Data validation passed.")


if __name__ == "__main__":
    main()
