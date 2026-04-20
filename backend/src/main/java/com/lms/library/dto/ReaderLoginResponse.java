package com.lms.library.dto;

import lombok.Data;

@Data
public class ReaderLoginResponse {
    private String token;
    private ReaderInfo reader;

    @Data
    public static class ReaderInfo {
        private Long id;
        private String username;
        private String realName;
        private String phone;
        private String email;
    }
}
