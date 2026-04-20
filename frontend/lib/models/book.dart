class Book {
  final int? id;
  final String isbn;
  final String title;
  final String? author;
  final String? publisher;
  final String? category;
  final String? coverUrl;
  final int stock;
  final int total;
  final double? price;
  final String? description;
  final int status;
  final DateTime? createdAt;

  Book({
    this.id, required this.isbn, required this.title,
    this.author, this.publisher, this.category, this.coverUrl,
    this.stock = 0, this.total = 0, this.price, this.description,
    this.status = 1, this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      isbn: json['isbn'] ?? '',
      title: json['title'] ?? '',
      author: json['author'],
      publisher: json['publisher'],
      category: json['category'],
      coverUrl: json['cover_url'],
      stock: json['stock'] ?? 0,
      total: json['total'] ?? 0,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      description: json['description'],
      status: json['status'] ?? 1,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'isbn': isbn, 'title': title,
    if (author != null) 'author': author,
    if (publisher != null) 'publisher': publisher,
    if (category != null) 'category': category,
    if (coverUrl != null) 'cover_url': coverUrl,
    'stock': stock, 'total': total,
    if (price != null) 'price': price,
    if (description != null) 'description': description,
    'status': status,
  };
}
