class ServiciosResponse {
  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final double precio;

  ServiciosResponse(this.id, this.codigo, this.nombre, this.descripcion, this.precio);

  ServiciosResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        codigo = json['codigo'],
        nombre = json['nombre'],
        descripcion = json['descripcion'],
        precio = json['precio'] is String ? double.parse(json['precio']) : json['precio'];
}
