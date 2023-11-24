
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
        title: Text('Nuevo Evento', style: TextStyle(color: Colors.white)),
      ),
      body: Form(     
        
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [


              /////Nombre
              TextFormField(
                
                controller: nombreCtrl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Nombre', 
                  prefixIcon: Icon(Icons.person)
                ),
                validator: (String? value) {
                 
                  if (value == null || value.isEmpty){
                    return "Campo nombre requerido";
                  }
                  
                  
                },
              ),
              



              //////DESCRIPCION
              TextFormField(
                controller: descripcionCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (String? value) {
                 
                  if (value == null || value.isEmpty){
                    return "Campo descripción requerido";
                  }
                  
                  
                },
              ),
                    
             //////LUGAR
              TextFormField(
                controller: lugarCtrl,
                decoration: InputDecoration(labelText: 'Lugar'),
                keyboardType: TextInputType.text,
               validator: (String? value) {
                 
                  if (value == null || value.isEmpty){
                    return "Campo lugar requerido";
                  }
                  
                  
                },
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

              ////////LA FECHA Y HORA
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        fechaHora = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text('Seleccionar fecha y hora'),
                
              ),

              // Agrega Texto para mostrar la fecha y hora 
              Text(              
                'Fecha y Hora: ${fechaHora.toString()}',
                style: TextStyle(fontSize: 16),
              ),
             
              /////////////LA IMAGEN
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
          
                  final imagen = await FireStorageService().getImagen(); 
                  imagen != null ?
                  setState(() {
                    imagenSubir = File(imagen.path);
                    
                  })
                  : imagenSubir = null;
                    
                    
                  },
                  child: Text('Cambiar imagen'),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
    );
  }
}

