extends Control

@export var top_scores: Array[LeaderboardValue]
@export var normal_color: Color
@export var self_color: Color

var score_fetcher: ScoreFetcher

func _ready() -> void:
	var score_fetcher_node = get_tree().get_nodes_in_group("score_fetcher")
	if score_fetcher_node.size() > 0:
		score_fetcher = score_fetcher_node[0]
		
func _process(delta: float) -> void:
	if not score_fetcher:
		visible = false
		return
		
	if GameManager.is_game_running:
		return
	
	var current_highscore_index = score_fetcher.is_highscore(GameManager.current_score)
	
	for i in range(top_scores.size()):
		if i == current_highscore_index:
			top_scores[i].add_theme_color_override("font_color", self_color)
			top_scores[i].text = str(int(GameManager.current_score))
			top_scores[i].set_is_glowing(true)
		elif score_fetcher.current_highscores.size() > i:
			top_scores[i].text = str(score_fetcher.current_highscores[i])
			top_scores[i].add_theme_color_override("font_color", normal_color)
			top_scores[i].set_is_glowing(false)
		else:
			top_scores[i].set_is_glowing(false)
			top_scores[i].add_theme_color_override("font_color", normal_color)
			top_scores[i].text = "0"
