import 'package:brew_crew/consttants.dart';
import 'package:brew_crew/screens/pdf_reader.dart';
import 'package:brew_crew/widgets/book_rating.dart';
import 'package:brew_crew/widgets/two_side_rounded_button.dart';
import 'package:flutter/material.dart';
import '../models/books.dart';

class ReadingListCard extends StatelessWidget {
  final Book book;

  ReadingListCard({this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, bottom: 40),
      height: 310,
      width: 202,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 155,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: ClipRRect(
              child: Image.asset(
                book.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          BookRating(score: book.rating),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 50,
            width: 202,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: RichText(
                    maxLines: 3,
                    text: TextSpan(
                      style: TextStyle(color: kBlackColor),
                      children: [
                        TextSpan(
                          text: book.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: book.auth,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: book.categ,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TwoSideRoundedButton(
                  text: "Buy",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PDFReader(
                            id: book.id,
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
