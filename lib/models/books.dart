class Book{

final String image;
  final String title;
  final String auth;
  final String id;
  final String categ;
  final double rating;
  final Function pressDetails;
  final Function pressRead;
  const Book({
    
    this.image,
    this.id,
    this.title,
    this.auth,
    this.categ,
    this.rating,
    this.pressDetails,
    this.pressRead,
  }) ;

}

class Books{
  List<Book> books = [Book(
    image: "assets/images/book-1.jpg",
                          title: "Atomic Habits",
                          auth: "\nJames Clear",
                          rating: 4.9,
                          id: '1',
                          categ: "\t (self-help)",
  ),
  Book(
     image: "assets/images/book-2.jpg",
                          title: "Digital Design and Computer Architecture",
                          auth: "\nDavid Harris",
                          rating: 3,
                          id: '2',
                          categ: "\t (Academic)",
  ),
   Book(
     image: "assets/images/book-3.jpg",
                          title: "One of Us Is Next",
                          auth: "\nKaren McManus",
                          rating: 3.5,
                          id: '3',
                          categ: "\t (Mystery)",
  ),
   Book(
     image: "assets/images/book-4.jpg",
                          title: "Introduction To The Theroy Of Computation",
                          auth: "\nMicheal Sipser",
                          rating: 4.3,
                          id: '4',
                          categ: "\t (Academic)",
  ),];
}
