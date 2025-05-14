

import 'package:flutter/material.dart';

class StarterPack extends StatefulWidget {
  static const String routeName = '/manageaccount';

  const StarterPack({super.key});

  @override
  _StarterPackState createState() => _StarterPackState();
}

class _StarterPackState extends State<StarterPack> with RouteAware {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: width * .25,
            ),
            const Text('StarterPack',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_sharp),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: width * .30,
                ),
                const Text('GOD IS GOOD',
                    style: TextStyle(
                        fontSize: 25,
                        backgroundColor: Colors.amberAccent,
                        fontWeight: FontWeight.w500)),
                IconButton(
                    icon: const Icon(Icons.article_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),



        
      ]),
    ));
  }
}
