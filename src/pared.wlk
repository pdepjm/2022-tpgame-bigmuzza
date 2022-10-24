import wollok.game.*
import powerups.*
import entidades.*

class Pared inherits EntidadNoPisable {

	const position
	const destruible
	var valor = 0

	method esBomba() = false

	method image() {
		if (destruible) return "Brick.png" else return "Wall.png"
	}

	method destruirse() {
		if (destruible) game.removeVisual(self)
		self.generarPowerUp()
	}

	method random() {
		valor = 0.randomUpTo(1)
	}

	method generarPowerUp() {
		self.random()
		if (valor < 0.15) {
			const escudo = new Escudo(position = position)
			game.addVisual(escudo)
			game.onCollideDo(escudo, { bomber => bomber.obtener(escudo)})
		} else if (valor >= 0.15 and valor < 0.2) {
			const masPoderBomba = new MasPoderBomba(position = position)
			game.addVisual(masPoderBomba)
			game.onCollideDo(masPoderBomba, { bomber => bomber.obtener(masPoderBomba)})
		} else if (valor >= 0.2 and valor < 0.4) {
			const masBomba = new MasBomba(position = position)
			game.addVisual(masBomba)
			game.onCollideDo(masBomba, { bomber => bomber.obtener(masBomba)})
		}
	}

	method position() {
		return position
	}

	method destruible() {
		return destruible
	}

}