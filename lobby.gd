extends Node

const PORT = 7000
const MAX_CONNECTIONS = 2

var players = {}
var player_info = {"name":"placeholder"}

signal player_connected(peer_id, player_id)
signal player_disconnected(peer_id)
signal server_disconnected

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error:
		return error

	multiplayer.multiplayer_peer = peer
	players[1] = player_info
	player_connected.emit(1, player_info)
	
func _on_player_connected(id):
	pass
	
func _on_player_disconnected():
	pass

func _on_connected_to_server():
	pass
	
func _on_connection_failed():
	pass
	
func _on_server_disconnected():
	pass




