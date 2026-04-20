package com.lms.library.controller;

import com.lms.library.common.Result;
import com.lms.library.entity.Book;
import com.lms.library.service.BookService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/books")
public class BookController {
    private final BookService bookService;
    public BookController(BookService bookService) { this.bookService = bookService; }

    @GetMapping
    public Result<?> list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit) {
        return Result.ok(bookService.list(keyword, category, page, limit));
    }

    @GetMapping("/{id}")
    public Result<Book> getById(@PathVariable Long id) {
        return Result.ok(bookService.getById(id));
    }

    @PostMapping
    public Result<Book> create(@RequestBody Book book) {
        return Result.ok(bookService.create(book));
    }

    @PutMapping("/{id}")
    public Result<Book> update(@PathVariable Long id, @RequestBody Book book) {
        return Result.ok(bookService.update(id, book));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        bookService.delete(id);
        return Result.ok();
    }
}
