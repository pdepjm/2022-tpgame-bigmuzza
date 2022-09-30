import wollok.game.*
import juego.*


object bomber1 {
	var position = game.center().left(1)
	
	method image() { return "guy.png"}
	method position() { return position}
	
	method moverA(direccion) { 
		if (game.getObjectsIn(direccion.siguientePosicion(position)).isEmpty())
			position = direccion.siguientePosicion(position)
	}
	
	method ponerBomba() {
		const bomba = new Bomba(position = self.position())
		game.addVisual(bomba)
		game.schedule(1000, {=> bomba.explotar(bomba)})
	}
}

object bomber2 {
	var position = game.center().right(1)
	
	method image() { return "guy2.png"}
	method position() { return position}
	
	method moverA(direccion) { 
		if (game.getObjectsIn(direccion.siguientePosicion(position)).isEmpty())
			position = direccion.siguientePosicion(position)
	}
	
	method ponerBomba() {
		const bomba = new Bomba(position = self.position())
		game.addVisual(bomba)
		game.schedule(1000, {=> bomba.explotar(bomba)})
	}
//	method teChocasteConElBomber(){
//		game.ground("pepeWin.jpg")
//		game.say(self,"You are the true PEPE")
//	}
}

class Bomba {
	var position
	
	method image() { return "bomba.png"}
	method position() { return position}
	method explotar(bomba){ //decidir si explotan tambien en diagonal
		game.removeVisual(bomba)
		if(not game.getObjectsIn(position.left(1)).isEmpty())
			game.removeVisual(game.getObjectsIn(position.left(1)).head())
		if(not game.getObjectsIn(position.down(1)).isEmpty())
			game.removeVisual(game.getObjectsIn(position.down(1)).head())
		if(not game.getObjectsIn(position.up(1)).isEmpty())
			game.removeVisual(game.getObjectsIn(position.up(1)).head())
		if(not game.getObjectsIn(position.right(1)).isEmpty())
			game.removeVisual(game.getObjectsIn(position.right(1)).head())			
	}
//	method teChocasteConElBomber(){
//		game.ground("pepeWin.jpg")
//		game.say(self,"You are the true PEPE")
//	}
}

class Pared {
	const position = game.origin()
//	const destruible
	
	method image() { return "stone.png"}
	method position() { return position}
//	method destruible() { return destruible}
	
//	method teChocasteConElBomber(){
//		game.ground("pepeWin.jpg")
//		game.say(self,"You are the true PEPE")
//	}
}

class ObjetoAgarrable{
	var position
	const image
	method image() { return image}
	method position() { return position}
}