import wollok.game.*
import juego.*
import direcciones.*
import soundProducer.*
import soundManager.*

class EntidadPisable {
	method esPisable() = true
}

class EntidadNoPisable {
	method esPisable() = false
}

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
			if (pieIzquierdo) {
				soundManager.playSound(woosh1, false)
				pieIzquierdo = !pieIzquierdo
			} else {
				soundManager.playSound(woosh2, false)
				pieIzquierdo = !pieIzquierdo
			}
			position = dir.siguientePosicion(position)
		}
	}
	
	method pieInicial(){pieIzquierdo = true}

	method direccionValida(dir) = game.getObjectsIn(dir.siguientePosicion(position)).all({ objeto => objeto.esPisable() })

	method ponerBomba() {
		if (cantidadBombas > 0 and self.bomberVivo() and !juego.hayGanador()) {
			cantidadBombas -= 1
			const bomba = new Bomba(position = self.position(), poder = self.poderBomba())
			bomba.animacion(bomba)
			game.schedule(2900, {=>
				bomba.explotar(bomba)
				soundManager.playSound(explosion, false)
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
		soundManager.stopAllSongs()
		soundManager.playSound(new SoundEffect(path = './assets/victory.mp3'), true)			
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
			if (!game.getObjectsIn(dir.siguientePosicion(position)).isEmpty() and !juego.hayGanador()) game.getObjectsIn(dir.siguientePosicion(position)).head().destruirse()
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
		soundManager.playSound(shield, false)
		game.schedule(10000, { persona.desactivarEscudo()})
	}

}

object tests {

	method generarTestPowerUps() {
		const masBomba = new MasBomba(position = game.center().up(3))
		game.addVisual(masBomba)
		game.onCollideDo(masBomba, { bomber => bomber.obtener(masBomba)})
		const masPoderBomba = new MasPoderBomba(position = game.center().up(5))
		game.addVisual(masPoderBomba)
		game.onCollideDo(masPoderBomba, { bomber => bomber.obtener(masPoderBomba)})
		const escudo = new Escudo(position = game.center().down(3))
		game.addVisual(escudo)
		game.onCollideDo(escudo, { bomber => bomber.obtener(escudo)})
	}
}

class Score {

	const property position
	var bomber

	method image()

}

class ScoreHp inherits Score {

	override method image() {
		return "hp" + bomber.cantidadVidas() + ".png"
	}

}

class ScoreEscudo inherits Score {

	override method image() {
		return if (bomber.tieneEscudo()) "shield.png" else "scoreBackground.png"
	}

}

class ScoreDef {

	const property position
	const property image

}
class ScoreGanador inherits Score{
	
	override method image() = if(bomber.nroBomber() == "1")return "winBomber2.png" else return "winBomber1.png"
	
}


//Bombers
const bomber1 = new Bomber(position = game.at(1, 1), nroBomber = "1", posScore = 1)
const bomber2 = new Bomber(position = game.at(19, 13), nroBomber = "2", posScore = 2)
const bombers = [bomber1, bomber2]

//Efectos de sonido
const woosh1 = new SoundEffect(path = './assets/woosh1.mp3')
const woosh2 = new SoundEffect(path = './assets/woosh2.mp3')
const shield = new SoundEffect(path = './assets/shieldMusic.mp3')
const explosion = new SoundEffect(path = './assets/explosion.mp3')

//Musica
const musica = new SoundEffect(path = './assets/gameMusic.mp3')

