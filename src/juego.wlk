import wollok.game.*
import bomber.*
import direcciones.*



object juego {
	method iniciar() {
		self.hacerConfiguracionInicial()
		self.agregarPersonajes()
		self.configurarTeclas()
		self.configurarAcciones()
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
		game.addVisual(new ObjetoAgarrable(position =  game.at(6,6), image = "bombaAgarrable.png"))
	}
	
	method agregarPared() {
		game.addVisual(stone)
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
	}
	method configurarAcciones(){
		game.onCollideDo(bomber1,{chocado => chocado.teChocasteConElBomber()})	
	}
	
	//method configurarEntorno() {
		
	//}
}
