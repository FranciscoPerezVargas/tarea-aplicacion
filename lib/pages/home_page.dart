import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart'; 
import 'EventosPage/eventos_page.dart';
import 'EventosPage/buscador_page.dart';
import 'EventosPage/nuevo_evento_page.dart';




class HomePage extends StatefulWidget {
  final User usuario;

  const HomePage({required this.usuario});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showEventos = true;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _authFire = FirebaseAuth.instance;
    final GoogleSignIn _googleSesion = GoogleSignIn();

   Future<void> _cerrarSesion(BuildContext context) async {
      await _authFire.signOut(); 
      await _googleSesion.signOut();
      Navigator.of(context).pushAndRemoveUntil( 
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Entradas'),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      widget.usuario.displayName?.substring(0, 1).toUpperCase() ?? '',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showEventos = !_showEventos; // Cambia entre eventos y el Buscador
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0, right: 10, left: 10),
        child: _showEventos ? EventosPage(usuario: widget.usuario) : BuscadorPage(),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.usuario.displayName ?? ''),
              accountEmail: Text(widget.usuario.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                child: Text(
                  widget.usuario.displayName?.substring(0, 1).toUpperCase() ?? '',
                  style: TextStyle(fontSize: 36),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Mi Perfil'),
              onTap: () {
                // Lógica para navegar a la página de perfil
              },
            ),
             ListTile(
              title: Text('Cerrar sesión'),
              onTap: () async {
                await _cerrarSesion(context); // Llama a la función para cerrar la sesión
              },
            ),
          ],
        ),
      ),
    );
  }
}
