package com.lms.library.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lms.library.common.PageResult;
import com.lms.library.entity.Book;
import com.lms.library.mapper.BookMapper;
import org.springframework.stereotype.Service;

@Service
public class BookService {
    private final BookMapper bookMapper;
    public BookService(BookMapper bookMapper) { this.bookMapper = bookMapper; }

    public PageResult<Book> list(String keyword, String category, int page, int limit) {
        Page<Book> p = new Page<>(page, limit);
        LambdaQueryWrapper<Book> q = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isBlank())
            q.like(Book::getTitle, keyword).or().like(Book::getAuthor, keyword).or().like(Book::getIsbn, keyword);
        if (category != null && !category.isBlank())
            q.eq(Book::getCategory, category);
        q.eq(Book::getStatus, 1);
        q.orderByDesc(Book::getCreatedAt);
        IPage<Book> result = bookMapper.selectPage(p, q);
        return PageResult.of(result.getRecords(), result.getTotal(), page, limit);
    }

    public Book getById(Long id) { return bookMapper.selectById(id); }

    public Book create(Book book) {
        book.setStatus(1);
        if (book.getStock() == null) book.setStock(book.getTotal());
        bookMapper.insert(book);
        return book;
    }

    public Book update(Long id, Book book) {
        Book existing = bookMapper.selectById(id);
        if (existing == null) throw new RuntimeException("图书不存在");
        book.setId(id);
        bookMapper.updateById(book);
        return bookMapper.selectById(id);
    }

    public void delete(Long id) { bookMapper.deleteById(id); }

    public long totalCount() { return bookMapper.selectCount(new LambdaQueryWrapper<Book>()); }
}
