object arriba {
	method siguientePosicion(posicion){
		return posicion.up(1)
	} 
	method cambiarAPosicion(posicion, bomber){
		bomber.cambiarImagen(self)
		return self.siguientePosicion(posicion)
	} 
}

object abajo {
	method siguientePosicion(posicion){
		return posicion.down(1)
	}	
	method cambiarAPosicion(posicion, bomber){
		bomber.cambiarImagen(self)
		return self.siguientePosicion(posicion)
	} 
}

object derecha {
	method siguientePosicion(posicion){
		return posicion.right(1)
	}
	method cambiarAPosicion(posicion, bomber){
		bomber.cambiarImagen(self)
		return self.siguientePosicion(posicion)
	} 
}

object izquierda {
	method siguientePosicion(posicion){
		return posicion.left(1)
	}	
	method cambiarAPosicion(posicion, bomber){
		bomber.cambiarImagen(self)
		return self.siguientePosicion(posicion)
	} 
}
