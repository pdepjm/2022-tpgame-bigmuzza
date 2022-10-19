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

	method position() = position

	// Funcion re loca que elije el nombre de la foro haciendo magia
	method image() = if (cantidadVidas > 0) "Bomber" + nroBomber + direccion.imagenDelBomber(self) + (if(pieIzquierdo) "1" else "2") + ".png" else "Bomber" + nroBomber + "Dead.png"

	method moverA(dir) {
		if (self.direccionValida(dir) and self.bomberVivo()) {
			direccion = dir // con esto cambiamos la imagen del bomber
			if (pieIzquierdo) {
				soundManager.playSound(new SoundEffect(path = './assets/woosh1.mp3'), false)
				pieIzquierdo = !pieIzquierdo
			} else {
				soundManager.playSound(new SoundEffect(path = './assets/woosh2.mp3'), false)
				pieIzquierdo = !pieIzquierdo
			}
			position = dir.siguientePosicion(position)
		}
	}

	method direccionValida(dir) = game.getObjectsIn(dir.siguientePosicion(position)).all({ objeto => objeto.esPisable() })

	method ponerBomba() {
		if (cantidadBombas > 0 and self.bomberVivo()) {
			cantidadBombas -= 1
			const bomba = new Bomba(position = self.position(), poder = self.poderBomba())
			bomba.animacion(bomba)
			game.schedule(2900, {=>
				bomba.explotar(bomba)
				soundManager.playSound(new SoundEffect(path = './assets/explosion.mp3'), false)
			})
				// game.schedule(5000, {=> bomba.explotar(bomba)}) //Para probar funcionalidades
			game.schedule(2901, { self.masBombas()}) // esto creo que iria en la bomba, no en el bomber
		}
	}

	method poderBomba() = poderBomba

	method masPoderBomba() {
		poderBomba += 1
	}

	method cantidadBombas() = cantidadBombas

	method masBombas() {
		cantidadBombas += 1
	}

	method tieneEscudo() = cantidadEscudos > 0

	method activarEscudo() {
		cantidadEscudos += 1
	}

	method desactivarEscudo() {
		if (self.tieneEscudo()) cantidadEscudos -= 1
	}

	method obtener(powerUp) {
		powerUp.efecto(self)
		game.removeVisual(powerUp)
	}

	method cantidadVidas() = cantidadVidas

	method bomberVivo() = cantidadVidas > 0

	method destruirse() {
		if (self.tieneEscudo()) self.desactivarEscudo() else cantidadVidas -= 1
	}

	method agregarScore() {
		const hpBomber = new ScoreHp(position = game.at(4, 17 - posScore), bomber = self)
		game.addVisual(hpBomber)
		const shieldBomber = new ScoreEscudo(position = game.at(6, 17 - posScore), bomber = self)
		game.addVisual(shieldBomber)
	}

	method explotar() = null

	method esBomba() = false

}

const bomber1 = new Bomber(position = game.at(1, 1), nroBomber = "1", posScore = 1)

const bomber2 = new Bomber(position = game.at(19, 13), nroBomber = "2", posScore = 2)

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
			if (!game.getObjectsIn(dir.siguientePosicion(position)).isEmpty()) game.getObjectsIn(dir.siguientePosicion(position)).head().destruirse()
			const nuevaExplosion = new Explosion(position = dir.siguientePosicion(position), poderExplosion = poderExplosion - 1)
			nuevaExplosion.animacion()
			nuevaExplosion.explotarEnDireccion(dir)
		}
	}

	method animacion() {
		if (!game.hasVisual(self)) game.addVisual(self) // Si ya hay una animacion de explosion en un íxel, no agrego otro para optimir el juego
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

	/*method animacion(dir) { no se usa
	 * 	// mustra la animacion de los brazos de la explosion (como usamos recursividad no queda muy sincronizado ejje)
	 * 	game.addVisual(self)
	 * 	game.schedule(100, {=> imagenCentro = "explosion2mitad" + dir +".png"})
	 * 	game.schedule(200, {=> imagenCentro = "explosion3mitad" + dir +".png"})
	 * 	game.schedule(300, {=> imagenCentro = "explosion4mitad" + dir +".png"})
	 * 	game.schedule(400, {=> imagenCentro = "explosion3mitad" + dir +".png"})
	 * 	game.schedule(500, {=> imagenCentro = "explosion2mitad" + dir +".png"})
	 * 	game.schedule(600, {=> imagenCentro = "explosion1mitad" + dir +".png"})
	 * 	game.schedule(700, {=> game.removeVisual(self)})
	 }*/
	method image() {
		return imagenCentro
	}

	method position() {
		return position
	}

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
		if (!yaExplote) {
			yaExplote = true
			if (game.hasVisual(bomba)) game.removeVisual(bomba)
			const explosion = new Explosion(position = self.position(), poderExplosion = poder)
			explosion.explotar()
		}
	}

	method animacion(bomba) { // animacion anterior
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

	/*method animacion(bomba) { //animacion nueva
	 * 	//1.6 seg lento → 1 seg medio → 0.4 seg rapido
	 * 	game.addVisual(bomba)
	 * 	game.onCollideDo(bomba, {objeto => if(objeto.esBomba()) objeto.explotar()})
	 * 	game.schedule(200,  {=> imagenBomba = "Bomb2.png"}) //Empieza lento
	 * 	game.schedule(400,  {=> imagenBomba = "Bomb3.png"})
	 * 	game.schedule(600,  {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(800,  {=> imagenBomba = "Bomb1.png"})
	 * 	game.schedule(1000, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(1200, {=> imagenBomba = "Bomb3.png"}) 
	 * 	game.schedule(1400, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(1600, {=> imagenBomba = "Bomb1.png"}) //Termina lento
	 * 	
	 * 	game.schedule(1725, {=> imagenBomba = "Bomb2.png"}) //Empieza medio
	 * 	game.schedule(1850, {=> imagenBomba = "Bomb3.png"})
	 * 	game.schedule(1975, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(2100, {=> imagenBomba = "Bomb1.png"})
	 * 	game.schedule(2225, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(2350, {=> imagenBomba = "Bomb3.png"}) 
	 * 	game.schedule(2475, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(2600, {=> imagenBomba = "Bomb1.png"}) //Termina medio
	 * 	
	 * 	game.schedule(2650, {=> imagenBomba = "Bomb2.png"}) //Empieza rapido
	 * 	game.schedule(2700, {=> imagenBomba = "Bomb3.png"})
	 * 	game.schedule(2750, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(2800, {=> imagenBomba = "Bomb1.png"})
	 * 	game.schedule(2850, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(2900, {=> imagenBomba = "Bomb3.png"}) 
	 * 	game.schedule(2950, {=> imagenBomba = "Bomb2.png"})
	 * 	game.schedule(3000, {=> imagenBomba = "Bomb1.png"}) //Termina rapido
	 }*/
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

	/*method generarPowerUp(){
	 * 	self.random()
	 * 	if ( valor >= 0.4)
	 * 		null
	 * 	else {
	 * 		if (valor >= 0.2) {
	 * 			const masBomba = new MasBomba(position = position)
	 * 			game.addVisual(masBomba)
	 * 			game.onCollideDo(masBomba, {bomber => bomber.obtener(masBomba)})
	 * 		}
	 * 		else if (valor >= 0.15) {
	 * 				const masPoderBomba = new MasPoderBomba(position = position)
	 * 				game.addVisual(masPoderBomba)
	 * 				game.onCollideDo(masPoderBomba, {bomber => bomber.obtener(masPoderBomba)})
	 * 			}
	 * 			else {
	 * 				const escudo = new Escudo(position = position)
	 * 				game.addVisual(escudo)
	 * 				game.onCollideDo(escudo, {bomber => bomber.obtener(escudo)})
	 * 			}
	 * 	}
	 }*/
	method generarPowerUp() { // la rehice porque no entedí la version anterior xd
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

	/*method generarPowerUp(){ //para pruebas xd
	 * 		const masBomba = new MasBomba(position = position)
	 * 		game.addVisual(masBomba)
	 * 		game.onCollideDo(masBomba, {bomber => bomber.obtener(masBomba)})
	 }*/
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

	// method image() = image
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

