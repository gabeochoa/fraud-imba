global css html
	ff:sans
	w:75% m:auto ta:center

import './spyfall.imba'

tag app-footer
	css fs: small 
	<self>
		<hr>
		<div>
			<h4> "Made with <3 by "
				<a href="https://www.github.com/gabeochoa"> "@gabeochoa"

tag app
	<self>
		<nav>
			<a route-to="/spyfall"> "Spyfall"
		<spyfall route="/spyfall"> 
		<app-footer>

imba.mount <app>