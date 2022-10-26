<h1 align="center">  Teoría 🤓 </h1>
<h2 align="center">  Polimorfismo </h2>

Algunos de los mensajes polimórficos en nuestro juego son:
- destruirse()
- esPisable() 
- siguientePosicion(posicion)
- esBomba()

<h3 align="center">  destruirse() </h3>
Este método se ve implementado por la clase Explosión y permite la destrucción/daño de objetos destruibles siempre que se encuentren en el rango de la explosión. 
Algunos ejemplos de estos pueden ser, los bombers, las paredes destruibles y las bombas (ya que la explosión de una bomba hace que otra explote si está dentro del 
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
- Paredes: se destruyen

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

Las colecciones que tenemos nos permiten guardar las posiciones seguras (de spawn) de los bombers. ningún bloque puede aparecer en dichas coordenadas para que el 
jugador no empiece el juego estando atrapado entre paredes. también nos sirve para guardar las orientaciones en las que la bomba puede explotar. Por último, las 
utilizamos para contener a los bombers y cuando sea momento de reiniciar el juego, con un simple _forEach_ sea mas facil resetear sus habilidades, vidas, etc.

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
Y por otro lado, también utilizamos mensajes sin efecto (de consulta) sobre las colecciones de las posiciones de área segura de los bombers:

```
method esAreaSegura(bomber, posicion) = (bomber == bomber1 and areaSeguraBomber1.contains(posicion)) or (bomber == bomber2 and areaSeguraBomber2.contains(posicion))
```


<h2 align="center"> Clases </h2>
Decidimos utilizar clases porque necesitamos instanciar varios objetos que tengan un comportamiento similar y si usásemos objetos estaríamos repitiendo lógica. 

Los objetos como paredes, bombers y las vidas se instancian al iniciar el juego ya que, las paredes, forman parte del mapa y los bombers son los PJ. Las bombas 
son instanciadas cada vez que se aprieta la tecla correspondiente para poner una bomba. Los _PowerUps_ se instancian, con una probabilidad, cada vez que se destruye 
una pared.

<h4 align="left"> Instanciación de bombers </h4>

```
const bomber1 = new Bomber(position = game.at(1, 1), nroBomber = "1", posScore = 1)
const bomber2 = new Bomber(position = game.at(19, 13), nroBomber = "2", posScore = 2)
```

<h4 align="left"> Instanciación de paredes destruibles </h4>

```
method agregarParedesRompibles(){
  new Range(start = 0, end = 20)
  .forEach{x => new Range(start = 0, end = 14)
    .forEach{y => if((0.randomUpTo(1))>=0.5 and (self.esLugarVacio(game.at(x,y))))
      game.addVisual(new Pared(position = game.at(x,y), destruible = true))
    }
  }
}
```

<h4 align="left"> Instanciación de paredes indestructibles </h4>

```
method agregarParedesLimite() {
  //Paredes Verticales		
  (game.height()-2).times({ i => game.addVisual(new Pared(position = game.at(0,i-1), destruible = false))})
  (game.height()-2).times({ i => game.addVisual(new Pared(position = game.at(game.width()-1,i-1), destruible = false))}) 
  //Paredes Horizontales
  (game.width()-1).times({ i => game.addVisual(new Pared(position = game.at(i-1,0), destruible = false))})
  (game.width()-1).times({ i => game.addVisual(new Pared(position = game.at(i,game.height()-3), destruible = false))})
}
```

<h2 align="center"> Herencia </h2>

Decidimos utilizar la herencia en dos oportunidades.

<h3 align="center"> Herencia de PowerUps </h3>

En esta clase (PowerUp) están todos los métodos que comparten cada uno de los diferentes poderes (poder tener mayor cantidad de bombas, mayor poder de bomba y escudo
de protección). 

```
class PowerUp inherits EntidadPisable {
  const position
  method efecto(persona)
  method position() = position
  method esBomba() = false
  method destruible() = true
  method destruirse() = null
}
```
 
 Y las sub-clases que heredan de PowerUp son:
 
``` 
class MasBomba inherits PowerUp {
  const image = "PlusBombPU.png"
  method image() = image
  override method efecto(persona) {persona.masBombas()}
}
```

```
class MasPoderBomba inherits PowerUp {
  const image = "UpgradeBombPU.png"
  method image() = image
  override method efecto(persona) {persona.masPoderBomba()}
}
```

```
class Escudo inherits PowerUp {
  const image = "ShieldPU.png"
  method image() = image
  override method efecto(persona) {
    persona.activarEscudo()
    //game.sound("shieldMusic.mp3").play()
    game.schedule(10000, { persona.desactivarEscudo()})
  }
}
```

Cada PowerUp modifica el método efecto() ya que cada poder tiene un efecto distinto sobre el bomber.

<h3 align="center"> Herencia de Entidades </h3>

En nuestro juego, todos los objetos los podemos dividir en dos tipos:
- Entidades Pisables
- Entidades No Pisables

```
class EntidadPisable {
  method esPisable() = true
}

class EntidadNoPisable {
  method esPisable() = false
}
```

Todas las clases heredan de alguna de éstas dos clases mencionadas anteriormente:

```
class Bomber inherits EntidadPisable {}
```

```
class Bomba inherits EntidadNoPisable {}
```

```
class Explosion inherits EntidadPisable {}
```

```
class Pared inherits EntidadNoPisable {}
```

Ninguna sub-clase modifica el método esPisable() ya que nunca cambian su estado.

Al utilizar herencia, tenemos una mejor organización del código ya que no se repite y es más intuitivo. 

<h2 align="center"> Delegación de responsabilidades </h2>

La delegación de responsabilidades causa una lectura de código más facil y rápida y debido a eso, la utilizamos en las siguientes ocasiones:

```
method moverA(dir) {
  if (self.direccionValida(dir) and self.bomberVivo()) {
    direccion = dir
    pieIzquierdo = !pieIzquierdo
    position = dir.siguientePosicion(position)
  }
}
```

```
method direccionValida(dir) = game.getObjectsIn(dir.siguientePosicion(position)).all({ objeto => objeto.esPisable() })
```

De esta manera, si tuviésemos que modificar la condición para que una dirección sea una dirección válida, moverA() no se modificaría y menos errores sucederían.

De la misma manera sucede con:
```
method agregarParedesRompibles(){
  new Range(start = 0, end = 20)
  .forEach{x => new Range(start = 0, end = 14)
    .forEach{y => if((0.randomUpTo(1))>=0.5 and (self.esLugarVacio(game.at(x,y))))
      game.addVisual(new Pared(position = game.at(x,y), destruible = true))
    }
  }
}
```

```
method esLugarVacio(position) = game.getObjectsIn(position).isEmpty() and !self.esAreaSegura(bomber1, position) and !self.esAreaSegura(bomber2, position)
```
Si eventualmente queremos cambiar la condición de esLugarVacio() es sencillo ya que agregamos otra condición, y gracias a que agregarParedesRompibles() está
desacoplado no es necesario modificarlo también.

<h2 align="center"> <a href="https://lucid.app/lucidchart/aa679c01-33ca-41ca-bd2e-046c527bec90/edit?viewport_loc=-2708%2C-1729%2C3521%2C1606%2CCnGZs9scU0ZU&invitationId=inv_68db0409-6a3b-4fc0-a6bb-51601669ba4b"> Diagrama de clases estatico</a> </h2>

