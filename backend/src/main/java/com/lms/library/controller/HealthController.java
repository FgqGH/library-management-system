package com.lms.library.controller;

import com.lms.library.common.Result;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class HealthController {
    @GetMapping("/health")
    public Result<?> health() {
        return Result.ok(Map.of("status", "ok", "timestamp", LocalDateTime.now().toString()));
    }
}
