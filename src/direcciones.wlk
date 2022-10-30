object arriba {
	method imagenDelBomber(bomber) = "Up"
	
	method siguientePosicion(posicion){
		return posicion.up(1)
	} 	
}

object abajo {
	method imagenDelBomber(bomber) = "Down"
	
	method siguientePosicion(posicion){
		return posicion.down(1)
	}	
}

object derecha {
	method imagenDelBomber(bomber) = "Right"
	
	method siguientePosicion(posicion){
		return posicion.right(1)
	}
}

object izquierda {
	method imagenDelBomber(bomber) = "Left"
	
	method siguientePosicion(posicion){
		return posicion.left(1)
	}	
}

object centro {	
	method imagenDelBomber(bomber) = "Center"
	
	method siguientePosicion(posicion){
		return posicion
	}	
}

const orientaciones = [arriba, izquierda, abajo, derecha, centro]
