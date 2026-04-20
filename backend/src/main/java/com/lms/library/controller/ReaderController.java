package com.lms.library.controller;

import com.lms.library.common.Result;
import com.lms.library.entity.Reader;
import com.lms.library.service.ReaderService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/readers")
public class ReaderController {
    private final ReaderService readerService;
    public ReaderController(ReaderService readerService) { this.readerService = readerService; }

    @GetMapping
    public Result<?> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit,
            @RequestParam(required = false) String keyword) {
        return Result.ok(readerService.list(page, limit, keyword));
    }

    @GetMapping("/{id}")
    public Result<Reader> getById(@PathVariable Long id) {
        return Result.ok(readerService.getById(id));
    }

    @PostMapping
    public Result<Reader> create(@RequestBody Reader reader) {
        return Result.ok(readerService.create(reader));
    }

    @PutMapping("/{id}")
    public Result<Reader> update(@PathVariable Long id, @RequestBody Reader reader) {
        return Result.ok(readerService.update(id, reader));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        readerService.delete(id);
        return Result.ok();
    }
}
