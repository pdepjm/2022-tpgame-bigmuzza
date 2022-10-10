import wollok.game.*
import bomber.*
import direcciones.*

object juego {
	method iniciar() {
		self.hacerConfiguracionInicial()
		self.agregarPersonajes()
		self.configurarTeclas()
		self.agregarObjetos()
		self.configurarAcciones()
		game.start()
	}
	
	method hacerConfiguracionInicial() {
		game.title("BomberMan")
		game.width(21)
		game.height(17)
		game.cellSize(64)
	}
	
	method agregarPersonajes() {
		game.addVisual(bomber1)
		game.addVisual(bomber2)
		
	}
	
	method agregarObjetos() {
		//game.addVisual(masBomba)
		game.addVisual(masPoderBomba)
		game.addVisual(escudo)
		self.agregarParedesLimite()
		self.agregarParedesRompibles()
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
		.forEach{x => new Range(start = 0, end = 16)
			.forEach{y => if(self.esBorde(game.at(x, y)))
	  			game.addVisual(new Pared(position = game.at(x,y), destruible = false))
			}
		}
		
		new Range(start = 0, end = 20, step = 2)
		.forEach{x => new Range(start = 0, end = 16, step = 2)
			.forEach{y =>
	  			game.addVisual(new Pared(position = game.at(x,y), destruible = false))
			}
		}
	}
	
	method agregarParedesRompibles(){
		new Range(start = 0, end = 20)
		.forEach{x => new Range(start = 0, end = 16)
			.forEach{y => if((0.randomUpTo(1))>=0.5 && self.esLugarVacio(game.at(x,y)))
				game.addVisual(new Pared(position = game.at(x,y), destruible = true))
			}
		}
	}
	
	method esBorde(posicion){
		return (posicion.x() == 0 || posicion.x() == game.width()-1) || (posicion.y() == 0 || posicion.y() == game.height()-1)}
	
	method esLugarVacio(position){return game.getObjectsIn(position).isEmpty()}
	
//	method esAreaSegura(position){
//		return 
//	}
	
	method configurarTeclas() {
		//Jugador 1: wasd + Espacio
		keyboard.w().onPressDo({bomber1.moverA(arriba)})
		keyboard.d().onPressDo({bomber1.moverA(derecha)})
		keyboard.s().onPressDo({bomber1.moverA(abajo)}) 
		keyboard.a().onPressDo({bomber1.moverA(izquierda)})
		keyboard.space().onPressDo({bomber1.ponerBomba()})
		
		//Jugador 2:  ↑ ↓ ← → + Enter
		keyboard.right().onPressDo({bomber2.moverA(derecha)})
		keyboard.up().onPressDo({bomber2.moverA(arriba)})
		keyboard.down().onPressDo({bomber2.moverA(abajo)}) 
		keyboard.left().onPressDo({bomber2.moverA(izquierda)})
		keyboard.enter().onPressDo({bomber2.ponerBomba()})
	}
	
	method configurarAcciones() {
		// el colide del bomber hace ruido con cualquier objeto con el que haga colide
		game.onCollideDo(masBomba, {bomber => bomber.obtener(masBomba)})
		game.onCollideDo(masPoderBomba, {bomber => bomber.obtener(masPoderBomba)})
		game.onCollideDo(escudo, {bomber => bomber.obtener(escudo)})
	}
}
