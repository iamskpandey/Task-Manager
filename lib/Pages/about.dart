import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: const Text('About Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Developed by:',
                style: TextStyle(
                  color: Color.fromARGB(255, 125, 120, 10),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const Text('Sailesh Kumar Pandey',
                style: TextStyle(
                  color: Color.fromARGB(255, 125, 120, 10),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Divider(
                color: Colors.amber,
              ),
            ),
            const Text('For any queries, contact at:',
                style: TextStyle(
                  color: Color.fromARGB(255, 125, 120, 10),
                  fontSize: 16,
                )),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/github.png', width: 17, height: 17),
                const SizedBox(width: 5),
                const Text('saileshkpandey',
                    style: TextStyle(
                      color: Color.fromARGB(255, 125, 120, 10),
                      fontSize: 16,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/linkedin.png',
                    width: 17, height: 17),
                const SizedBox(width: 5),
                const Text('saileshkumarpandey',
                    style: TextStyle(
                      color: Color.fromARGB(255, 125, 120, 10),
                      fontSize: 16,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
