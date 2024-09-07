<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MODIFY"></c:set>
<%@ include file="../common/head.jspf"%>

<hr />

<section class="mt-24 text-xl px-4">
	<div class="mx-auto">
		<form action="../article/doModify" method="POST">
			<input type="hidden" name="id" value="${article.id}" />
			<input type="hidden" name="body">
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th style="text-align: center;">ID</th>
						<td style="text-align: center;">${article.id}</td>
					</tr>
					<tr>
						<th style="text-align: center;">등록일</th>
						<td style="text-align: center;">${article.regDate.substring(0,10)}</td>
					</tr>
					<tr>
						<th style="text-align: center;">수정일</th>
						<td style="text-align: center;">${article.updateDate}</td>
					</tr>
					<tr>
						<th style="text-align: center;">제목</th>
						<td style="text-align: center;">
							<input name="title" value="${article.title}" type="text" autocomplete="off" placeholder="새 제목을 입력해 주세요"
								class="input input-bordered input-primary w-full max-w-xs input-sm" />
						</td>
					</tr>
					<tr>
						<th style="text-align: center;">내용</th>
						<td style="text-align: center;">
							<textarea name="body" class="input input-bordered input-primary w-full max-w-xs input-sm">${article.body}</textarea>
						</td>
					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-primary">수정하기</button>
						</td>
					</tr>
				</tbody>
			</table>
		</form>

		<div class="btns">
			<button class="btn" type="button" onclick="history.back()">뒤로가기</button>
			<a class="btn" href="../article/modify?id=${article.id}">수정</a>
			<a class="btn" href="../article/doDelete?id=${article.id}">삭제</a>

		</div>
	</div>
</section>

<%@ include file="../common/foot.jspf"%>
