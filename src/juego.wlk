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
		game.width(21)
		game.height(21)
		//game.boardGround("pepe.jpg")
	}
	
	method agregarPersonajes() {
//		self.agregarBombers()
		game.addVisual(bomber1)
		game.addVisual(bomber2)
	}
	method agregarObjetos() {
		self.agregarParedesLimite()
		self.agregarParedesRompibles()
//		self.agregarAgarrable()
	}
	
//	method agregarAgarrable(){
//		const agarrable = new ObjetoAgarrable(position = game.at(10,10), image = "bombaAgarrable.png") 
//		game.addVisual(agarrable)
//	}

// otra opcion mas "normal" (?)
//	method agregarPared() {
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(value,0)))}
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(0,value)))}
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(19,value)))}
//		new Range(start = 0, end = 19).forEach{value => game.addVisual(new Pared(position = game.at(value,19)))}
//	}

//doble bucle, tipico de C
	method agregarParedesLimite() {
		new Range(start = 0, end = 20)
		.forEach{x => new Range(start = 0, end = 20)
			.forEach{y => if(self.esBorde(game.at(x, y)))
	  			game.addVisual(new Pared(position = game.at(x,y), destruible = false))
			}
		}
		
//		new Range(start = 0, end = 20, step = 2)
//		.forEach{x => new Range(start = 0, end = 20, step = 2)
//			.forEach{y =>
//	  			game.addVisual(new Pared(position = game.at(x,y), destruible = false))
//			}
//		}
	}
	
	method agregarParedesRompibles(){
		new Range(start = 0, end = 20)
		.forEach{x => new Range(start = 0, end = 20)
			.forEach{y => if((0.randomUpTo(1))>=0.5)
				game.addVisual(new Pared(position = game.at(x,y), destruible = true))
			}
		}
	}
	
	method esBorde(posicion){
		if(posicion.x() == 0 || posicion.x() == 20) 
			return true
		if(posicion.y() == 0 || posicion.y() == 20)
			return true
		else
			return false
	}
	
	method esLugarVacio(position){return game.getObjectsIn(position).isEmpty()}

	
//	method agregarBombers() {
//		game.addVisual(bomber1)
//		game.addVisual(bomber2)
//	}
	
	method configurarTeclas() {
		//Jugador 1: wasd + espacio
		keyboard.w().onPressDo({bomber1.moverA(arriba)})
		keyboard.d().onPressDo({bomber1.moverA(derecha)})
		keyboard.s().onPressDo({bomber1.moverA(abajo)}) 
		keyboard.a().onPressDo({bomber1.moverA(izquierda)})
		keyboard.space().onPressDo({bomber1.ponerBomba()})
		
		//Jugador 2:  + Enter
		keyboard.right().onPressDo({bomber2.moverA(derecha)})
		keyboard.up().onPressDo({bomber2.moverA(arriba)})
		keyboard.down().onPressDo({bomber2.moverA(abajo)}) 
		keyboard.left().onPressDo({bomber2.moverA(izquierda)})
		keyboard.enter().onPressDo({bomber2.ponerBomba()})
	}
}
