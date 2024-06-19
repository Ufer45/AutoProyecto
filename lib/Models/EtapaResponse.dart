class EtapaResponse {
  final int? idServicio;
  final String nombre;
  final double duracion;

  EtapaResponse(this.idServicio, this.nombre, this.duracion);

  EtapaResponse.fromJson(Map<String, dynamic> json)
      : idServicio = json['id_servicio'] != null ? json['id_servicio'] as int : null,
        nombre = json['nombre'],
        duracion = json['duracion'] is String ? double.parse(json['duracion']) : json['duracion'];
}