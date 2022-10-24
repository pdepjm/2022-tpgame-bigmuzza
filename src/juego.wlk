import wollok.game.*
import bomber.*
import direcciones.*
import soundProducer.*
import soundManager.*

object juego {
	
<<<<<<< HEAD
	//var alternarMusica = true
=======
	var alternarMusica = true
>>>>>>> branch 'master' of https://github.com/pdepjm/2022-tpgame-bigmuzza.git
	
	method iniciar() {
<<<<<<< HEAD
		self.configuracion()
=======
		self.configuracionInicial()
		self.configurarTeclas()
		self.agregarPersonajes()
		self.agregarObjetos()
>>>>>>> branch 'master' of https://github.com/pdepjm/2022-tpgame-bigmuzza.git
		game.start()		
	}
	
<<<<<<< HEAD
	method configuracion(){
		self.configuracionJuego()
		self.configurarTeclas()
		self.agregarPersonajes()
		self.agregarObjetos()
		//self.musicas()
	}
	
	/*method musicas(){
		game.sound(musicas).play()
	}*/
	
	method configuracionJuego() {
=======
	method configuracionInicial() {
>>>>>>> branch 'master' of https://github.com/pdepjm/2022-tpgame-bigmuzza.git
		game.title("BomberMan")
		game.width(21)
		game.height(17)
		game.cellSize(64)
		game.ground("background.png")
	}
	
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
		
		//Alternar musica
		keyboard.m().onPressDo({self.alternarMusica()})
		
		//Cerrar juego
		keyboard.q().onPressDo({game.stop()})
		
		//Reiniciar juego
		keyboard.r().onPressDo({self.reiniciarJuego()})
	}
	
	method agregarPersonajes() {
		game.addVisual(bomber1)
		game.addVisual(bomber2)
	}
<<<<<<< HEAD
		
=======
	
	method agregarPersonajesConPosicion() {
		game.addVisualIn(bomber1, game.at(1, 1))
		game.addVisualIn(bomber2, game.at(19, 13))
	}
	
	
	
	method sacarPersonajes() {
		game.removeVisual(bomber1)
		game.removeVisual(bomber2)
	}
	
>>>>>>> branch 'master' of https://github.com/pdepjm/2022-tpgame-bigmuzza.git
	method agregarObjetos() {
		self.agregarScore()
		self.agregarParedesLimite()
		self.agregarParedesIrrompibles()
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
	}

	method agregarParedesLimite() {
		//Paredes Verticales		
		(game.height()-2).times({ i => game.addVisual(new Pared(position = game.at(0,i-1), destruible = false))})
		(game.height()-2).times({ i => game.addVisual(new Pared(position = game.at(game.width()-1,i-1), destruible = false))}) 
		//Paredes Horizontales
		(game.width()-1).times({ i => game.addVisual(new Pared(position = game.at(i-1,0), destruible = false))})
		(game.width()-1).times({ i => game.addVisual(new Pared(position = game.at(i,game.height()-3), destruible = false))})
	}
	
	method agregarParedesIrrompibles(){
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
	
	method esScore(posicion){
		return (posicion.x() == 0 || posicion.x() == game.width()-1) || (posicion.y() == 0 || posicion.y() > game.height()-3)}
		
	method esLugarVacio(position) = game.getObjectsIn(position).isEmpty() and !self.esAreaSegura(bomber1, position) and !self.esAreaSegura(bomber2, position)
	
	method esAreaSegura(bomber, posicion) = (bomber == bomber1 and [game.at(1,1), game.at(1,2), game.at(2,1)].contains(posicion)) or (bomber == bomber2 and [game.at(18,13), game.at(19,13), game.at(19,12)].contains(posicion))
	
	method hayGanador() = !bomber1.bomberVivo() or !bomber2.bomberVivo()
	
	method reiniciarBombers(){bombers.forEach({ bomber => bomber.reiniciar()})}
		
<<<<<<< HEAD
	method alternarMusica(){
		if(musica.paused()) //Si la musica está pausada
			musica.resume()
		else if(musica.played()) //Si la musica se está reproduciendo
			musica.pause()
		else
			musica.play()
=======
		//Jugador 2:  ↑ ↓ ← → + Enter
		keyboard.right().onPressDo({bomber2.moverA(derecha)})
		keyboard.up().onPressDo({bomber2.moverA(arriba)})
		keyboard.down().onPressDo({bomber2.moverA(abajo)}) 
		keyboard.left().onPressDo({bomber2.moverA(izquierda)})
		keyboard.enter().onPressDo({bomber2.ponerBomba()})
		
		//ALterar musica
		keyboard.m().onPressDo({self.alternarMusica()})
		
		//Cerrar juego
		keyboard.q().onPressDo({game.stop()})
		
		//Reload game
		keyboard.r().onPressDo({self.reiniciar()})
>>>>>>> branch 'master' of https://github.com/pdepjm/2022-tpgame-bigmuzza.git
	}
	
<<<<<<< HEAD
	method reiniciarJuego() {
		game.clear()
		self.agregarObjetos()
		self.agregarPersonajes()
		self.configurarTeclas()
		self.reiniciarBombers()
=======
	method hayGanador() = !bomber1.bomberVivo() or !bomber2.bomberVivo()
	

	method alternarMusica(){
		
		if(alternarMusica){
			soundManager.playSong(musica, true)
			alternarMusica = !alternarMusica
		}
		else{
			soundManager.stopAllSongs()
			alternarMusica = !alternarMusica
		}
	}
	
	method acomodarBombers(){
		bomber1.moverAPosicion(game.at(1,1))
		bomber1.nuevaDireccion(centro)
		bomber1.pie()
		
		bomber2.moverAPosicion(game.at(19,13))
		bomber2.nuevaDireccion(centro)
		bomber2.pie()
	}	
	
	method reiniciar() {
		game.clear()
		self.agregarObjetos()
		self.agregarPersonajes()
		self.acomodarBombers()
		self.configurarTeclas()
>>>>>>> branch 'master' of https://github.com/pdepjm/2022-tpgame-bigmuzza.git
	}  	
}
<<<<<<< HEAD

	

=======
	
>>>>>>> branch 'master' of https://github.com/pdepjm/2022-tpgame-bigmuzza.git
		
		