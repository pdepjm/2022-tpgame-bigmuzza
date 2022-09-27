import wollok.game.*

object jugadorUno {
	var position = game.center()
	
	method image() { return "jugadorUno.png"}
	method position() { return position}
	method moverA(dir) {position = dir.siguientePosicion(position)}
}

object jugadorDos {
	var position = game.center()
	
	method image() { return "jugadorDos.png"}
	method position() { return position}
	method moverA(dir) {position = dir.siguientePosicion(position)}
}