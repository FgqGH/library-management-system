package com.lms.library.controller;

import com.lms.library.common.Result;
import com.lms.library.dto.AdminLoginResponse;
import com.lms.library.dto.LoginRequest;
import com.lms.library.dto.ReaderLoginResponse;
import com.lms.library.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;
    public AuthController(AuthService authService) { this.authService = authService; }

    @PostMapping("/reader/login")
    public Result<ReaderLoginResponse> readerLogin(@Valid @RequestBody LoginRequest req) {
        return Result.ok(authService.readerLogin(req));
    }

    @PostMapping("/admin/login")
    public Result<AdminLoginResponse> adminLogin(@Valid @RequestBody LoginRequest req) {
        return Result.ok(authService.adminLogin(req));
    }

    @PostMapping("/logout")
    public Result<Void> logout() { return Result.ok(); }
}
