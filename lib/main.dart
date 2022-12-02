import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var rng = Random();
  String? savePath;
  String downlaod = '0';
  double progress = 0.0;
  String status = 'Download in progress';
  String img = 'https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  Directory directory = Directory('/storage/emulated/0/Pictures/Images');

  @override
  void initState() {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    super.initState();
  }

  Future<void> downloadFile(uri) async {
    
    savePath = '/storage/emulated/0/Pictures/Images/Images${rng.nextInt(1000000)}.png';

    Dio dio = Dio();

    dio.download(
      uri,
      savePath,
      onReceiveProgress: (rcv, total) {
        setState(() {
          downlaod = ((rcv / total) * 100).toStringAsFixed(0);
          progress = double.parse(downlaod);
        });
        if(downlaod == '100') {
          setState(() {
            status = "Download complete";
          });
        } 
      },
      deleteOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Network Image Download',style: TextStyle(fontSize: 15),),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(img),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: (){
                  downloadFile(img);
                }, 
                child: const Text("Download") 
              ),
            ),
            const SizedBox(height: 20,),
            Text(status),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child:  LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  value: progress,
              ),
            ),
            const SizedBox(height: 10,),
            const Text("Path : /storage/emulated/0/Pictures/Images"),
          ],
        ),
      ),
    );
  }
}
