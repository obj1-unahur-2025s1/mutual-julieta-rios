class Actividad{
  const property idiomas = []
  const socios = #{}
  method implicaEsfuerzo() 
  method sirveParaBroncearse() = true
  method cantidadDeDias()
  method esRecomendada(unSocio)
}

class Viaje inherits Actividad{
  method esInteresante() = idiomas.size() > 1
  override method esRecomendada(unSocio) = self.esInteresante() && unSocio.leAtrae(self) && not unSocio.actividades().contains(self)
}

class Playa inherits Viaje{
  const largo
  override method implicaEsfuerzo() = largo > 1200
  override method cantidadDeDias() = largo / 500
}

class Ciudad inherits Viaje{
  var property cantidadDeAtracciones
  override method implicaEsfuerzo() = cantidadDeAtracciones.between(5,8)
  override method sirveParaBroncearse() = false
  override method cantidadDeDias() = cantidadDeAtracciones / 2
  override method esInteresante() = super() || cantidadDeAtracciones == 5
}

class CiudadTropical inherits Ciudad{
  override method cantidadDeDias() = super() + 1
  override method sirveParaBroncearse() = true
}

class Trekking inherits Viaje{
  var kmSenderos
  var diasSoleados
  override method implicaEsfuerzo() = kmSenderos > 80
  override method sirveParaBroncearse() = diasSoleados > 200 || (diasSoleados.between(100,200) and kmSenderos > 120)
  override method cantidadDeDias() = kmSenderos / 50
  override method esInteresante() = super() && diasSoleados > 140
}

class ClaseDeGimnasia inherits Actividad{
  method initialize(){
    idiomas.clear()
    idiomas.add("español")
    //if (idiomas != ["español"]) self.error("solo se permite clase de gimansia en español")
    // const gym = new ClaseDeGimnasia(idiomas = ["español"])
  }
  override method cantidadDeDias() = 1
  override method implicaEsfuerzo() = true
  override method sirveParaBroncearse() = false
  override method esRecomendada(unSocio) = unSocio.edad().between(20,30)
}

class TallerLiterario inherits Actividad{
  const libros = []
  method initialize(){
    idiomas.clear()
    idiomas.addAll(libros.map{l=>l.idioma()})
  }
  override method cantidadDeDias() = libros.size() + 1
  override method implicaEsfuerzo() = 
    libros.any{l=>l.paginas() > 500} or
    libros.size() > 1 and
    libros.map{l=>l.autor()}.asSet().size() == 1
  override method sirveParaBroncearse() = false
  override method esRecomendada(unSocio) = unSocio.idiomasQueHabla().size() > 1
}

class Libro{
  const property idioma
  const property autor
  const property paginas
}

class Socio{
  const property actividades = []
  const property idiomasQueHabla = #{}
  const maxActividades
  var edad
  method edad() = edad
  method esAdoradorDelSol() = actividades.all{a=>a.sirveParaBroncearse()}
  method actividadesEsforzadas() = actividades.filter{a=>a.implicaEsfuerzo()}
  method registrarActiv(unaActividad){
    if (actividades.size() == maxActividades) self.error ("Máximo de actividades alcanzada")
    actividades.add(unaActividad)
  }
  method leAtrae(unaActividad)
}

class SocioTranquilo inherits Socio{
  override method leAtrae(unaActividad) = unaActividad.cantidadDeDias() >= 4
}

class SocioCoherente inherits Socio{
  override method leAtrae(unaActividad) = if (self.esAdoradorDelSol()) unaActividad.sirveParaBroncearse() else unaActividad.implicaEsfuerzo()
}

class SocioRelajado inherits Socio{
  override method leAtrae(unaActividad) = not idiomasQueHabla.intersection(unaActividad.idiomas()).isEmpty()
  //si hay interseccion entre los idiomas del socio y los de la activ
}