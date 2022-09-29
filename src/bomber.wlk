import wollok.game.*


object bomber1 {
	var position = game.center().left(1)
	
	method image() { return "guy.png"}
	method position() { return position}
	
	method moverA(dir) {
		position = dir.siguientePosicion(position)
	}
	
	method ponerBomba() {
		game.addVisual(new Bomba(position = self.position()))
	}
}

object bomber2 {
	var position = game.center().right(1)
	
	method image() { return "guy2.png"}
	method position() { return position}
	
	method moverA(dir) { 
		if (dir.siguientePosicion(position) != stone.position()) {
			position = dir.siguientePosicion(position)
		} else{}
	}
	method teChocasteConElBomber(){
		game.ground("pepeWin.jpg")
		game.say(self,"You are the true PEPE")
	}
}

object stone {
	const position = game.center().down(1)
	
	method image() { return "stone.png"}
	method position() { return position}
	
	method teChocasteConElBomber(){
		game.ground("pepeWin.jpg")
		game.say(self,"You are the true PEPE")
	}
}

class Bomba {
	var position
	
	method image() { return "bomba.png"}
	method position() { return position}
	
	method teChocasteConElBomber(){
		game.ground("pepeWin.jpg")
		game.say(self,"You are the true PEPE")
	}
}

class ObjetoAgarrable{
	var position
	const image
	method image() { return image}
	method position() { return position}
}