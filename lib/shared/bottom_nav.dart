import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

 class BottomNav extends StatefulWidget {
   const BottomNav({super.key});

   @override
   State<BottomNav> createState() => _BottomNavState();
 }

 class _BottomNavState extends State<BottomNav> {
   @override
   Widget build(BuildContext context) {
     return BottomNavigationBar(
         items: const [
           BottomNavigationBarItem(
               icon: Icon(FontAwesomeIcons.graduationCap,
               size: 20,),
               label: 'Topics'),
           BottomNavigationBarItem(
               icon: Icon(FontAwesomeIcons.peopleGroup,
               size: 20,),
               label: 'About'),
           BottomNavigationBarItem(
               icon: Icon(FontAwesomeIcons.user,
               size: 20,),
               label: 'Profile')
         ],
       fixedColor: Colors.amber,
       onTap: (int value) {
           switch(value){
             case 0:
               break;
             case 1:
               Navigator.pushNamed(context, '/about');
               break;
             case 2:
               Navigator.pushNamed(context, '/profile');
               break;
           }
       }
     );
   }
 }
