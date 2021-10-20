<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="poly.dto.BoardDTO"%>
<%@page import="poly.dto.ManageDTO"%>
<%@page import="poly.dto.UserDTO"%>
<%@page import="poly.util.CmmUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"
	name="viewport" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<!-- Favicons -->
<link rel="apple-touch-icon" href="bootstrap/assets/img/icon.png">
<link rel="icon" href="bootstrap/assets/img/icon.png">
<title>산 책 조 아</title>
<!--     Fonts and icons     -->
<link rel="stylesheet" type="text/css"
	href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" />
<link rel="stylesheet"
	href="bootstrap/assets/css/material-dashboard.css?v=2.0.0">
<!-- Documentation extras -->
<!-- CSS Just for demo purpose, don't include it in your project -->
<link href="bootstrap/assets/assets-for-demo/demo.css" rel="stylesheet" />
<!-- iframe removal -->
<%
String session_user_name = CmmUtil.nvl((String) session.getAttribute("session_user_name"));

UserDTO u = (UserDTO) request.getAttribute("u");
ManageDTO m = (ManageDTO) request.getAttribute("m");
BoardDTO b = (BoardDTO) request.getAttribute("b");
%>
<script src="js/jquery.min.js"></script>
<script>
	$(window).on("load", function() {
		//페이지 로딩 완료 후 , 산책로 정보 api 실행
		trail();
	});

	// 산책로 정보 api
	function trail() {
		//산책로 api 데이터 가져오기
		$
				.ajax({
					type : "GET",
					url : "http://openapi.seoul.go.kr:8088/4141687278636b7337324b4a44694c/json/SeoulGilWalkCourse/1/1",
					data : {},
					success : function(res) {
						console.log(res);
						console
								.log("total_count : "
										+ res["SeoulGilWalkCourse"]["list_total_count"]);
						$('#total_count').html(
								res["SeoulGilWalkCourse"]["list_total_count"]);
					}
				});
	}
</script>
<style>
#m:link {
	color: #6c757d;
}

#m:visited {
	color: #6c757d;
}

#m:hover {
	color: #6c757d;
	text-decoration: underline;
}

.sam hr {
	margin-top: 0;
	margin-bottom: 0;
}

.sam {
	display: block;
	width: 100%;
	padding: 0.4375rem 0;
	font-size: 1rem;
}

.page-linkm {
	list-style: none;
	border: 0;
	border-radius: 30px !important;
	transition: all .3s;
	padding: 0px 11px;
	margin: 0 3px;
	min-width: 30px;
	height: 30px;
	line-height: 30px;
	color: #999999;
	font-weight: 400;
	font-size: 12px;
	text-transform: uppercase;
	background: transparent;
	text-align: center;
}

.page-linkm:not([href]):not([tabindex]) {
	color: #999999
}

.page-linkt {
	list-style: none;
	border: 0;
	border-radius: 30px !important;
	transition: all .3s;
	padding: 0px 11px;
	margin: 0 3px;
	min-width: 30px;
	height: 30px;
	line-height: 30px;
	color: #999999;
	font-weight: 400;
	font-size: 12px;
	text-transform: uppercase;
	background: transparent;
	text-align: center;
}

.page-linkt:not([href]):not([tabindex]) {
	color: #999999
}
</style>
</head>

<body id="page-top">
	<div class="wrapper">
		<div class="sidebar" data-color="green" data-background-color="white"
			data-image="bootstrap/assets/img/sidebar-1.jpg">
			<!--
        Tip 1: You can change the color of the sidebar using: data-color="purple | azure | green | orange | danger"

        Tip 2: you can also add an image using data-image tag
    -->
			<div class="logo">
				<a href="home.do" class="simple-text logo-normal"> 산 책 조 아 </a>
			</div>
			<div class="sidebar-wrapper">
				<ul class="nav">
					<li class="nav-item active "><a class="nav-link"
						href="/main.do"> <i class="material-icons">home</i>
							<p>메인</p>
					</a></li>
					<li class="nav-item "><a class="nav-link" href="/userList.do">
							<i class="material-icons">person</i>
							<p>회원 관리</p>
					</a></li>
					<li class="nav-item "><a class="nav-link" href="/teamL.do">
							<i class="material-icons">dvr</i>
							<p>동호회 관리</p>
					</a></li>
					<li class="nav-item "><a class="nav-link" href="/boardL.do">
							<i class="material-icons">list</i>
							<p>자유게시판</p>
					</a></li>
				</ul>
			</div>
		</div>
		<div class="main-panel">
			<!-- Navbar -->
			<jsp:include page="top.jsp" flush="true" />
			<!-- End Navbar -->
			<br>
			<br>
			<div class="content">
				<div class="container-fluid">
					<div class="row">
						<div class="stats" style="width: 100%; text-align: center;">
							<b style="font-size: 40px;">관리자 페이지</b>
							<br>
							<br>
						</div>
					</div>
					<br>
					<br>
					<div class="row">
						<div class="col-lg-3 col-md-6 col-sm-6">
							<div class="card card-stats">
								<div class="card-header card-header-warning card-header-icon">
									<div class="card-icon">
										<i class="material-icons">highlight</i>
									</div>
									<p class="card-category">Informations</p>
									<h3 class="card-title">
										<strong id="total_count"></strong>
									</h3>
								</div>
								<div class="card-footer">
									<div class="stats">공공데이터포털에서 제공하는 산책로 수</div>
								</div>
							</div>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6">
							<div class="card card-stats">
								<div class="card-header card-header-success card-header-icon">
									<div class="card-icon">
										<i class="material-icons">face</i>
									</div>
									<p class="card-category">Members</p>
									<h3 class="card-title">
										<strong><%=u.getData()%></strong>
									</h3>
								</div>
								<div class="card-footer">
									<div class="stats">회원가입한 회원 수</div>
								</div>
							</div>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6">
							<div class="card card-stats">
								<div class="card-header card-header-danger card-header-icon">
									<div class="card-icon">
										<i class="material-icons">bubble_chart</i>
									</div>
									<p class="card-category">Clubs</p>
									<h3 class="card-title">
										<strong><%=m.getNum()%></strong>
									</h3>
								</div>
								<div class="card-footer">
									<div class="stats">동호회 개수</div>
								</div>
							</div>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6">
							<div class="card card-stats">
								<div class="card-header card-header-info card-header-icon">
									<div class="card-icon">
										<i class="material-icons">loyalty</i>
									</div>
									<p class="card-category">Posts</p>
									<h3 class="card-title">
										<strong><%=b.getData()%></strong>
									</h3>
								</div>
								<div class="card-footer">
									<div class="stats">총 게시물 수</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<footer class="footer ">
			<div class="container-fluid">
				<nav class="pull-left">
					<p class="text-muted small mb-0">문의 : 관리자
						(cksgnl4285@naver.com)</p>
					<br>
					<p class="text-muted small mb-0" align="left">
						정보출처 : 공공데이터포털 (<a id="m" href="http://www.data.go.kr"
							target="_blank">www.data.go.kr</a>)
					</p>
				</nav>
				<div class="copyright pull-right">&copy; 2021, made with love
					by chanhwi for a better web.</div>
			</div>
		</footer>
	</div>
	</div>
</body>
<!--   Core JS Files   -->
<script src="bootstrap/assets/js/core/jquery.min.js"></script>
<script src="bootstrap/assets/js/core/popper.min.js"></script>
<script src="bootstrap/assets/js/bootstrap-material-design.js"></script>
<script
	src="bootstrap/assets/js/plugins/perfect-scrollbar.jquery.min.js"></script>
<!--  Charts Plugin, full documentation here: https://gionkunz.github.io/chartist-js/ -->
<script src="bootstrap/assets/js/plugins/chartist.min.js"></script>
<!-- Library for adding dinamically elements -->
<script src="bootstrap/assets/js/plugins/arrive.min.js"
	type="text/javascript"></script>
<!--  Notifications Plugin, full documentation here: http://bootstrap-notify.remabledesigns.com/    -->
<script src="bootstrap/assets/js/plugins/bootstrap-notify.js"></script>
<!-- demo init -->
<script src="/bootstrap/assets/js/plugins/demo.js"></script>

</html>
