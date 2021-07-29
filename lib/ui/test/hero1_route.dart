import 'package:flutter/material.dart';

import 'hero2_route.dart';

class Hero1Route extends StatefulWidget {
  const Hero1Route({Key? key}) : super(key: key);

  @override
  _Hero1RouteState createState() => _Hero1RouteState();
}

class _Hero1RouteState extends State<Hero1Route> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return Hero2Route();
      // }));

      Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(seconds: 2), pageBuilder: (_, __, ___) => Hero2Route()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return Hero2Route();
          // }));
        },
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            'https://picsum.photos/250?image=9',
          ),
        ),
      ),
    );
  }
}

// class Hero1Route extends StatelessWidget {
//   const Hero1Route({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Main Screen'),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return const Hero2Route();
//           }));
//         },
//         child: Hero(
//           tag: 'imageHero',
//           child: Image.network(
//             'https://picsum.photos/250?image=9',
//           ),
//         ),
//       ),
//     );
//   }
// }
