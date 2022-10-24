import wollok.game.*
import entidades.*
import explosion.*
import juego.*

class Bomba inherits EntidadNoPisable {

	var position
	var imagenBomba = "Bomb1.png"
	const poder
	const property destruible = true
	var yaExplote = false

	method destruirse() {
		self.explotar(self)
	}

	method esExplosion() = false

	method esBomba() = true

	method explotar(bomba) {
		if (!yaExplote || !juego.hayGanador()) {
			yaExplote = true
			if (game.hasVisual(bomba)) game.removeVisual(bomba)
			const explosion = new Explosion(position = self.position(), poderExplosion = poder)
			explosion.explotar()
		}
	}
	
	method animacion(bomba) {
		game.addVisual(bomba)
		game.onCollideDo(bomba, { objeto =>
			if (objeto.esBomba()) objeto.explotar()
		})
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
	
	method image() {
		return imagenBomba
	}

	method position() {
		return position
	}

}