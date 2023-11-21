import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_certamen_aplicacion/services/login_google.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreService {


  //obtener lista de eventos
  Stream<QuerySnapshot> eventos() {
    // return FirebaseFirestore.instance.collection('estudiantes').snapshots();
    return FirebaseFirestore.instance.collection('estudiantes').orderBy('apellido').snapshots();
    // return FirebaseFirestore.instance.collection('estudiantes').where('edad', isLessThanOrEqualTo: 25).snapshots();
  }


  //insertar nuevo estudiante
  Future<void> eventoAgregar(String nombre, String descripcion, String lugar, String tipo, DateTime fechaHora, String imagenURL, String usuarioId) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaHora': fechaHora,
      'imagenURL': imagenURL,
      'lugar': lugar,
      'tipo': tipo,
      'likes': 0,
      'usuario': usuarioId,
    });
  }

  //borrar estudiante
  Future<void> estudianteBorrar(String docId) async {
    return FirebaseFirestore.instance.collection('estudiantes').doc(docId).delete();
  }
}
