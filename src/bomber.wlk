import wollok.game.*
import juego.*
import direcciones.*

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
	var direccion = abajo
	var cantidadVidas = 2
	const posScore
	const property destruible = true
	
	method position() = position
	
	method image() = if (cantidadVidas > 0) "Bomber" + nroBomber + direccion.imagenDelBomber(self) + (if(pieIzquierdo) "1" else "2") + ".png"
					else "Bomber" + nroBomber + "Dead.png"
	
	method moverA(dir) {
		if (self.direccionValida(dir) and self.bomberVivo()){
			direccion = dir
			pieIzquierdo = !pieIzquierdo		
			position = dir.siguientePosicion(position)
		}
	}
	
	method bomberVivo() = cantidadVidas > 0
	
	method direccionValida(dir) = game.getObjectsIn(dir.siguientePosicion(position)).all({objeto => objeto.esPisable()})
	
	
	method ponerBomba() {
		if (cantidadBombas > 0){
			cantidadBombas -= 1
			const bomba = new Bomba(position = self.position(), poder = self.poderBomba())
			bomba.animacion(bomba)
			game.schedule(2900, {=> bomba.explotar(bomba)})
			game.schedule(2901, {self.masBombas()})
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
		if (self.tieneEscudo())
			cantidadEscudos -= 1
	}
	
	method obtener(powerUp) {
		powerUp.efecto(self)
		game.removeVisual(powerUp)
	}
	
	method cantidadVidas() = cantidadVidas
	
	method destruirse(){
		if (self.tieneEscudo()) 
			self.desactivarEscudo()
		else cantidadVidas -= 1
			
	}
	
	method agregarScore(){
		const hpBomber = new ScoreHp(position = game.at(4,17 - posScore), bomber = self)
		game.addVisual(hpBomber)
		
		const shieldBomber = new ScoreEscudo(position = game.at(6,17 - posScore), bomber = self)
		game.addVisual(shieldBomber)
	}
}

const bomber1 = new Bomber(position = game.center().left(1), nroBomber = "1", posScore = 1)
const bomber2 = new Bomber(position = game.center().right(1), nroBomber = "2", posScore = 2)

class Explosion inherits EntidadPisable{
	
	var position 
	var imagenCentro = "explosion1centro.png"
	const poderExplosion
	const property destruible = true
	
	method destruirse() = null
	
	method obtener(powerUp) = null
	
	method explotar(){
		self.animacion()
		orientaciones.forEach({dir => 
			self.explotarEnDireccion(dir)
		})
	}
	
	method explotarEnDireccion(dir){
		if (poderExplosion > 0 and !self.hayIrrompibleEn(dir)){
			if(!game.getObjectsIn(dir.siguientePosicion(position)).isEmpty())
				game.getObjectsIn(dir.siguientePosicion(position)).head().destruirse()
			const nuevaEx = new Explosion(position = dir.siguientePosicion(position), poderExplosion=poderExplosion-1)
			nuevaEx.animacion()
			nuevaEx.explotarEnDireccion(dir)
		}
	}
	
	method animacion() {
		//Animacion anterior
		game.addVisual(self)
		game.schedule(100, {=> imagenCentro = "explosion2centro.png"})
		game.schedule(200, {=> imagenCentro = "explosion3centro.png"})
		game.schedule(300, {=> imagenCentro = "explosion4centro.png"})
		game.schedule(400, {=> imagenCentro = "explosion3centro.png"})
		game.schedule(500, {=> imagenCentro = "explosion2centro.png"})
		game.schedule(600, {=> imagenCentro = "explosion1centro.png"})
		game.schedule(700, {=> game.removeVisual(self)})
		
		//Nueva animacion
	}
	
	method animacion(dir) {
		// mustra la animacion de los brazos de la explosion (como usamos recursividad no queda muy sincronizado ejje)
		game.addVisual(self)
		game.schedule(100, {=> imagenCentro = "explosion2mitad" + dir +".png"})
		game.schedule(200, {=> imagenCentro = "explosion3mitad" + dir +".png"})
		game.schedule(300, {=> imagenCentro = "explosion4mitad" + dir +".png"})
		game.schedule(400, {=> imagenCentro = "explosion3mitad" + dir +".png"})
		game.schedule(500, {=> imagenCentro = "explosion2mitad" + dir +".png"})
		game.schedule(600, {=> imagenCentro = "explosion1mitad" + dir +".png"})
		game.schedule(700, {=> game.removeVisual(self)})
	}
	
	method image() { return imagenCentro}
	method position() { return position}
	
	method hayIrrompibleEn(dir) {
		 return game.getObjectsIn(dir.siguientePosicion(position)).any({objeto => !objeto.destruible()})
	}
	
}

class Bomba inherits EntidadNoPisable{
	var position
	var imagenBomba = "Bomb1.png"
	const poder
	const property destruible = true
	
	method destruirse(){
		self.explotar(self)
	} 
	
	method explotar(bomba){
		game.removeVisual(bomba)
				
		const explosion = new Explosion(position = self.position(), poderExplosion = poder) 				
		explosion.explotar()
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

class Pared inherits EntidadNoPisable {
	const position
	const destruible
	var valor = 0
	method image() { 
		if(destruible)
			return "Brick.png"
		else
			return "Wall.png"
	}
	
	method destruirse(){
		if(destruible)
			game.removeVisual(self)
		self.generarPowerUp()
	}
	
	method random() {valor = 0.randomUpTo(1)}  
	
	method generarPowerUp(){
		self.random()
		if ( valor >= 0.4) {
			null
		}
		else {if (valor >= 0.2) {
				const masBomba = new MasBomba(position = position)
				game.addVisual(masBomba)
				game.onCollideDo(masBomba, {bomber => bomber.obtener(masBomba)})
			}
			else if (valor >= 0.15) {
					const masPoderBomba = new MasPoderBomba(position = position)
					game.addVisual(masPoderBomba)
					game.onCollideDo(masPoderBomba, {bomber => bomber.obtener(masPoderBomba)})
				}
				else {
					const escudo = new Escudo(position = position)
					game.addVisual(escudo)
					game.onCollideDo(escudo, {bomber => bomber.obtener(escudo)})
				}
		}
	}
	
	method position() { return position}
	method destruible() { return destruible}
}

class PowerUp inherits EntidadPisable {
	const position
	method efecto(persona)
	//method image() = image
	method position() = position
	
	method destruible() = true
	method destruirse() = null
}

class MasBomba inherits PowerUp{
	const image = "PlusBombPU.png"
	method image() = image
	
	override method efecto(persona) {
		persona.masBombas()
	}
}

class MasPoderBomba inherits PowerUp{
	const image = "UpgradeBombPU.png"
	method image() = image
	
	override method efecto(persona) {
		persona.masPoderBomba()
	}
}

class Escudo inherits PowerUp{
	const image = "ShieldPU.png"
	method image() = image
	
	override method efecto(persona) {
		persona.activarEscudo()
		game.schedule(10000, {persona.desactivarEscudo()})

	}
}


object tests {
	method generarTestPowerUps() {
		const masBomba = new MasBomba(position = game.center().up(3))
		game.addVisual(masBomba)
		game.onCollideDo(masBomba, {bomber => bomber.obtener(masBomba)})
		const masPoderBomba = new MasPoderBomba(position = game.center().up(5))
		game.addVisual(masPoderBomba)
		game.onCollideDo(masPoderBomba, {bomber => bomber.obtener(masPoderBomba)})
		const escudo = new Escudo(position = game.center().down(3))
		game.addVisual(escudo)
		game.onCollideDo(escudo, {bomber => bomber.obtener(escudo)})
	}
}

class Score {
	const property position
	var bomber
	method image()
}

class ScoreHp inherits Score{
	override method image(){
		return "hp" + bomber.cantidadVidas() + ".png"
	}
}

class ScoreEscudo inherits Score{
	override method image(){
		return if (bomber.tieneEscudo()) "shield.png" else "scoreBackground.png"
	}
}

class ScoreDef {
	const property position
	const property image 
}



