
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestorage_service.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';
import 'dart:io';




class EditarEventoPage extends StatefulWidget {
   final User usuario;
  final QueryDocumentSnapshot<Object?> evento;
final Image imagenEvento;

  const EditarEventoPage({
    Key? key,
    required this.usuario,
    required this.evento,
   required this.imagenEvento,
  }) : super(key: key);

  @override
  State<EditarEventoPage> createState() => _EditarEventoPageState();
}

class _EditarEventoPageState extends State<EditarEventoPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();

  //cambiar esto
  DateTime fechaHora = DateTime.now();

  
  String selectedTipo = '';
  List<String> tipos = ['Fiesta', 'Evento deportivo', 'Concierto'];

  File? imagenSubir;
  String? imagenURL;
  String url = ''; 

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> listaErrores = [];
   
  @override
  void initState() {
    super.initState();
    
    
    selectedTipo = widget.evento['tipo'] ?? 'Fiesta';
    nombreCtrl.text = widget.evento['nombre'] ?? '';
    fechaHora = (widget.evento['fechaHora'] as Timestamp).toDate() ?? DateTime.now();
    lugarCtrl.text = widget.evento['lugar'] ?? '';
    descripcionCtrl.text = widget.evento['descripcion'] ?? '';
    imagenURL = widget.evento['imagenURL'] ?? '';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: true,
      
      appBar: AppBar(
        title: Text('Editar Evento', style: TextStyle(color: Colors.blue[900])),
      ),
      body: Container(
         decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color.fromRGBO(160, 213, 244, 1)
                        
                      ),
        child: Form(     
          
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
      
       Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        controller: nombreCtrl,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          labelText: 'Nombre',
          prefixIcon: Icon(Icons.person),
          border: InputBorder.none, // Para eliminar el borde predeterminado del TextFormField
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Ajusta el relleno interno
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty){
            return "Campo nombre requerido";
          }
        },
      ),
    ),
    SizedBox(height: 16.0), // Espaciado entre TextFormField
    Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        controller: descripcionCtrl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Descripción',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty){
            return "Campo descripción requerido";
          }
        },
      ),
    ),
    SizedBox(height: 16.0), // Espaciado entre TextFormField
    Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        controller: lugarCtrl,
        decoration: InputDecoration(
          labelText: 'Lugar',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        keyboardType: TextInputType.text,
        validator: (String? value) {
          if (value == null || value.isEmpty){
            return "Campo lugar requerido";
          }
        },
      ),
    ),
      
                /////// Tipo de Evento (ComboBox)
                Padding(
                  padding: const EdgeInsets.only(top: 18.0 , bottom: 10),
                  child: DropdownButtonFormField<String>(
                    value: selectedTipo,
                    items: tipos.map((String tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTipo = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Tipo de Evento',
                      border: OutlineInputBorder(),
                    ),
                    
                  ),
                ),
      
                // ElevatedButton para seleccionar fecha y hora
ElevatedButton(
  onPressed: () async {
    // Código para seleccionar la fecha y la hora
  },
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), 
    ),
    backgroundColor: Color.fromARGB(255, 73, 120, 159), 
    foregroundColor: Colors.black, 
  ),
  child: Text(
    'Seleccionar fecha y hora',
    style: TextStyle(fontSize: 18), // Ajusta el tamaño del texto
  ),
),

// Texto para mostrar la fecha y hora
Text(
  'Fecha y Hora: ${fechaHora.toString()}',
  style: TextStyle(fontSize: 16),
),

// ElevatedButton para seleccionar imagen
Container(
  margin: EdgeInsets.symmetric(vertical: 10),
  child: ElevatedButton(
    onPressed: () async {
      // Código para seleccionar la imagen
    },
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Hace el botón más cuadrado
      ),
      backgroundColor: const Color.fromARGB(255, 41, 113, 172), 
      foregroundColor: Colors.black, 
    ),
    child: Text(
      'Seleccionar imagen',
      style: TextStyle(fontSize: 18), // Ajusta el tamaño del texto
    ),
  ),
),
                // Mostrar la imagen seleccionada
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: imagenSubir != null
                      ? Image.file(
                          File(imagenSubir!.path), 
                          fit: BoxFit.cover,
                          width: 100,
                          height: 400,
                        )
                      : widget.imagenEvento,
                ),
                // BOTON Nuevo Evento
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900], // Color de fondo azul marino más oscuro
                      foregroundColor: Colors.black, // Color del texto
                      padding: EdgeInsets.all(20), // Aumenta el espacio interno del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Redondea los bordes
                      ),
                    ),
                    child: Text('Cambiar Evento', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      
                      // Validar el formulario
                      if (formKey.currentState!.validate() && imagenSubir != null) 
                      {
                        print('Todo bien');
      
                          // Subir la imagen
                          url = await FireStorageService().subirImagen(imagenSubir!);
                          
                          
                             FirestoreService().cambiarEventoImagen(
                          widget.evento.id,
                          {
                            'nombre': nombreCtrl.text.trim(),
                            'descripcion': descripcionCtrl.text.trim(),
                            'lugar': lugarCtrl.text.trim(),
                            'tipo': selectedTipo,
                            'fechaHora': fechaHora,
                            'imagenURL': url,
                          },
                        );
                        Navigator.pop(context);
                            
                          
                        } 
                        else if (formKey.currentState!.validate()) {
                        FirestoreService().cambiarEvento(
                          widget.evento.id,
                          {
                            'nombre': nombreCtrl.text.trim(),
                            'descripcion': descripcionCtrl.text.trim(),
                            'lugar': lugarCtrl.text.trim(),
                            'tipo': selectedTipo,
                            'fechaHora': fechaHora,
                          },
                        );
                        Navigator.pop(context);
                      }
      
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

