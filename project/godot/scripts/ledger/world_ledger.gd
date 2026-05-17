extends Node

const POISON_DIRGE_ID := "omen_poison_dirge"
const DEFAULT_REGION_ID := "moonless_fen"
const DEFAULT_FACTION_ID := "thorn_court"

var run_memory := {}
var region_ledger := {}
var faction_grievance := {}
var rumor_deck: Array[String] = []


func reset_run() -> void:
	run_memory = {
		"damage_by_type": {},
		"dodge_count": 0,
		"skill_damage": 0.0,
		"total_damage": 0.0,
		"kills_by_faction": {},
		"death_region": "",
	}


func record_damage(damage_type: String, amount: float, source: String = "weapon") -> void:
	run_memory["total_damage"] += amount
	var damage_by_type: Dictionary = run_memory["damage_by_type"]
	damage_by_type[damage_type] = damage_by_type.get(damage_type, 0.0) + amount
	if source == "skill":
		run_memory["skill_damage"] += amount


func record_dodge() -> void:
	run_memory["dodge_count"] += 1


func record_kill(faction_id: String, score: float = 1.0) -> void:
	var kills_by_faction: Dictionary = run_memory["kills_by_faction"]
	kills_by_faction[faction_id] = kills_by_faction.get(faction_id, 0.0) + score


func resolve_run(region_id: String = DEFAULT_REGION_ID) -> Dictionary:
	var tags := _collect_tags()
	_update_region(region_id, tags)
	_update_factions()
	rumor_deck = _build_rumors(tags)

	return {
		"region_id": region_id,
		"tags": tags,
		"rumors": rumor_deck,
		"region_ledger": region_ledger.get(region_id, {}),
		"faction_grievance": faction_grievance.duplicate(true),
		"summary_lines": _build_summary_lines(region_id, tags),
	}


func preview_result() -> Dictionary:
	record_damage("poison", 54.0)
	record_damage("steel", 28.0)
	record_kill(DEFAULT_FACTION_ID, 12.0)
	run_memory["death_region"] = DEFAULT_REGION_ID
	return resolve_run(DEFAULT_REGION_ID)


func _collect_tags() -> Array[String]:
	var tags: Array[String] = []
	var total_damage: float = max(run_memory.get("total_damage", 0.0), 1.0)
	var damage_by_type: Dictionary = run_memory["damage_by_type"]
	var poison_ratio: float = damage_by_type.get("poison", 0.0) / total_damage

	if poison_ratio >= 0.45:
		tags.append("dominant_damage_type:poison")
	if run_memory.get("dodge_count", 0) <= 1:
		tags.append("low_dodge_rate")
	if run_memory.get("death_region", "") != "":
		tags.append("death_hotspot")

	return tags


func _update_region(region_id: String, tags: Array[String]) -> void:
	var ledger: Dictionary = region_ledger.get(region_id, {
		"death_marks": 0,
		"risk": 1,
	})
	if tags.has("death_hotspot"):
		ledger["death_marks"] += 1
	ledger["risk"] = clamp(1 + int(ledger["death_marks"]), 1, 5)
	region_ledger[region_id] = ledger


func _update_factions() -> void:
	var kills_by_faction: Dictionary = run_memory["kills_by_faction"]
	for faction_id in kills_by_faction.keys():
		var delta := int(round(kills_by_faction[faction_id]))
		faction_grievance[faction_id] = clamp(faction_grievance.get(faction_id, 0) + delta, 0, 100)


func _build_rumors(tags: Array[String]) -> Array[String]:
	var rumors: Array[String] = []
	if tags.has("dominant_damage_type:poison"):
		rumors.append(POISON_DIRGE_ID)
	return rumors


func _build_summary_lines(region_id: String, tags: Array[String]) -> Array[String]:
	var lines: Array[String] = []
	if tags.has("dominant_damage_type:poison"):
		lines.append("오늘 밤, 달빛은 당신의 독을 기억했습니다.")
	if faction_grievance.has(DEFAULT_FACTION_ID):
		lines.append("Thorn Court 원한 %s" % faction_grievance[DEFAULT_FACTION_ID])
	if region_ledger.has(region_id):
		lines.append("Moonless Fen 사망 흔적 %s" % region_ledger[region_id].get("death_marks", 0))
	if rumor_deck.has(POISON_DIRGE_ID):
		lines.append("새 오멘 후보: 독의 장송가")
	lines.append("정화 가능: Memory Wax 3개 사용")
	return lines
