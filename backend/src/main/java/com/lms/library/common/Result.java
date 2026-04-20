package com.lms.library.common;

import lombok.Data;

@Data
public class Result<T> {
    private int code;
    private String message;
    private T data;

    public static <T> Result<T> ok() { return ok(null); }
    public static <T> Result<T> ok(T data) {
        Result<T> r = new Result<>();
        r.setCode(200); r.setMessage("操作成功"); r.setData(data);
        return r;
    }
    public static <T> Result<T> ok(String msg, T data) {
        Result<T> r = new Result<>();
        r.setCode(200); r.setMessage(msg); r.setData(data);
        return r;
    }
    public static <T> Result<T> error(String msg) { return error(500, msg); }
    public static <T> Result<T> error(int code, String msg) {
        Result<T> r = new Result<>();
        r.setCode(code); r.setMessage(msg);
        return r;
    }
}
