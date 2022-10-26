<h1 align="center">  Teoría 🤓 </h1>
<h2 align="center">  Polimorfismo </h2>

Algunos de los mensajes polimórficos en nuestro juego son:
- destruirse()
- esPisable() 
- siguientePosicion(posicion)
- esBomba()

<h3 align="center">  destruirse() </h3>
Este método se ve implementado por la clase Explosión y permite la destrucción/daño de objetos destruibles siempre que se encuentren en el rango de la explosión. 
Algunos ejemplos de estos pueden ser, los bombers, las paredes deestruibles y las bombas (ya que la explosión de una bomba hace que otra explote si está dentro del 
rango de explosión de la primera). Su implementación es la siguiente:

```
method explotarEnDireccion(dir) {
  if (poderExplosion > 0 and !self.hayIrrompibleEn(dir)) {
    if (!game.getObjectsIn(dir.siguientePosicion(position)).isEmpty() and !juego.hayGanador()) 
      game.getObjectsIn(dir.siguientePosicion(position)).forEach({objeto => objeto.destruirse()})
    const nuevaExplosion = new Explosion(position = dir.siguientePosicion(position), poderExplosion = poderExplosion - 1)
    nuevaExplosion.animacion()
    nuevaExplosion.explotarEnDireccion(dir)
  }
}
```

En la cuarta línea, el código 'forEach({objeto => objeto.destruirse()})' le indica a todos los objetos que se encuentren en el área de explosión de la bomba que se 
destruyan. Cada objeto posee un método destruirse() el cual es diferente para cada objeto:
- Bombas: explotan al instante
- Bombers: pierden una vida
- Paredes: se destuyen

<h4 align="left">  destruirse() en la clase bomba </h4>

```
method destruirse() {
  self.explotar(self)
}
```

<h4 align="left">  destruirse() en la clase pared </h4>

```
method destruirse() {
  if (destruible) game.removeVisual(self)
   self.generarPowerUp()
}
```
<h4 align="left">  destruirse() en la clase bomber </h4>

```
method destruirse(){
  if (self.tieneEscudo()) 
    self.desactivarEscudo() 
  else 
    self.perderVida() 
}
```

<h3 align="center"> esPisable() </h3>
Este método se encarga de preguntar a cada objeto, como ya adivinaron, si es pisable o no. Esto nos permite saber si el bomber se puede mover a la siguiente dirección
a la que queremos ir. Si queremos movernos a la derecha pero hay una pared, el movimiento no se realizará. Su implementación es:

```
method direccionValida(dir) = game.getObjectsIn(dir.siguientePosicion(position)).all({ objeto => objeto.esPisable() })
```

Cada objeto posee un método esPisable() el cual es diferente para cada objeto:
- Bombas: no son pisables
- Bombers: son pisables
- PowerUps: son pisables

<h4 align="left">  esPisable() se implementa con herencia </h4>

```
class EntidadPisable {
	method esPisable() = true
}

class EntidadNoPisable {
	method esPisable() = false
}
```

<h2 align="center"> Colecciones </h2>

Las colecciones que tenemos nos permiten guardar las posiciones seguras (de spawn) de los bombers. Ningun bloque puede aparece en dichas coordenadas para que el 
jugador no empiece el juego estando atrapado entre paredes. Tambien nos sirve para guardar las orientaciones en las que la bomba puede explotar. Por último, las 
utilizamos para contener a los bombers y cuando sea momento de reinciar el juego, con un simple _forEach_ sea mas facil resetear sus habilidades, vidas, etc.

```
const bombers = [bomber1, bomber2]
```

```
const orientaciones = [arriba, izquierda, abajo, derecha, centro]
```

```
const areaSeguraBomber1 = [game.at(1,1),   game.at(1,2),   game.at(2,1)]
const areaSeguraBomber2 = [game.at(18,13), game.at(19,13), game.at(19,12)]
```

<h3 align="center"> Mensajes con efecto </h3>

Utilizamos mensajes con efecto sobre las colecciones como por ejemplo:

```
method reiniciarBombers(){bombers.forEach({ bomber => bomber.reiniciar()})}
```

```
method reiniciar(){
  if(self == bomber1)
    self.moverAPosicion(game.at(1,1))
  else
    self.moverAPosicion(game.at(19,13))
  self.nuevaDireccion(centro)
  self.pieInicial()
  self.cantidadVidas(2)
  self.desactivarEscudo()
  self.masBombas(1)
  self.poderBomba(1)
}
```

<h3 align="center"> Mensajes sin efecto </h3>
Y por otro lado, tambien utilizamos mensajes sin efecto (de consulta) sobre las colecciones de las posiciones de área segura de los bombers:

```
method esAreaSegura(bomber, posicion) = (bomber == bomber1 and areaSeguraBomber1.contains(posicion)) or (bomber == bomber2 and areaSeguraBomber2.contains(posicion))
```


<h2 align="center"> Clases </h2>
Decidimos utilizar clases ya que necesitamos crear varios objetos que se comporten de manera similar. Consideramos que era conveniente ya que, por ejemplo, para 
crear los diferentes tipos de paredes, 






