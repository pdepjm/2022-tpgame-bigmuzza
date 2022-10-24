class Score {

	const property position
	var bomber
	method image()
}

class ScoreHp inherits Score {

	override method image() {
		return "hp" + bomber.cantidadVidas() + ".png"
	}

}

class ScoreEscudo inherits Score {

	override method image() {
		return if (bomber.tieneEscudo()) "shield.png" else "scoreBackground.png"
	}

}

class ScoreDef {

	const property position
	const property image

}
class ScoreGanador inherits Score{
	
	override method image() = if(bomber.nroBomber() == "1")return "winBomber2.png" else return "winBomber1.png"
	
}