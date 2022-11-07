import wollok.game.*
import entidades.*

class PowerUp inherits EntidadPisable {

	const position

	method efecto(persona)

	method position() = position

	method esBomba() = false

	method destruible() = true

	method destruirse() = null

}

class MasBomba inherits PowerUp {
	const image = "PlusBombPU.png"
	method image() = image
	override method efecto(persona) {
		persona.masBombas()
	}

}

class MasPoderBomba inherits PowerUp {
	const image = "UpgradeBombPU.png"
	method image() = image
	override method efecto(persona) {
		persona.masPoderBomba()
	}
}

class Escudo inherits PowerUp {
	const image = "ShieldPU.png"
	method image() = image
	override method efecto(persona) {
		persona.activarEscudo()
		//game.sound("shieldMusic.mp3").play()
		game.schedule(10000, { persona.desactivarEscudo()})
	}

}