package com.lms.library.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lms.library.dto.*;
import com.lms.library.entity.Admin;
import com.lms.library.entity.Reader;
import com.lms.library.mapper.AdminMapper;
import com.lms.library.mapper.ReaderMapper;
import com.lms.library.security.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final ReaderMapper readerMapper;
    private final AdminMapper adminMapper;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;

    public AuthService(ReaderMapper readerMapper, AdminMapper adminMapper,
                       JwtUtil jwtUtil, PasswordEncoder passwordEncoder) {
        this.readerMapper = readerMapper;
        this.adminMapper = adminMapper;
        this.jwtUtil = jwtUtil;
        this.passwordEncoder = passwordEncoder;
    }

    public ReaderLoginResponse readerLogin(LoginRequest req) {
        Reader reader = readerMapper.selectOne(new LambdaQueryWrapper<Reader>()
            .eq(Reader::getUsername, req.getUsername()));
        if (reader == null || !passwordEncoder.matches(req.getPassword(), reader.getPassword()))
            throw new RuntimeException("用户名或密码错误");
        if (reader.getStatus() == 0) throw new RuntimeException("账号已被禁用");

        ReaderLoginResponse resp = new ReaderLoginResponse();
        resp.setToken(jwtUtil.generateToken(reader.getUsername(), "READER", reader.getId()));
        ReaderLoginResponse.ReaderInfo info = new ReaderLoginResponse.ReaderInfo();
        info.setId(reader.getId()); info.setUsername(reader.getUsername());
        info.setRealName(reader.getRealName()); info.setPhone(reader.getPhone());
        info.setEmail(reader.getEmail());
        resp.setReader(info);
        return resp;
    }

    public AdminLoginResponse adminLogin(LoginRequest req) {
        Admin admin = adminMapper.selectOne(new LambdaQueryWrapper<Admin>()
            .eq(Admin::getUsername, req.getUsername()));
        if (admin == null || !passwordEncoder.matches(req.getPassword(), admin.getPassword()))
            throw new RuntimeException("用户名或密码错误");
        if (admin.getStatus() == 0) throw new RuntimeException("账号已被禁用");

        AdminLoginResponse resp = new AdminLoginResponse();
        resp.setToken(jwtUtil.generateToken(admin.getUsername(), admin.getRole(), admin.getId()));
        AdminLoginResponse.AdminInfo info = new AdminLoginResponse.AdminInfo();
        info.setId(admin.getId()); info.setUsername(admin.getUsername());
        info.setRealName(admin.getRealName()); info.setRole(admin.getRole());
        resp.setAdmin(info);
        return resp;
    }
}
