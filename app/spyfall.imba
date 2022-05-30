# [route=/spyfall]
import {nanoid} from 'nanoid'

const raw_locations = [
	"Airplane", "Amusement Park", "Art Museum", "Bank", "Beach", "Broadway Theater",
	"Candy Factory", "Casino", "Cat Show", "Cathedral", "Cemetery", "Circus Tent",
	"Coal Mine", "Construction Site", "Corporate Party", "Crusader Army", "Day Spa", "Embassy",
	"Gaming Convention", "Gas Station", "Harbor Docks", "Hospital", "Hotel", "Ice Hockey Stadium",
	"Jail", "Jazz Club", "Library", "Military Base", "Movie Studio", "Night Club",
	"Ocean Liner", "Passenger Train", "Pirate Ship", "Polar Station", "Police Station", "Race Track",
	"Restaurant", "Retirement Home", "Rock Concert", "School", "Service Station", "Sightseeing Bus",
	"Space Station", "Stadium", "Submarine", "Subway", "Supermarket", "The UN",
	"University", "Vineyard", "Wedding", "Zoo",
];
const mk_loc = do(x) {loc: x, disabled: false};
const LOCATIONS = raw_locations.map(mk_loc);
const DEFAULT_TIMER = 60 * 5

global css html
	ff:sans

css 
	button bgc:transparent border: 1px solid black/10 @hover:black/30 @active:black rd:md px:5 py:2 m: 2px
	input m:10px p:10px

tag spyfall-header
	css d:flex jac:center
	<self>
		<h2> ":tophat: Spyfall!"

tag spyfall-root
	<self>
		<button route-to="/spyfall/new"> "New Game"
		<button route-to="/spyfall/join"> "Join Game"
		<button route-to="/spyfall/about"> "About / Rules"

tag spyfall-about
	<self>
		<p> "test"
		<button route-to="/spyfall"> "Back"

tag spyfall-new
	<self>
		<input placeholder="Name">
		<p> "Enter a number in minutes:"
		<input placeholder="5">
		<br>
		<button route-to="/spyfall"> "Create"
		<button route-to="/spyfall"> "Back"

tag spyfall-join
	prop code = ""
	def render
		<self>
			<input placeholder="Name">
			<input placeholder="Room Code" bind=code>
			<br>
			<button route-to="/spyfall/lobby/{code}"> "Join"
			<button route-to="/spyfall"> "Back"

tag spyfall-timer
	prop secs = DEFAULT_TIMER
	prop show = true

	css 
		.blink opacity:0 

	def pad str, pad, len
		(new Array(len+1).join(pad)+str).slice(-len)

	def render
		const m = Math.floor(secs/60)
		const s = secs-(m*60)
		setTimeout(&, 1000) do
			if secs < 1 
				show = !show
			else
				secs -= 1
			imba.commit()
		<self>
			<p .blink=!show ease> 
				"{pad(m, '0', 2)}:{pad(s, '0', 2)}"

tag spyfall-running 
	prop locations = LOCATIONS
	prop loc = ""
	prop role = ""
	prop players = ["player1", "test"]

	css 
		ul column-count: 2 list-style: none  p: 10px 
		li bgc: gray2 fs:sm c:black/75 py:1px mb:5px
		.off td:line-through c:black/15 
	
	def toggle location do location.disabled = !location.disabled;

	def render
		<self>
			<spyfall-timer>
			<p> "Role: {role}"
			<p> "Players:"
			<ul>
				for player in players 
					<li> player 
			<p> "Possible Locations: {loc}"
			<ul>
				for location in locations
					const loc = location.loc 
					const disabled = location.disabled
					<li @click=toggle(location) .off=disabled> loc
			<button @click=emit("end-game")> "End Game"
			<button route-to="/spyfall"> "Leave Game"

tag spyfall-waiting
	prop players = []

	css
		c: black/70 
		ul list-style:decimal ta:left 
		.odd bgc: black/10

	def render
		<self>
			<ul>
				for player, i in players
					<li .odd=(i % 2 != 0)> player.name
			<button @click=emit("start-game")> "Start Game"
			<button route-to="/spyfall"> "Leave Game"

tag spyfall-lobby
	prop state = "waiting"
	prop players = [
		{id: nanoid(), name: "Test" },
		{id: nanoid(), name: "Test2" },
	]

	def endGame do state = "waiting" if state == "running"
	def startGame do state = "running" if state == "waiting"

	def render
		<self> 
			<p> "Room Code: {route.params.room}"
			<p> "waiting for players..." if state == "waiting" and players.length == 0
			<spyfall-running @end-game=endGame> if state == "running"
			<spyfall-waiting @start-game=startGame players=players> if state == "waiting"

tag spyfall
	<self>
		<spyfall-header>
		<spyfall-root route=""> 
		<spyfall-root route="lobby$"> 
		// 
		<spyfall-new route="new">
		<spyfall-join route="join">
		<spyfall-about route="about">
		<spyfall-lobby route="lobby/:room">
