

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class FireStorageService{

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> subirImagen(File imagen) async{

    final String nombreFile = imagen.path.split('/').last;

    final Reference ref = storage.ref().child('imagen').child(nombreFile);

    final UploadTask uploadTask = ref.putFile(imagen);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

    final String url = await snapshot.ref.getDownloadURL();

    return url;

  }

  Future<XFile?> getImagen() async{
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    return imagen;
  }

}
