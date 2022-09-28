import wollok.game.*

object bomber1 {
	var position = game.center().left(1)
	
	method image() { return "bomber1.png"}
	method position() { return position}
	
	method moverA(dir) {
		position = dir.siguientePosicion(position)
	}
}

object bomber2 {
	var position = game.center().right(1)
	
	method image() { return "bomber2.png"}
	method position() { return position}
	
	method moverA(dir) {
		position = dir.siguientePosicion(position)
	}
}