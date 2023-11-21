//Los like son colocados automaitamente en 0
  //recordar en editar eventos pasar el numero de likes 



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestorage_service.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';
import 'dart:io';




class NuevoEventoPage extends StatefulWidget {
  final User usuario;

  const NuevoEventoPage({Key? key, required this.usuario}) : super(key: key);


  @override
  State<NuevoEventoPage> createState() => _NuevoEventoPageState();
}

class _NuevoEventoPageState extends State<NuevoEventoPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  DateTime fechaHora = DateTime.now();

  String selectedTipo = 'Fiesta';
  List<String> tipos = ['Fiesta', 'Evento deportivo', 'Concierto'];

  File? imagenSubir;
  String url = ''; 

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> listaErrores = [];
  
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
                  child: Text('Seleccionar imagen'),
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
                    : Text('No se ha seleccionado ninguna imagen'),
              ),
              // BOTON Nuevo Evento
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Crear Nuevo Evento', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    
                    // Validar el formulario
                    if (formKey.currentState!.validate() && imagenSubir != null) 
                    {
                      print('Todo bien');

                        // Subir la imagen
                        url = await FireStorageService().subirImagen(imagenSubir!);
                        
                        
                            FirestoreService().eventoAgregar(
                              nombreCtrl.text.trim(),
                              descripcionCtrl.text.trim(),
                              lugarCtrl.text.trim(),
                              selectedTipo,
                              fechaHora,
                              url,
                              widget.usuario.uid,
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

