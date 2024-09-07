package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.demo.vo.Board;

@Mapper
public interface FaqRepository {
	@Select("""
			SELECT answer
			FROM faq
			WHERE question LIKE CONCAT('%', #{question}, '%')
			LIMIT 1
			""")
	String findAnswerByQuestion(String question);
}