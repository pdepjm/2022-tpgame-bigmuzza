import wollok.game.*

object sonidos {

	const musicaJuego = game

	method play(nombre) {
		musicaJuego.sound(nombre).play()
	}
	
	method pause(nombre){
//		if(musicaJuego.sound(nombre).played())
			musicaJuego.sound(nombre).stop()
	}

}