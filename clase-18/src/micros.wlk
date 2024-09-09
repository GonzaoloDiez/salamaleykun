// poder preguntarle a un micro si se puede subir a una persona, para lo cual tienen que darse dos condiciones: que haya lugar en el micro, y que la persona acepte ir en el micro.

class Micro {
	const capacidadSentados
	const capacidadParados
	const volumen
	var cantidadDePasajeros = 0

	method puedeSubirse(unaPersona) {
		return self.hayEspacio() && unaPersona.seSubiria(self)
	}
	method hayEspacio() {
		return self.espacioDisponible() > 0 
	}
	method volumen() {
		return volumen
	}
	method espacioDisponible() {
		return capacidadSentados + capacidadParados - cantidadDePasajeros
	}
	method tieneAsientosVacios() {
		return  cantidadDePasajeros < capacidadSentados
	}
	method seSube(persona) {
		if(self.puedeSubirse(persona)) {
			cantidadDePasajeros += 1
		} else {
			self.error("La persona no podia subirse")
		}
	}
	
	method seBaja(persona) {
		if(cantidadDePasajeros>0) {
			cantidadDePasajeros -= 1
		} else {
			self.error("No hay nadie para que se baje subirse")
		}
	}
}

class PersonaApurada {
	method seSubiria(micro) {
		return true
	}
}

class PersonaClaustrofobica {
	method seSubiria(micro) {
		return micro.volumen() > 120
	}
}
class PersonaFiaca { //asumiendo que las personas que entran se sientan primero y despues se quedan parado
	method seSubiria(micro) {
		return micro.tieneAsientosVacios()
	}
}
class PersonaModerada {
	var cantidadMinimaLibre
	method seSubiria(micro) {
		return micro.espacioDisponible() <= cantidadMinimaLibre
	}
}
class PersonaObsecuente {
	var jefe
	method seSubiria(micro) {
		return jefe.seSubiria(micro)
	}
}