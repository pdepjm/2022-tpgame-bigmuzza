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
		game.schedule(2000, {=> bomba.bombaEstadoMedio()})
		game.schedule(3000, {=> bomba.bombaEstadoFinal()})
		game.schedule(4000, {=> bomba.explotar(bomba)})
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
		game.schedule(2000, {=> bomba.bombaEstadoMedio()})
		game.schedule(3000, {=> bomba.bombaEstadoFinal()})
		game.schedule(4000, {=> bomba.explotar(bomba)})
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

class Explosion{
	var position 
	var imagenCentro = "explosion1centro.png"
	
	method primerNivel(){imagenCentro = "explosion1centro.png"}
	
	method segundoNivel(){imagenCentro = "explosion2centro.png"}
	
	method tercerNivel(){imagenCentro = "explosion3centro.png"}
	
	method cuartoNivel(){imagenCentro = "explosion4centro.png"}
	
	
	method sacarExplosion(){
		game.removeVisual(self)
	}
	
	method image() { return imagenCentro}
	method position() { return position}
	
}

class Bomba {
	var position
	var imagenBomba = "Bomb3.png"
	
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
				
		var explosion = new Explosion(position = self.position()) 				
		game.addVisual(explosion)
		game.schedule(100, {=> explosion.segundoNivel()})
		game.schedule(200, {=> explosion.tercerNivel()})
		game.schedule(300, {=> explosion.cuartoNivel()})
		game.schedule(400, {=> explosion.tercerNivel()})
		game.schedule(500, {=> explosion.segundoNivel()})
		game.schedule(600, {=> explosion.primerNivel()})
		game.schedule(700, {=> explosion.sacarExplosion()})
	}
	
	method bombaEstadoMedio(){
		imagenBomba = "Bomb2.png"
	}
	
	method bombaEstadoFinal(){
		imagenBomba = "Bomb1.png"
	}
	
	method image() { return imagenBomba}
	method position() { return position}
}

class Pared {
	const position
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