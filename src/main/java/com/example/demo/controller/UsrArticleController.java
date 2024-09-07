package com.example.demo.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ArticleService;
import com.example.demo.service.BoardService;
import com.example.demo.service.FaqService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.Board;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrArticleController {

    private final Rq rq;
    private final ArticleService articleService;
    private final BoardService boardService;
    private final FaqService faqService;

    @Autowired
    public UsrArticleController(Rq rq, ArticleService articleService, BoardService boardService, FaqService faqService) {
        this.rq = rq;
        this.articleService = articleService;
        this.boardService = boardService;
        this.faqService = faqService;
    }

    // 질문에 대한 자동 답변 처리
    @RequestMapping("/usr/article/getAsk")
    @ResponseBody
    public String getAnswer(@RequestParam String question) {
        // 질문을 분석하고 FAQ에서 답변을 가져온다.
        String answer = faqService.getAnswerForQuestion(question);

        // 답변이 없을 경우 기본 메시지 설정
        if (Ut.isEmptyOrNull(answer)) {
            answer = "관련된 답변을 찾을 수 없습니다. 관리자에게 문의해 주세요.";
        }

        // 답변을 반환
        return answer;
    }

    @RequestMapping("/usr/article/detail")
    public String showDetail(Model model, int id) {
        Article article = articleService.getArticleById(id);

        if (article == null) {
            return rq.historyBackOnView(Ut.f("%d번 게시글은 없습니다.", id));
        }

        model.addAttribute("article", article);
        return "usr/article/detail";
    }

 
    @RequestMapping("/usr/article/modify")
    public String showModify(Model model, int id) {
        Article article = articleService.getArticleById(id);

        if (article == null) {
            return rq.historyBackOnView(Ut.f("%d번 게시글은 없습니다.", id));
        }

        model.addAttribute("article", article);
        return "usr/article/modify";
    }


    @RequestMapping("/usr/article/doModify")
    @ResponseBody
    public String doModify(int id, String title, String body) {
        Article article = articleService.getArticleById(id);

        if (article == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        articleService.modifyArticle(id, title, body);
        return Ut.jsReplace("S-1", Ut.f("%d번 게시글을 수정했습니다.", id), "../article/detail?id=" + id);
    }

    @RequestMapping("/usr/article/doDelete")
    @ResponseBody
    public String doDelete(int id) {
        Article article = articleService.getArticleById(id);

        if (article == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        articleService.deleteArticle(id);
        return Ut.jsReplace("S-1", Ut.f("%d번 게시글을 삭제했습니다.", id), "../article/list");
    }

   
    @RequestMapping("/usr/article/write")
    public String showWrite(Model model) {
        int currentId = articleService.getCurrentArticleId();
        model.addAttribute("currentId", currentId);

        return "usr/article/write";
    }


    @RequestMapping("/usr/article/doWrite")
    @ResponseBody
    public String doWrite(HttpServletRequest req, Integer boardId, String title, String body) {
        if (Ut.isEmptyOrNull(title)) {
            return Ut.jsHistoryBack("F-1", "제목을 입력해주세요.");
        }
        if (Ut.isEmptyOrNull(body)) {
            return Ut.jsHistoryBack("F-2", "내용을 입력해주세요.");
        }
        if (Ut.isEmptyOrNull(boardId)) {
            return Ut.jsHistoryBack("F-3", "게시판을 선택해주세요.");
        }

      
        ResultData<Integer> writeArticleRd = articleService.writeArticle(title, body, boardId);
        if (writeArticleRd.isFail()) {
            return Ut.jsHistoryBack(writeArticleRd.getResultCode(), writeArticleRd.getMsg());
        }

        int id = writeArticleRd.getData1();
        return Ut.jsReplace("S-1", Ut.f("%d번 게시글이 작성되었습니다.", id), "../article/detail?id=" + id);
    }

    
    @RequestMapping("/usr/article/list")
    public String showList(Model model, @RequestParam(defaultValue = "1") int boardId,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "title,body") String searchKeywordTypeCode,
                           @RequestParam(defaultValue = "") String searchKeyword) throws IOException {
        Board board = boardService.getBoardById(boardId);

        if (board == null) {
            return rq.historyBackOnView("존재하지 않는 게시판입니다.");
        }

        int articlesCount = articleService.getArticlesCount(boardId, searchKeywordTypeCode, searchKeyword);
        int itemsInAPage = 10;
        int pagesCount = (int) Math.ceil(articlesCount / (double) itemsInAPage);

        List<Article> articles = articleService.getForPrintArticles(boardId, itemsInAPage, page, searchKeywordTypeCode, searchKeyword);

        model.addAttribute("articles", articles);
        model.addAttribute("articlesCount", articlesCount);
        model.addAttribute("pagesCount", pagesCount);
        model.addAttribute("board", board);
        model.addAttribute("page", page);
        model.addAttribute("searchKeywordTypeCode", searchKeywordTypeCode);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("boardId", boardId);

        return "usr/article/list";
    }
}
