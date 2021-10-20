<%@page import="com.fasterxml.jackson.annotation.JsonTypeInfo.Id"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<!-- Favicons -->
    <link rel="apple-touch-icon" href="bootstrap/assets/img/icon.png">
    <link rel="icon" href="bootstrap/assets/img/icon.png">
    
<title>산 책 조 아</title>

<!-- Bootstrap Core CSS -->
<link
	href="bootstrap/mainBootstrap/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Custom Fonts -->
<link
	href="bootstrap/mainBootstrap/vendor/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
<link
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700,300italic,400italic,700italic"
	rel="stylesheet" type="text/css">
<link
	href="bootstrap/mainBootstrap/vendor/simple-line-icons/css/simple-line-icons.css"
	rel="stylesheet">

<!-- Custom CSS -->
<link href="bootstrap/mainBootstrap/css/stylish-portfolio1.css"
	rel="stylesheet">

<script>

function doSubmit(f) { //전송시 유효성 체크

	if (f.chatId.value == "") {
		$('#name').html('<p style="color:red;">채팅 아이디를 입력해주세요.</p>');
		f.chatId.focus();
		return false;
	}
}
</script>

</head>
<body id="page-top">
    <!-- Navigation -->
    <a class="menu-toggle rounded" href="#">
      <i class="fa fa-bars"></i>
    </a>
    <nav id="sidebar-wrapper">
      <ul class="sidebar-nav">
        <li class="sidebar-brand">
          <a class="js-scroll-trigger" href="/main.do">산 책 조 아</a>
        </li>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="home.do">홈</a>
        </li>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="join.do">회원가입</a>
        </li>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="chatId.do">채팅</a>
        </li>
      </ul>
    </nav>
    
	<!-- chatId Input -->
	<section class="content-section bg-light" id="id_search">
		<div class="container" style="width: 30%">
			<div class="content-section-heading text-center">
				<h3 class="mb-0">Chat Id Input</h3>
				<h2 class="mb-5">Chat</h2>
			</div>
			<div class="card card-login mx-auto mt-5">
				<div class="card-header" align="center" style="color: black;">Chat Id Input</div>
				<div class="card-body">
					<form style="color: black;" onsubmit="return doSubmit(this);" method="post" action="chat.do">
						<div class="form-group" align="left">
							<label for="chatId">채팅 아이디</label>
							<input class="form-control" id="chatId" name="chatId" type="text"
								placeholder="Chat Id Input">
							<div id="name"></div>
						</div>
						<br>
						<input type="submit" value="채팅 시작" class="btn btn-success btn-block">
						<br>
					</form>
					<div class="text-center">
						<a class="text-muted small mt-3" href="login.do">로그인&nbsp;|&nbsp;</a>
						<a class="text-muted small" href="passwordFind.do">비밀번호 찾기&nbsp;|&nbsp;</a>
						<a class="text-muted small" href="join.do">회원가입</a>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Footer -->
	<footer class="footer text-center">
		<div class="container">
			<p class="text-muted small mb-0">문의 : 관리자 (cksgnl4285@naver.com)</p>
			<br>
			<p class="text-muted small mb-0">Copyright &copy; Your Website 2021</p>
		</div>
	</footer>

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded js-scroll-trigger" href="#page-top">
		<i class="fa fa-angle-up"></i>
	</a>

	<!-- Bootstrap core JavaScript -->
	<script src="bootstrap/mainBootstrap/vendor/jquery/jquery.min.js"></script>
	<script src="bootstrap/mainBootstrap/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Plugin JavaScript -->
	<script src="bootstrap/mainBootstrap/vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for this template -->
	<script src="bootstrap/mainBootstrap/js/stylish-portfolio.min.js"></script>

</body>

</html>
