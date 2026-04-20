class BorrowRecord {
  final int? id;
  final int bookId;
  final int readerId;
  final DateTime? borrowDate;
  final DateTime? dueDate;
  final DateTime? returnDate;
  final String status;
  final DateTime? createdAt;

  BorrowRecord({
    this.id, required this.bookId, required this.readerId,
    this.borrowDate, this.dueDate, this.returnDate,
    this.status = 'BORROWED', this.createdAt,
  });

  factory BorrowRecord.fromJson(Map<String, dynamic> json) {
    return BorrowRecord(
      id: json['id'],
      bookId: json['book_id'] ?? 0,
      readerId: json['reader_id'] ?? 0,
      borrowDate: json['borrow_date'] != null ? DateTime.tryParse(json['borrow_date']) : null,
      dueDate: json['due_date'] != null ? DateTime.tryParse(json['due_date']) : null,
      returnDate: json['return_date'] != null ? DateTime.tryParse(json['return_date']) : null,
      status: json['status'] ?? 'BORROWED',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  String get statusText {
    switch (status) {
      case 'BORROWED': return '借阅中';
      case 'RETURNED': return '已归还';
      case 'OVERDUE': return '已逾期';
      default: return status;
    }
  }
}
