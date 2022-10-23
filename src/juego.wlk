import wollok.game.*
import bomber.*
import direcciones.*

object juego {
	method iniciar() {
		self.hacerConfiguracionInicial()
		self.agregarPersonajes()
		self.configurarTeclas()
		self.agregarObjetos()
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
		self.agregarScore()
		//tests.generarTestPowerUps()
		self.agregarParedesLimite()
		self.agregarParedesRompibles()
	}
	
	method agregarScore() {
		new Range(start = 0, end = 20)
		.forEach{x => new Range(start = 14, end = 17)
			.forEach{y => if(self.esScore(game.at(x, y)))
	  			game.addVisual(new ScoreDef(position = game.at(x,y), image = "scoreBackground.png"))
	  		}
		}
		bomber1.agregarScore()
		bomber2.agregarScore()
		game.addVisual(new ScoreDef(position = game.at(0,16), image = "scoreBomber1r.png"))
		game.addVisual(new ScoreDef(position = game.at(0,15), image = "scoreBomber2r.png"))
		//visuales.agregar()
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
			.forEach{y => if((0.randomUpTo(1))>=0.5 and (self.esLugarVacio(game.at(x,y))))
				game.addVisual(new Pared(position = game.at(x,y), destruible = true))
			}
		}
	}
	
	method esBorde(posicion){
		return (posicion.x() == 0 || posicion.x() == game.width()-1) || (posicion.y() == 0 || posicion.y() == game.height()-3)}
	
	method esScore(posicion){
		return (posicion.x() == 0 || posicion.x() == game.width()-1) || (posicion.y() == 0 || posicion.y() > game.height()-3)}
		
	method esLugarVacio(position) = game.getObjectsIn(position).isEmpty() and !self.esAreaSegura(bomber1, position) and !self.esAreaSegura(bomber2, position)
	
	method esAreaSegura(bomber, posicion) = (bomber == bomber1 and [game.at(1,1), game.at(1,2), game.at(2,1)].contains(posicion)) or (bomber == bomber2 and [game.at(18,13), game.at(19,13), game.at(19,12)].contains(posicion))
	
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
	
	method hayGanador() = !bomber1.bomberVivo() or !bomber2.bomberVivo()  
}
