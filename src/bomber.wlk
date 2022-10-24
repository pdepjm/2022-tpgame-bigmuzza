import wollok.game.*
import juego.*
import direcciones.*
import entidades.*
import powerups.*
import bomba.*
import score.*


class Bomber inherits EntidadPisable {

	var position
	var nroBomber
	var pieIzquierdo = true
	var poderBomba = 1
	var cantidadBombas = 1
	var cantidadEscudos = 0
	var direccion = centro
	var cantidadVidas = 2
	const posScore
	const property destruible = true
	
	method nuevaDireccion(nuevaDireccion){direccion = nuevaDireccion}

	method position() = position
	
	method nroBomber() = nroBomber
	
	// Funcion re loca que elije el nombre de la foto haciendo magia
	method image() = if (cantidadVidas > 0) "Bomber" + nroBomber + direccion.imagenDelBomber(self) + (if(pieIzquierdo) "1" else "2") + ".png" else "Bomber" + nroBomber + "Dead.png"

	method moverA(dir) {
		if (self.direccionValida(dir) and self.bomberVivo()) {
			direccion = dir // con esto cambiamos la imagen del bomber
			pieIzquierdo = !pieIzquierdo
			/*if (pieIzquierdo)
				game.sound("woosh1.mp3").play()
			else 
				game.sound("woosh2.mp3").play()*/
			position = dir.siguientePosicion(position)
		}
		
	}
	

	method pieInicial(){pieIzquierdo = true}

	method pie(){
		pieIzquierdo = true
	}

	method direccionValida(dir) = game.getObjectsIn(dir.siguientePosicion(position)).all({ objeto => objeto.esPisable() })

	method ponerBomba() {
		if (cantidadBombas > 0 and self.bomberVivo() and !juego.hayGanador()) {
			cantidadBombas -= 1
			const bomba = new Bomba(position = self.position(), poder = self.poderBomba())
			bomba.animacion(bomba)
			game.schedule(2900, {=>
				bomba.explotar(bomba)

				//game.sound("explosion.mp3").play()

			})
			game.schedule(2901, { self.masBombas()})
		}
	}

	method poderBomba() = poderBomba
	
	method poderBomba(poder){poderBomba = poder}

	method masPoderBomba() {poderBomba += 1}

	method cantidadBombas() = cantidadBombas

	method masBombas(cantidad) {cantidadBombas = cantidad}
	
	method masBombas() {cantidadBombas += 1}
	
	method tieneEscudo() = cantidadEscudos > 0

	method activarEscudo() {cantidadEscudos += 1}

	method desactivarEscudo() {
		if (self.tieneEscudo()) 
			cantidadEscudos -= 1
	}

	method obtener(powerUp) {
		powerUp.efecto(self)
		game.removeVisual(powerUp)
	}

	method cantidadVidas() = cantidadVidas
	

	method cantidadVidas(cantidad){cantidadVidas = cantidad}

	method bomberVivo() = cantidadVidas > 0

	method destruirse(){
		if (self.tieneEscudo()) 
			self.desactivarEscudo() 
		else 
			self.perderVida()
	}
	
	method perderVida(){
		if (self.cantidadVidas()-1 == 0){ //si se queda sin vidas
			cantidadVidas -= 1 
			self.perder()
		}
		else cantidadVidas -= 1
	}
	
	method perder(){
		const scoreGanador = new ScoreGanador(position = game.center().left(4), bomber = self)
		game.addVisual(scoreGanador)
		//game.sound("victory.mp3").play()

	}

	method agregarScore() {
		const hpBomber = new ScoreHp(position = game.at(4, 17 - posScore), bomber = self)
		game.addVisual(hpBomber)
		const shieldBomber = new ScoreEscudo(position = game.at(6, 17 - posScore), bomber = self)
		game.addVisual(shieldBomber)
	}

	method explotar() = null

	method esBomba() = false
	
	method moverAPosicion(nuevaPosicion){position = nuevaPosicion}

	method reiniciar(){
		if(self == bomber1)
			self.moverAPosicion(game.at(1,1))
		else
			self.moverAPosicion(game.at(19,13))
		self.nuevaDireccion(centro)
		self.pieInicial()
		self.cantidadVidas(2)
		self.desactivarEscudo()
		self.masBombas(1)
		self.poderBomba(1)
	}
}















