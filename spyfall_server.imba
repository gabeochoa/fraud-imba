
import {get_locations, get_roles} from './spyfall_data.imba'
import { randOf } from './utils.imba'

const NodeCache = require('node-cache');
const cache = new NodeCache({
	stdTTL: (60 * 30)
});

def get_game cache_key
	return cache.get(cache_key)

def start_game cache_key
	let data = cache.get(cache_key)
	console.log("start game", data)
	const locations = get_locations();
	const location = randOf(locations)
	const roles = get_roles(location)

	let players = []
	for player in data.players
		player.role = randOf(roles)
		player.location = location
		player.is_spy = false
		players.push(player)
	
	const spy_index = (Math.random() * players.length)
	players[spy_index].location = null
	players[spy_index].role = "Spy"
	players[spy_index].is_spy = true

	data.players = players
	cache.set(cache_key, data)
	data

def end_game cache_key
	let data = cache.get(cache_key)
	console.log("end game", data)

	let players = []
	for player in data.players
		player.role = null
		player.location = null
		player.is_spy = false
		players.push(player)
	
	data.players = players
	cache.set(cache_key, data)
	data

const EMPTY_GAME = {
	players: []
};

def create_game cache_key
	cache.set(cache_key, EMPTY_GAME);

def join_game cache_key, input
	let data = cache.get(cache_key)
	console.log("Join Game, ", input, data)


export def spyfall_process action, room, data=null
	if action == "create" then create_game(room)
	if action == "join" then join_game(room, data)
	return JSON.stringify(get_game(room))
