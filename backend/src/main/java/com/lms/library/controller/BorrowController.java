package com.lms.library.controller;

import com.lms.library.common.Result;
import com.lms.library.entity.BorrowRecord;
import com.lms.library.security.filter.JwtAuthenticationFilter.LoginUser;
import com.lms.library.service.BorrowService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/borrows")
public class BorrowController {
    private final BorrowService borrowService;
    public BorrowController(BorrowService borrowService) { this.borrowService = borrowService; }

    @GetMapping
    public Result<?> list(
            @RequestParam(required = false) Long readerId,
            @RequestParam(required = false) Long bookId,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit,
            @AuthenticationPrincipal LoginUser user) {
        // 读者只能看自己的借阅记录
        if ("READER".equals(user.role())) {
            return Result.ok(borrowService.myBorrows(user.userId(), page, limit));
        }
        return Result.ok(borrowService.list(readerId, bookId, status, page, limit));
    }

    @GetMapping("/my")
    public Result<?> myBorrows(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit,
            @AuthenticationPrincipal LoginUser user) {
        return Result.ok(borrowService.myBorrows(user.userId(), page, limit));
    }

    @PostMapping
    public Result<BorrowRecord> borrow(@RequestBody java.util.Map<String, Long> body,
                                       @AuthenticationPrincipal LoginUser user) {
        Long bookId = body.get("bookId");
        return Result.ok(borrowService.borrow(user.userId(), bookId));
    }

    @PutMapping("/{id}/return")
    public Result<BorrowRecord> doReturn(@PathVariable Long id) {
        return Result.ok(borrowService.doReturn(id));
    }
}
