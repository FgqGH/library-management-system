package com.lms.library.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lms.library.common.PageResult;
import com.lms.library.entity.Reader;
import com.lms.library.mapper.ReaderMapper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class ReaderService {
    private final ReaderMapper readerMapper;
    private final PasswordEncoder passwordEncoder;
    public ReaderService(ReaderMapper readerMapper, PasswordEncoder passwordEncoder) {
        this.readerMapper = readerMapper; this.passwordEncoder = passwordEncoder;
    }

    public PageResult<Reader> list(int page, int limit, String keyword) {
        Page<Reader> p = new Page<>(page, limit);
        LambdaQueryWrapper<Reader> q = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isBlank())
            q.like(Reader::getRealName, keyword).or().like(Reader::getUsername, keyword);
        q.orderByDesc(Reader::getCreatedAt);
        IPage<Reader> result = readerMapper.selectPage(p, q);
        return PageResult.of(result.getRecords(), result.getTotal(), page, limit);
    }

    public Reader getById(Long id) { return readerMapper.selectById(id); }

    public Reader create(Reader reader) {
        reader.setPassword(passwordEncoder.encode(reader.getPassword()));
        reader.setStatus(1);
        readerMapper.insert(reader);
        return reader;
    }

    public Reader update(Long id, Reader reader) {
        Reader existing = readerMapper.selectById(id);
        if (existing == null) throw new RuntimeException("读者不存在");
        if (reader.getPassword() != null && !reader.getPassword().isBlank())
            reader.setPassword(passwordEncoder.encode(reader.getPassword()));
        else reader.setPassword(null);
        reader.setId(id);
        readerMapper.updateById(reader);
        return readerMapper.selectById(id);
    }

    public void delete(Long id) { readerMapper.deleteById(id); }
    public long totalCount() { return readerMapper.selectCount(null); }
}
