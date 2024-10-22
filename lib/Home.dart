import 'package:flutter/material.dart';
import 'package:sample_logins/Login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text("Dashboard",style: TextStyle(color: Colors.white),)),
            IconButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));}, icon: Icon(Icons.logout,color: Colors.white,)),
          ],
        ),
      ),
    body: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 170, // Fixed width
                height: 150, // Fixed height, representing 1/4 of the screen in a simple way
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(2, 4), // Slight shadow offset
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Container',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              Container(
                width: 170, // Fixed width
                height: 150, // Fixed height, representing 1/4 of the screen in a simple way
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(2, 4), // Slight shadow offset
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Container',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                width: 170, // Fixed width
                height: 150, // Fixed height, representing 1/4 of the screen in a simple way
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(2, 4), // Slight shadow offset
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Container',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              Container(
                width: 170, // Fixed width
                height: 150, // Fixed height, representing 1/4 of the screen in a simple way
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(2, 4), // Slight shadow offset
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Container',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
