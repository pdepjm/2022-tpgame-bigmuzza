import wollok.game.*
import juego.*
import direcciones.*

class Bomber inherits EntidadPisable {
	
	var position
	var nroBomber
	var pieIzquierdo = true
	var poderBomba = 1
	var cantidadBombas = 1
	var tieneEscudo = false
	var direccion = abajo
	
	method position() = position
	
	method image() = "Bomber" + nroBomber + direccion.imagenDelBomber(self) + (if(pieIzquierdo) "1" else "2") + ".png"
	
	method moverA(dir) {
		if (self.direccionValida(dir)){
			direccion = dir
			pieIzquierdo = !pieIzquierdo		
			position = dir.siguientePosicion(position)
		}
	}
	
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
	
	method tieneEscudo() = tieneEscudo
	
	method activarEscudo() {
		tieneEscudo = true
	}
	
	method desactivarEscudo() {
		tieneEscudo = false
	}
	
	method obtener(powerUp) {
		powerUp.efecto(self)
		game.removeVisual(powerUp)
	}
}

const bomber1 = new Bomber(position = game.center().left(1), nroBomber = "1")
const bomber2 = new Bomber(position = game.center().right(1), nroBomber = "2")

class Explosion inherits EntidadPisable{
	
	var position 
	var imagenCentro = "explosion1centro.png"
	const poderExplosion
	
	method explotar(){
		self.animacion()
		orientaciones.forEach({dir => 
			self.explotarEnDireccion(dir)
		})
	}
	
	method explotarEnDireccion(dir){
		if (poderExplosion > 0 and !self.hayIrrompibleEn(dir)){
		
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
	
	method image() { 
		if(destruible)
			return "Brick.png"
		else
			return "Wall.png"
	}
	
	method destruirse(){
		if(destruible)
			game.removeVisual(self)
	}
	method position() { return position}
	method destruible() { return destruible}
}

class PowerUp inherits EntidadPisable {
	const position
	method efecto(persona)
	//method image() = image
	method position() = position
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
		visuales.agregar(persona)
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

object visuales {
	method agregar() {
		const hpBomber1 = new Score(position = game.at(4,16), image = "hpFull.png")
		const hpBomber2 = new Score(position = game.at(4,15), image = "hpFull.png")
		
		game.addVisual(hpBomber1)
		game.addVisual(hpBomber2)
	}
	
	method agregar(persona) {
		const shieldBomber1 = new Score(position = game.at(6,16), image = "shield.png")
		const shieldBomber2 = new Score(position = game.at(6,15), image = "shield.png")
		
		if (persona == bomber1)
			game.addVisual(shieldBomber1)
		else
			game.addVisual(shieldBomber2)
	}
}

class ScoreBackground {
	const property position
	const property image = "scoreBackground.png"
}

class Score{
	const property position
	var property image
}

class EntidadPisable {
	method esPisable() = true
}

class EntidadNoPisable {
	method esPisable() = false
}



