package com.lms.library.dto;

import lombok.Data;

@Data
public class AdminLoginResponse {
    private String token;
    private AdminInfo admin;

    @Data
    public static class AdminInfo {
        private Long id;
        private String username;
        private String realName;
        private String role;
    }
}
