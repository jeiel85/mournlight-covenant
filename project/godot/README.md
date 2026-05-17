# Mournlight Covenant Godot Prototype

Godot 4.x prototype workspace for the Phase 0 combat and World Ledger foundation.

## Current Scope

- `scenes/main.tscn`: boot scene that loads the prototype sandbox and ledger panel.
- `scenes/prototype/combat_sandbox.tscn`: minimal movement, dodge, training enemy, and primary attack input loop.
- `scripts/ledger/world_ledger.gd`: first pass of run memory, region marks, faction grievance, and omen rumor resolution.
- `scripts/core/game_data.gd`: JSON loader for repository-level design data.

## Controls

| Input | Action |
|---|---|
| WASD | Move |
| Space | Dodge |
| Left mouse | Prototype primary attack ledger event |

## Notes

The project currently reads JSON from `../../data` so design data remains shared with docs and tooling during pre-production.
