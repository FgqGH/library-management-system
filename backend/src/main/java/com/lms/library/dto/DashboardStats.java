package com.lms.library.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class DashboardStats {
    private long totalBooks;
    private long totalReaders;
    private long borrowedCount;
    private long overdueCount;
}
