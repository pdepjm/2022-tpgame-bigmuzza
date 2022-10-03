import wollok.game.*
import juego.*

class Bomber {
	var position
	var imagenBomber
	var imgArriba
	var imgArribaAlt
	var imgAbajo
	var imgAbajoAlt
	var imgDerecha
	var imgDerechaAlt
	var imgIzquierda
	var imgIzquierdaAlt
	var alternarArriba = true
	var alternarAbajo = true
	var alternarDerecha = true
	var alternarIzquierda = true
	
	method position() = position
	method image() = imagenBomber	
	method moverA(direccion) { 
		if (game.getObjectsIn(direccion.siguientePosicion(position)).isEmpty())
			position = direccion.cambiarAPosicion(position, self)
	}
	
	method ponerBomba() {
		const bomba = new Bomba(position = self.position())
		bomba.animacion(bomba)
		game.schedule(2900, {=> bomba.explotar(bomba)})
	}
	
	method cambiarImagenArriba(){
		if(alternarArriba){
			alternarArriba = false
			imagenBomber = imgArriba
		}
		else {
			alternarArriba = true
			imagenBomber = imgArribaAlt
		}
	}
	
	method cambiarImagenAbajo(){
		if(alternarAbajo){
			alternarAbajo = false
			imagenBomber = imgAbajo
		}
		else {
			alternarAbajo = true
			imagenBomber = imgAbajoAlt
		}
	}
	
	method cambiarImagenDerecha(){
		if(alternarDerecha){
			alternarDerecha = false
			imagenBomber = imgDerecha
		}
		else {
			alternarDerecha = true
			imagenBomber = imgDerechaAlt
		}
	}
	
	method cambiarImagenIzquierda(){
		if(alternarIzquierda){
			alternarIzquierda = false
			imagenBomber = imgIzquierda
		}
		else {
			alternarIzquierda = true
			imagenBomber = imgIzquierdaAlt
		}
	}
}
const bomber1 = new Bomber(position = game.center().left(1), imagenBomber = "Bomber1.png", imgArriba = "Bomber1Up1.png", imgArribaAlt = "Bomber1Up2.png", imgAbajo = "Bomber1Down1.png", imgAbajoAlt = "Bomber1Down2.png", imgDerecha = "Bomber1Right1.png", imgDerechaAlt = "Bomber1Right2.png", imgIzquierda = "Bomber1Left1.png", imgIzquierdaAlt = "Bomber1Left2.png")
const bomber2 = new Bomber(position = game.center().right(1), imagenBomber = "Bomber2.png", imgArriba = "Bomber2Up1.png", imgArribaAlt = "Bomber2Up2.png", imgAbajo = "Bomber2Down1.png", imgAbajoAlt = "Bomber2Down2.png", imgDerecha = "Bomber2Right1.png", imgDerechaAlt = "Bomber2Right2.png", imgIzquierda = "Bomber2Left1.png", imgIzquierdaAlt = "Bomber2Left2.png")

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
	var imagenBomba = "Bomb1.png"
	
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
				
		const explosion = new Explosion(position = self.position()) 				
		game.addVisual(explosion)
		game.schedule(100, {=> explosion.segundoNivel()})
		game.schedule(200, {=> explosion.tercerNivel()})
		game.schedule(300, {=> explosion.cuartoNivel()})
		game.schedule(400, {=> explosion.tercerNivel()})
		game.schedule(500, {=> explosion.segundoNivel()})
		game.schedule(600, {=> explosion.primerNivel()})
		game.schedule(700, {=> explosion.sacarExplosion()})
	}
	
	method animacion(bomba) {
		game.addVisual(bomba)
		game.schedule(333, {=> imagenBomba = "Bomb2.png"})
		game.schedule(666, {=> imagenBomba = "Bomb3.png"})
		game.schedule(999, {=> imagenBomba = "Bomb1.png"})
		game.schedule(1333, {=> imagenBomba = "Bomb2.png"})
		game.schedule(1666, {=> imagenBomba = "Bomb3.png"})
		game.schedule(1999, {=> imagenBomba = "Bomb1.png"})
		game.schedule(2333, {=> imagenBomba = "Bomb2.png"})
		game.schedule(2666, {=> imagenBomba = "Bomb3.png"})
		game.schedule(2999, {=> imagenBomba = "Bomb1.png"})
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