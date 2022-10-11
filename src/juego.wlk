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
		game.ground("background.png")
	}
	
	method agregarPersonajes() {
		game.addVisual(bomber1)
		game.addVisual(bomber2)
		
	}
	
	method agregarObjetos() {
		game.addVisual(masBomba)
		//game.addVisual(masPoderBomba)
		game.addVisual(escudo)
		game.addVisual(escudo2)
		self.agregarScore()
		self.agregarParedesLimite()
		self.agregarParedesRompibles()
	}
	
	method agregarScore() {
		new Range(start = 0, end = 20)
		.forEach{x => new Range(start = 14, end = 17)
			.forEach{y => if(self.esScore(game.at(x, y)))
	  			game.addVisual(new ScoreBackground(position = game.at(x,y)))
	  		}
		}
		game.addVisual(new ScoreName(position = game.at(0,16), image = "scoreBomber1r.png"))
		game.addVisual(new ScoreName(position = game.at(0,15), image = "scoreBomber2r.png"))
	}

//doble bucle, tipico de C
	method agregarParedesLimite() {
		new Range(start = 0, end = 20)
		.forEach{x => new Range(start = 0, end = 14)
			.forEach{y => if(self.esBorde(game.at(x, y)))
	  			game.addVisual(new Pared(position = game.at(x,y), destruible = false))
			}
		}
		
		new Range(start = 0, end = 20, step = 2)
		.forEach{x => new Range(start = 0, end = 14, step = 2)
			.forEach{y =>
	  			game.addVisual(new Pared(position = game.at(x,y), destruible = false))
			}
		}
	}
	
	method agregarParedesRompibles(){
		new Range(start = 0, end = 20)
		.forEach{x => new Range(start = 0, end = 14)
			.forEach{y => if((0.randomUpTo(1))>=0.5 && self.esLugarVacio(game.at(x,y)))
				game.addVisual(new Pared(position = game.at(x,y), destruible = true))
			}
		}
	}
	
	method esBorde(posicion){
		return (posicion.x() == 0 || posicion.x() == game.width()-1) || (posicion.y() == 0 || posicion.y() == game.height()-3)}
	
	method esScore(posicion){
		return (posicion.x() == 0 || posicion.x() == game.width()-1) || (posicion.y() == 0 || posicion.y() > game.height()-3)}
		
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
		//game.onCollideDo(masPoderBomba, {bomber => bomber.obtener(masPoderBomba)})
		game.onCollideDo(escudo, {bomber => bomber.obtener(escudo)})
		game.onCollideDo(escudo2, {bomber => bomber.obtener(escudo2)})
	}
}
