<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="${board.code } LIST"></c:set>
<%@ include file="../common/head.jspf"%>
<hr />

<section class="mt-24 text-xl px-4">
	<div class="mx-auto">
		
		<div class="mb-4 flex">
			<div>${articlesCount}개</div>
			<div class="flex-grow"></div>
			<form action="">
				<input type="hidden" name="boardId" value="${param.boardId}" />
				<div class="flex">
					<select class="select select-sm select-bordered max-w-xs" name="searchKeywordTypeCode"
						data-value="${param.searchKeywordTypeCode}">
						<option value="title">제목</option>
						<option value="body">내용</option>
						<option value="title,body">제목+내용</option>
					</select>
					<label class="ml-3 input input-bordered input-sm flex items-center gap-2">
						<input type="text" placeholder="검색어를 입력해 주세요" name="searchKeyword" value="${param.searchKeyword}" />
						<button type="submit">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="h-4 w-4 opacity-70">
                                <path fill-rule="evenodd"
									d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z"
									clip-rule="evenodd" />
                            </svg>
						</button>
					</label>
				</div>
			</form>
		</div>

		<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
			<thead>
				<tr>
					<th style="text-align: center;">ID</th>
					<th style="text-align: center;">등록일</th>
					<th style="text-align: center;">제목</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="article" items="${articles}">
					<tr class="hover">
						<td style="text-align: center;">${article.id}</td>
						<td style="text-align: center;">${article.regDate.substring(0,10)}</td>
						<td style="text-align: center;">
							<a class="hover:underline" href="detail?id=${article.id}">${article.title}</a>
						</td>
					</tr>
				</c:forEach>

				<c:if test="${empty articles}">
					<tr>
						<td colspan="3" style="text-align: center;">게시글이 없습니다</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>

	<div class="pagination flex justify-center mt-3">
		<c:set var="paginationLen" value="3" />
		<c:set var="startPage" value="${page - paginationLen >= 1 ? page - paginationLen : 1}" />
		<c:set var="endPage" value="${page + paginationLen <= pagesCount ? page + paginationLen : pagesCount}" />

		<c:set var="baseUri" value="?boardId=${boardId}" />
		<c:set var="baseUri" value="${baseUri}&searchKeywordTypeCode=${searchKeywordTypeCode}" />
		<c:set var="baseUri" value="${baseUri}&searchKeyword=${searchKeyword}" />

		<c:if test="${startPage > 1}">
			<a class="btn btn-sm" href="${baseUri}&page=1">1</a>
		</c:if>
		<c:if test="${startPage > 2}">
			<button class="btn btn-sm btn-disabled">...</button>
		</c:if>

		<c:forEach begin="${startPage}" end="${endPage}" var="i">
			<a class="btn btn-sm ${param.page == i ? 'btn-active' : ''}" href="${baseUri}&page=${i}">${i}</a>
		</c:forEach>

		<c:if test="${endPage < pagesCount - 1}">
			<button class="btn btn-sm btn-disabled">...</button>
		</c:if>
		<c:if test="${endPage < pagesCount}">
			<a class="btn btn-sm" href="${baseUri}&page=${pagesCount}">${pagesCount}</a>
		</c:if>
	</div>

	<!-- 질문 입력 및 답변 출력 폼 -->
	<h3>질문을 입력하세요:</h3>
	<div style="display: flex; align-items: center;">
		<textarea id="question" placeholder="질문을 입력해 주세요..." rows="4" style="flex: 1;"></textarea>
		<button type="button" style="margin-left: 10px;" class="btn btn-primary" onclick="submitQuestion()">질문하기</button>
	</div>

	<!-- 답변 표시 영역 -->
	<div id="answerSection" style="display: none; margin-top: 20px;">
		<h4>자동 답변:</h4>
		<p id="answerText"></p>
	</div>

</section>

<script type="text/javascript">
    // 질문 제출 및 답변 처리 (AJAX)
    function submitQuestion() {
        const question = $('#question').val().trim();
        
        if (question.length === 0) {
            alert('질문을 입력해 주세요.');
            return;
        }

        // AJAX 요청으로 질문 보내기
        $.ajax({
            type: 'POST',
            url: '/usr/article/getAsk',
            data: { question: question },
            success: function(answer) {
                // 서버에서 받은 답변 처리
                $('#answerSection').show();
                $('#answerText').text(answer);
            },
            error: function() {
                alert('오류가 발생했습니다. 다시 시도해 주세요.');
            }
        });
    }
</script>


<%@ include file="../common/foot.jspf"%>
