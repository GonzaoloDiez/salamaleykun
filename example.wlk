import vm.*

class Pizza {
    const masaInicial = 500
    var masa = masaInicial
    const ingredientes = ["tomate"]

    var gradoDeCoccion = 0.3

    method cocinarPor(minutos) {
      gradoDeCoccion += minutos * (10/masa)
      masa -=  (masaInicial*0.001)
    }
    method agregarIngrediente(ingrediente) {
      ingredientes.add(ingrediente)
    }

    method estaCruda() = gradoDeCoccion<0.4
    method estaQumada() = gradoDeCoccion>1
    method noEstaCrudaNiQuemada() = (!self.estaCruda() and !self.estaQumada())

    method tieneIngrediente(ingredienteBuscado) = ingredientes.contains(ingredienteBuscado)
    method estaCargada() = ingredientes != ingredientes.withoutDuplicates()

    method masa() = masa
    method masaInicial() = masaInicial 
}

class Pizzero {
    var pizza = self.hacerPrePizza()
    method hacerPrePizza() =new Pizza( masaInicial = 500,ingredientes = ["tomate"],gradoDeCoccion = 0.3)
    
    method cocinarPizza() {
        self.hacerPrePizza()    
        pizza.agregarIngrediente("muzzarella")
        pizza.cocinarPor(10)
    }
    method pizza() = pizza 
}

object carla inherits Pizzero {
     override method cocinarPizza() {
       super()
       pizza.agregarIngrediente("provolone")
       pizza.cocinarPor(1)
     }
}

object facu inherits Pizzero {
    var humor = "arriesgado"

    override method cocinarPizza() {
       super()
       self.agregarPorHumor()
    }

    method agregarPorHumor() {
      if (humor == "arriesgado"){
        pizza.agregarIngrediente("anana")
      }
      else if(humor == "conservador"){
        pizza.agregarIngrediente("oregano")
      }
    }

    method cambiarHumorArriesgado() {
      humor="arriesgado"
    }
    method cambiarHumorConservador() {
      humor="conservador"
    }
}

class PizzerosMaritimos inherits Pizzero {
    var ingredienteFavorito
    override method hacerPrePizza() =  new Pizza( masaInicial = 650,ingredientes = ["tomate"],gradoDeCoccion = 0.3)

     override method cocinarPizza() {
       super()
       pizza.agregarIngrediente(ingredienteFavorito)
       pizza.agregarIngrediente(pizzeriaMaritima.ingredienteDelDia())

     }
}

object pizzeriaMaritima{
    var property ingredienteDelDia = "oregano"
}

class Juez {
    var ingredienteQueNoGusta

    method pizzaVetable(pizza) = self.tieneUnIngredienteNoGustado(pizza) or pizza.estaCruda()
    method tieneUnIngredienteNoGustado(pizza) = pizza.tieneIngrediente(ingredienteQueNoGusta)
    
    method puntuarPizza(pizza)
    method juzgarPizza(pizza) = 1.min(0.max(self.puntuarPizza(pizza)))
}

object zeff inherits Juez(ingredienteQueNoGusta="atun") {
    override method puntuarPizza(pizza) {
        return pizza.masa()/pizza.masaInicial()
    }

}

object anton inherits Juez(ingredienteQueNoGusta="morrones") {
    override method pizzaVetable(pizza) = super(pizza) or pizza.masa() < 400
    override method puntuarPizza(pizza) {
        var puntaje = 1
        if(pizza.estaQuemada()){
            puntaje -=0.5
        }
        else if(pizza.estaCargada()){
            puntaje+=0.2
        }
        return puntaje - self.cantidadMayorA500(pizza)*0.1
    }
    method cantidadMayorA500(pizza) = (0.max(pizza.masa()-500)/100).coerceToInteger()
}

object contrera inherits Juez(ingredienteQueNoGusta="roquefort") {
    var ingredienteQueLeGusta = "anana"
    var referente = zeff
    method cambiarReferente(nuevoReferente) {
      referente = nuevoReferente
    }
    override method puntuarPizza(pizza) {
        var puntaje = 1
        if(pizza.tieneIngrediente(ingredienteQueLeGusta)){
            puntaje +=0.2
        }
        return puntaje - referente.puntuarPizza(pizza)
    }
}

class Concurso {
    const pizzerosConcursantes = new List()
    const jurado = new List()

    method iniciarConcurso() {
        //preparan la pizza
        pizzerosConcursantes.forEach({pizzero => pizzero.cocinarPizza()})
        //ronda de vetos
        const pizzerosPasables = self.rondaVetos() 
        //evaluan las pizzas
        const puntajesPizzas = self.puntuarPizzas(pizzerosPasables)
        //a ver si hay empate
        self.hayEmpate(puntajesPizzas)
        //seleccionan al pizzero ganador
        return self.encontrarGanador(pizzerosPasables,puntajesPizzas)
    }

    method hayEmpate(puntajes) {
      //si llegase a haber empate no hay ganador posible
      //si el ultimo y el anteultimo son iguales
      if (puntajes.get(puntajes.size()-1)==puntajes.last()){ 
            self.error("Ha ocurrido un empate no hay ganador posible")
      }
    }

    method rondaVetos() {
      //dejo a los pizzeros no vetadas
      const pizzerosNoVetados = pizzerosConcursantes.filter({pizzero => jurado.all({juez => !juez.pizzaVetable(pizzero.pizza())})})
      //si todos los pizzeros fueron vetados, no hay ganador posible
      if(pizzerosNoVetados.isEmpty()){
        self.error("Todos los pizzeros han sido vetados no hay ganador posible")
      }
      return pizzerosNoVetados
    }

    method puntuarPizzas(pizzerosPasables) {
      //por cada piza evaluo la sumatoria de puntajes que le dan los jueces, 
      //lo ordeno MenMay para luego evaluar empate
      return pizzerosPasables.map({pizzero=>jurado.sum({juez=>juez.juzgarPizza(pizzero.pizza())})}).sortBy({n1,n2=>n1<n2})
    }

    method encontrarGanador(pizzerosPasables,puntajes) {
      //buscar en los pizzeros el pizzero con la piza  
      //que tiene el puntaje igual al mas alto
      return pizzerosPasables.filter({pizzero=>jurado.sum({juez=>juez.juzgarPizza(pizzero.pizza())})==puntajes.max()})
    }
}

