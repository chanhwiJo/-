<%@page import="poly.util.CmmUtil"%>
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
<link href="bootstrap/mainBootstrap/css/stylish-portfolio1.css" rel="stylesheet">
<%String session_user_id = CmmUtil.nvl((String)session.getAttribute("session_user_id")); %>
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
        <%if (session_user_id.equals("")) {%>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="login.do">로그인</a>
        </li>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="join.do">회원가입</a>
        </li>
        <%}else{ %>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="logout.do">로그아웃</a>
        </li>
        <%} %>
      </ul>
    </nav>

	<!-- Header -->
	<header class="masthead d-flex">
		<div class="container text-center my-auto">
			<h1 class="mb-1" style="color: whitesmoke">산 책 조 아</h1>
			<h3 class="mb-5" style="color: whitesmoke">
				<em>바쁜 일상속&nbsp;&nbsp;가벼운 운동...</em>
			</h3>
			<a class="btn btn-success btn-xl js-scroll-trigger" href="/main.do">로그인</a>
		</div>
		<div class="overlay"></div>
	</header>

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

