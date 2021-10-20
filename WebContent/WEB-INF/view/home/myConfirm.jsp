<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="poly.util.CmmUtil" %>
<%
	String session_user_id = CmmUtil.nvl((String)session.getAttribute("session_user_id"));
%>
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
	
	if (f.user_id.value == "") {
		$('#idc').html('<p style="color:red;">아이디를 입력해주세요.</p>');
		f.user_id.focus();
		return false;
	}else{
		$('#idc').html('');
	}
	if (f.password.value == "") {
		$('#np').html('<p style="color:red;">비밀번호를 입력해주세요.</p>');
		f.password.focus();
		return false;
	}else{
		$('#np').html('');
	}
	if (f.password2.value == "") {
		$('#pc').html('<p style="color:red;">비밀번호를 입력해주세요.</p>');
		f.password2.focus();
		return false;
	}else{
		$('#pc').html('');
	}
	if (keyCheck == false) {
		$('#keyc').html('<p style="color:red;">이메일 인증을 해주세요.</p>');
		f.email_key.focus();
		return false;
	}else{
		$('#keyc').html('');
	}
	if(f.password.value.length < 6 || f.password.value.length > 12){
		$('#np').html('<p style="color:red;">비밀번호가 형식에 맞지않습니다. 다시 입력해주세요.</p>');
		f.password.focus();
		return false;
	}else{
		$('#np').html('');
	}
	if(f.password.value != f.password2.value) {
		$('#np').html('<p style="color:red;">비밀번호가 일치하지않습니다. 다시 확인해주세요.</p>');
		f.password.focus();
		return false;
	}else{
		$('#np').html('');
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
      </ul>
    </nav>
    
	<!-- find_password -->
	<section class="content-section" id="reset_password">
		<div class="container" style="width: 30%">
			<div class="content-section-heading text-center">
				<h3 class="text-secondary mb-0">Confirm</h3>
				<h2 class="mb-5">인증</h2>
				<div class="card card-login mx-auto mt-5">
					<div class="card-header">Confirm</div>
					<div class="card-body">
						<form name="f" style="color: black;" onsubmit="return doSubmit(this);" method="post" action="myConfirm_proc.do">
							<div class="form-group" align="left">
								<q><%=session_user_id %> 계정 인증</q><br>
								<label for="resetId">아이디</label>
								<input class="form-control" name="user_id" type="text" value="<%=session_user_id%>" readonly>
								<div id="idc"></div>
							</div>
							<div class="form-group" align="left">
								<label for="resetEmail">이메일</label>
								<div class="input-group">
									<input class="form-control" id="resetEmail" name="email" type="email"
										aria-describedby="emailHelp" placeholder="Email">
								</div>
								<div id="emailc"></div>
							</div>
							<div class="form-group" align="left">
								<label for="resetNumber">전화번호</label>
								<div class="input-group">
									<input class="form-control" id="resetPhone" name="phone" type="text" placeholder="number">
								</div>
								<div id="phonec"></div>
							</div>
							<br>
							<input type="submit" value="인증" class="btn btn-success btn-block">
						</form>
						<div class="text-center">
							<a class="text-muted small mt-3" href="login.do">로그인&nbsp;|&nbsp;</a>
							<a class="text-muted small" href="idSearch.do">아이디 찾기&nbsp;|&nbsp;</a>
							<a class="text-muted small" href="join.do">회원가입</a>
						</div>
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
