extends CanvasLayer

@onready var summary: RichTextLabel = $Panel/Margin/Lines/Summary


func show_result(result: Dictionary) -> void:
	var lines: Array = result.get("summary_lines", [])
	summary.text = "\n".join(PackedStringArray(lines))
