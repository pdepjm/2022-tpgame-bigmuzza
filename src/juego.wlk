import wollok.game.*
import bomber.*
import direcciones.*



object juego {
	method iniciar() {
		self.hacerConfiguracionInicial()
		self.agregarPersonajes()
		self.configurarTeclas()
		//self.configurarAcciones()
		game.start()
	}
	
	method hacerConfiguracionInicial() {
		game.title("BomberMan")
		game.width(20)
		game.height(20)
	}
	
	method agregarPersonajes() {
		self.agregarBombers()
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
		
		
		keyboard.right().onPressDo({bomber2.moverA(derecha)})
		keyboard.up().onPressDo({bomber2.moverA(arriba)})
		keyboard.down().onPressDo({bomber2.moverA(abajo)}) 
		keyboard.left().onPressDo({bomber2.moverA(izquierda)})
	}
}
