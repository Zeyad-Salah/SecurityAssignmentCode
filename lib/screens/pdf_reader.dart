import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PDFReader extends StatelessWidget {
  // const PDFReader({ Key key }) : super(key: key);
  final String id;
  PDFReader({this.id});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width ,
          height: height ,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.amber,
          ),
          child: Center(
            child: SfPdfViewer.asset(
                'assets/books/$id.pdf'),
          )
        ),
      ),
      
    );
  }
}