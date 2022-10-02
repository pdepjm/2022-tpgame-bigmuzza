import wollok.game.*
import juego.*

object bomber1 {
	var position = game.center().left(1)
	var imagenBomber1 = "Bomber1.png"
	
	var alternarArriba = true
	var alternarAbajo = true
	var alternarDerecha = true
	var alternarIzquierda = true	
	
	method moverA(direccion) { 
		if (game.getObjectsIn(direccion.siguientePosicion(position)).isEmpty())
			position = direccion.cambiarAPosicion(position, self)
	}
	
	method ponerBomba() {
		const bomba = new Bomba(position = self.position())
		game.addVisual(bomba)
		game.schedule(1000, {=> bomba.explotar(bomba)})
	}
	
	method cambiarImagenArriba(){
		if(alternarArriba){
			alternarArriba = false
			imagenBomber1 = "Bomber1Up1.png"
		}
		else if(not alternarArriba){
			alternarArriba = true
			imagenBomber1 = "Bomber1Up2.png"
		}
	}
	
	method cambiarImagenAbajo(){
		if(alternarAbajo){
			alternarAbajo = false
			imagenBomber1 = "Bomber1Down1.png"
		}
		else if(not alternarAbajo){
			alternarAbajo = true
			imagenBomber1 = "Bomber1Down2.png"
		}
	}
	
	method cambiarImagenDerecha(){
		if(alternarDerecha){
			alternarDerecha = false
			imagenBomber1 = "Bomber1Right1.png"
		}
		else if(not alternarDerecha){
			alternarDerecha = true
			imagenBomber1 = "Bomber1Right2.png"
		}
	}
	
	method cambiarImagenIzquierda(){
		if(alternarIzquierda){
			alternarIzquierda = false
			imagenBomber1 = "Bomber1Left1.png"
		}
		else if(not alternarIzquierda){
			alternarIzquierda = true
			imagenBomber1 = "Bomber1Left2.png"
		}
	}	
	
	method image() { return imagenBomber1}
	method position() { return position}
}

object bomber2 {
	var position = game.center().right(1)
	var imagenBomber2 = "Bomber2.png"
	
	var alternarArriba = true
	var alternarAbajo = true
	var alternarDerecha = true
	var alternarIzquierda = true
	
	method moverA(direccion) { 
		if (game.getObjectsIn(direccion.siguientePosicion(position)).isEmpty())
			position = direccion.cambiarAPosicion(position, self)
	}
	
	method ponerBomba() {
		const bomba = new Bomba(position = self.position())
		game.addVisual(bomba)
		game.schedule(1000, {=> bomba.explotar(bomba)})
	}
	
	method cambiarImagenArriba(){
		if(alternarArriba){
			alternarArriba = false
			imagenBomber2 = "Bomber2Up1.png"
		}
		else if(not alternarArriba){
			alternarArriba = true
			imagenBomber2 = "Bomber2Up2.png"
		}
	}
	
	method cambiarImagenAbajo(){
		if(alternarAbajo){
			alternarAbajo = false
			imagenBomber2 = "Bomber2Down1.png"
		}
		else if(not alternarAbajo){
			alternarAbajo = true
			imagenBomber2 = "Bomber2Down2.png"
		}
	}
	
	method cambiarImagenDerecha(){
		if(alternarDerecha){
			alternarDerecha = false
			imagenBomber2 = "Bomber2Right1.png"
		}
		else if(not alternarDerecha){
			alternarDerecha = true
			imagenBomber2 = "Bomber2Right2.png"
		}
	}
	
	method cambiarImagenIzquierda(){
		if(alternarIzquierda){
			alternarIzquierda = false
			imagenBomber2 = "Bomber2Left1.png"
		}
		else if(not alternarIzquierda){
			alternarIzquierda = true
			imagenBomber2 = "Bomber2Left2.png"
		}
	}
	
	method image() { return imagenBomber2} 
	method position() { return position}
}

class Bomba {
	var position
	
	method image() { return "bomba.png"}
	method position() { return position}
	method explotar(bomba){
		game.removeVisual(bomba)
		if(not game.getObjectsIn(position.left(1)).isEmpty())
			if(game.getObjectsIn(position.left(1)).head().destruible())
				game.removeVisual(game.getObjectsIn(position.left(1)).head())
		if(not game.getObjectsIn(position.down(1)).isEmpty())
			if(game.getObjectsIn(position.down(1)).head().destruible())
				game.removeVisual(game.getObjectsIn(position.down(1)).head())
		if(not game.getObjectsIn(position.up(1)).isEmpty())
			if(game.getObjectsIn(position.up(1)).head().destruible())
				game.removeVisual(game.getObjectsIn(position.up(1)).head())
		if(not game.getObjectsIn(position.right(1)).isEmpty())
			if(game.getObjectsIn(position.right(1)).head().destruible())
				game.removeVisual(game.getObjectsIn(position.right(1)).head())			
	}
}

class Pared {
	const position = game.origin()
	const destruible
	
	method image() { 
		if(destruible)
			return "Brick.png"
		else
			return "Wall.png"
	}
	method position() { return position}
	method destruible() { return destruible}
}

class ObjetoAgarrable{
	var position
	const image
	method image() { return image}
	method position() { return position}
}