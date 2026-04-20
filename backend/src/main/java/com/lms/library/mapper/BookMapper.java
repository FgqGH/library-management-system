package com.lms.library.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lms.library.entity.Book;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BookMapper extends BaseMapper<Book> {}
