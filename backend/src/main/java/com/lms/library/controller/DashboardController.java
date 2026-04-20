package com.lms.library.controller;

import com.lms.library.common.Result;
import com.lms.library.dto.DashboardStats;
import com.lms.library.service.*;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {
    private final BookService bookService;
    private final ReaderService readerService;
    private final BorrowService borrowService;

    public DashboardController(BookService bookService, ReaderService readerService,
                               BorrowService borrowService) {
        this.bookService = bookService;
        this.readerService = readerService;
        this.borrowService = borrowService;
    }

    @GetMapping("/stats")
    public Result<DashboardStats> stats() {
        DashboardStats s = new DashboardStats();
        s.setTotalBooks(bookService.totalCount());
        s.setTotalReaders(readerService.totalCount());
        s.setBorrowedCount(borrowService.borrowedCount());
        s.setOverdueCount(borrowService.overdueCount());
        return Result.ok(s);
    }
}
