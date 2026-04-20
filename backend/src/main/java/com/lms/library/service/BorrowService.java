package com.lms.library.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lms.library.common.PageResult;
import com.lms.library.entity.Book;
import com.lms.library.entity.BorrowRecord;
import com.lms.library.mapper.BookMapper;
import com.lms.library.mapper.BorrowRecordMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Service
public class BorrowService {
    private final BorrowRecordMapper borrowRecordMapper;
    private final BookMapper bookMapper;
    public BorrowService(BorrowRecordMapper borrowRecordMapper, BookMapper bookMapper) {
        this.borrowRecordMapper = borrowRecordMapper;
        this.bookMapper = bookMapper;
    }

    public PageResult<BorrowRecord> list(Long readerId, Long bookId, String status, int page, int limit) {
        Page<BorrowRecord> p = new Page<>(page, limit);
        LambdaQueryWrapper<BorrowRecord> q = new LambdaQueryWrapper<>();
        if (readerId != null) q.eq(BorrowRecord::getReaderId, readerId);
        if (bookId != null) q.eq(BorrowRecord::getBookId, bookId);
        if (status != null && !status.isBlank()) q.eq(BorrowRecord::getStatus, status);
        q.orderByDesc(BorrowRecord::getCreatedAt);
        IPage<BorrowRecord> result = borrowRecordMapper.selectPage(p, q);
        return PageResult.of(result.getRecords(), result.getTotal(), page, limit);
    }

    public PageResult<BorrowRecord> myBorrows(Long readerId, int page, int limit) {
        return list(readerId, null, null, page, limit);
    }

    @Transactional
    public BorrowRecord borrow(Long readerId, Long bookId) {
        Book book = bookMapper.selectById(bookId);
        if (book == null) throw new RuntimeException("图书不存在");
        if (book.getStock() <= 0) throw new RuntimeException("库存不足");

        book.setStock(book.getStock() - 1);
        bookMapper.updateById(book);

        BorrowRecord record = new BorrowRecord();
        record.setBookId(bookId);
        record.setReaderId(readerId);
        record.setBorrowDate(LocalDate.now());
        record.setDueDate(LocalDate.now().plusDays(30));
        record.setStatus("BORROWED");
        borrowRecordMapper.insert(record);
        return record;
    }

    @Transactional
    public BorrowRecord doReturn(Long recordId) {
        BorrowRecord record = borrowRecordMapper.selectById(recordId);
        if (record == null) throw new RuntimeException("借阅记录不存在");
        if ("RETURNED".equals(record.getStatus())) throw new RuntimeException("已归还");

        record.setReturnDate(LocalDate.now());
        record.setStatus("RETURNED");

        Book book = bookMapper.selectById(record.getBookId());
        if (book != null) {
            book.setStock(book.getStock() + 1);
            bookMapper.updateById(book);
        }
        borrowRecordMapper.updateById(record);
        return record;
    }

    public long borrowedCount() {
        return borrowRecordMapper.selectCount(new LambdaQueryWrapper<BorrowRecord>()
            .eq(BorrowRecord::getStatus, "BORROWED"));
    }

    public long overdueCount() {
        return borrowRecordMapper.selectCount(new LambdaQueryWrapper<BorrowRecord>()
            .eq(BorrowRecord::getStatus, "BORROWED")
            .lt(BorrowRecord::getDueDate, LocalDate.now()));
    }
}
