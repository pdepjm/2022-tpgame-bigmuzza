import wollok.game.*
import bomber.*
import direcciones.*

object juego {
	method iniciar() {
		self.hacerConfiguracionInicial()
		self.agregarPersonajes()
		self.configurarTeclas()
//		self.configurarAcciones()
		self.agregarObjetos()
		//self.configurarEntorno()
		game.start()
	}
	
	method hacerConfiguracionInicial() {
		game.title("BomberMan")
		game.width(20)
		game.height(20)
		//game.boardGround("pepe.jpg")
	}
	
	method agregarPersonajes() {
		self.agregarBombers()
	}
	method agregarObjetos() {
		self.agregarPared()
		self.agregarAgarrable()
	}
	
	method agregarAgarrable(){
		game.addVisual(new ObjetoAgarrable(position = game.at(6,6), image = "bombaAgarrable.png"))
	}

// otra opcion mas "normal" (?)
//	method agregarPared() {
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(value,0)))}
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(0,value)))}
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(19,value)))}
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(value,19)))}
//	}

//doble bucle, comun de C
	method agregarPared() {
		new Range(start = 0, end = 19)
		.forEach{x => new Range(start = 0, end = 19)
			.forEach{y => if(self.esBorde(game.at(x, y)))
	  			game.addVisual(new Pared(position = game.at(x,y)))
			}
		}
	}
	
	method esBorde(posicion){
		if(posicion.x() == 0 || posicion.x() == 19) 
			return true
		if(posicion.y() == 0 || posicion.y() == 19)
			return true
		else
			return false
	}
	
	method agregarBombers() {
		game.addVisual(bomber1)
		game.addVisual(bomber2)
	}
	
	method configurarTeclas() {
		keyboard.w().onPressDo({bomber1.moverA(arriba)})
		keyboard.d().onPressDo({bomber1.moverA(derecha)})
		keyboard.s().onPressDo({bomber1.moverA(abajo)}) 
		keyboard.a().onPressDo({bomber1.moverA(izquierda)})
		keyboard.space().onPressDo({bomber1.ponerBomba()})
		
		
		keyboard.right().onPressDo({bomber2.moverA(derecha)})
		keyboard.up().onPressDo({bomber2.moverA(arriba)})
		keyboard.down().onPressDo({bomber2.moverA(abajo)}) 
		keyboard.left().onPressDo({bomber2.moverA(izquierda)})
		keyboard.enter().onPressDo({bomber2.ponerBomba()})
	}
//	method configurarAcciones(){
//		game.onCollideDo(bomber1,{chocado => chocado.teChocasteConElBomber()})	
//	}
}
