import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  final User user;

  const HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    border: Border.all(color: Colors.black, width: 1), // Añadir borde negro
                    // Añadir padding a todas las direcciones
                    
                  ),
                  child: Center(
                    child: Text(
                      user.displayName?.substring(0, 1).toUpperCase() ?? '',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? ''),
              accountEmail: Text(user.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60, // Ajusta el tamaño del CircleAvatar aquí
                child: Text(
                  user.displayName?.substring(0, 1).toUpperCase() ?? '',
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
                // Puedes implementar esto según tu estructura de navegación
              },
            ),
            ListTile(
              title: Text('Cerrar sesión'),
              onTap: () {
                // Lógica para cerrar sesión
                // Puedes implementar esto según tu lógica de cierre de sesión
              },
            ),
          ],
        ),
      ),
      body: Container(
        
      ),
    );
  }
}
