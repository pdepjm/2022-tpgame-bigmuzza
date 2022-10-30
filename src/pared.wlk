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
			if (valor < 0.4) { 
			const power = self.crearPowerUp() 
			game.addVisual(power) 
			game.onCollideDo(power, { bomber => bomber.obtener(power)})
		}
	}
	
	method crearPowerUp(){
		if (valor < 0.15)
			return new Escudo(position = position)
		else if (valor >= 0.15 and valor < 0.2)
			return new MasPoderBomba(position = position)
		else
			return new MasBomba(position = position)
	}	
	
	method position() {
		return position
	}

	method destruible() {
		return destruible
	}

}