import wollok.game.*
import entidades.*
import direcciones.*
import juego.*


class Explosion inherits EntidadPisable {

	var position
	var imagenCentro = "explosion1centro.png"
	const poderExplosion
	const property destruible = true

	method esBomba() = false

	method destruirse() = null

	method obtener(powerUp) = null

	method explotar() {
		self.animacion()
		orientaciones.forEach({ dir => self.explotarEnDireccion(dir)})
	}
	
	method explotarEnDireccion(dir) {
		if (poderExplosion > 0 and !self.hayIrrompibleEn(dir)) {
			if (!game.getObjectsIn(dir.siguientePosicion(position)).isEmpty() and !juego.hayGanador()) 
				game.getObjectsIn(dir.siguientePosicion(position)).forEach({objeto => objeto.destruirse()})
			const nuevaExplosion = new Explosion(position = dir.siguientePosicion(position), poderExplosion = poderExplosion - 1)
			nuevaExplosion.animacion()
			nuevaExplosion.explotarEnDireccion(dir)
		}
	}

	method animacion() {
		if (!game.hasVisual(self)) game.addVisual(self) // Si ya hay una animacion de explosion en un píxel, no agrego otro
		game.schedule(100, {=> imagenCentro = "explosion2centro.png"})
		game.schedule(200, {=> imagenCentro = "explosion3centro.png"})
		game.schedule(300, {=> imagenCentro = "explosion4centro.png"})
		game.schedule(400, {=> imagenCentro = "explosion3centro.png"})
		game.schedule(500, {=> imagenCentro = "explosion2centro.png"})
		game.schedule(600, {=> imagenCentro = "explosion1centro.png"})
		game.schedule(700, {=>
			if (game.hasVisual(self)) game.removeVisual(self)
		})
	}

	method image() = imagenCentro

	method position() = position

	method hayIrrompibleEn(dir) {
		return game.getObjectsIn(dir.siguientePosicion(position)).any({ objeto => !objeto.destruible() })
	}

	method hayExplosion(dir) {
		return game.getObjectsIn(dir.siguientePosicion(position)).any({ objeto => objeto.esExplosion() })
	}

}