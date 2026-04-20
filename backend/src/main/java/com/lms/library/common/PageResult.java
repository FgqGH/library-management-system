package com.lms.library.common;

import lombok.Data;
import java.util.List;

@Data
public class PageResult<T> {
    private List<T> records;
    private long total;
    private long page;
    private long limit;

    public static <T> PageResult<T> of(List<T> records, long total, long page, long limit) {
        PageResult<T> r = new ResultP<>();
        r.setRecords(records); r.setTotal(total); r.setPage(page); r.setLimit(limit);
        return r;
    }

    private static class ResultP<T> extends PageResult<T> {}
}
