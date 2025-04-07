class_name ScoreFetcher

extends Node2D

var url: String
var get_route: String
var post_route: String

var current_highscores: Array[int]

@onready var http_request = $HTTPRequest

func _ready() -> void:
	var file = FileAccess.open("res://server_infos.txt", FileAccess.READ)
	if file:
		var i = 0
		while not file.eof_reached():
			var line = file.get_line()
			if i == 0:
				url = line
			elif i == 1:
				get_route = line
			else:
				post_route = line
			i += 1
	get_scores()
	
func get_scores() -> void:
	if not url:
		return
	var headers = ["Content-Type: application/json"]
	http_request.request(url + get_route, headers, HTTPClient.METHOD_GET)

func post_score(score: int) -> void:
	if not url:
		return
	var should_request = current_highscores.size() < 3
	if not should_request:
		for i in range(current_highscores.size()):
			if score > current_highscores[i]:
				should_request = true
	if should_request:
		var json = {'score' : score}
		var headers = ["Content-Type: application/json"]
		http_request.request(url + post_route, headers, HTTPClient.METHOD_POST, JSON.stringify(json))
	
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json_result = JSON.parse_string(body.get_string_from_utf8())
	if not json_result || not json_result.has("status"):
		return
	var status = json_result["status"] 
	if status && status == "OK":
		var scores
		if json_result.has("scores"):
			scores = json_result["scores"]
		if scores:
			current_highscores.clear()
			for i in range(scores.size()):
				var score = scores[i]["score"]
				if score:
					current_highscores.push_back(int(score))
	else:
		get_scores()

func is_highscore(score: int) -> int:
	if current_highscores.size() == 0:
		return 0
	for i in range(3):
		if i >= current_highscores.size() || score >= current_highscores[i]:
			return i
	return -1
