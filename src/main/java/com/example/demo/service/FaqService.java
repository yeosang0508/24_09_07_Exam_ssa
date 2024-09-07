package com.example.demo.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.FaqRepository;

@Service
public class FaqService {

    @Autowired
    private FaqRepository faqRepository;

    public String getAnswerForQuestion(String question) {
       
        String answer = faqRepository.findAnswerByQuestion(question);
        if (answer == null || answer.isEmpty()) {
            return "관련된 FAQ가 없습니다. 관리자에게 문의해 주세요.";
        }
        return answer;
    }
}
