<%@page import="java.util.Locale"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
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
	String session_user_id = CmmUtil.nvl((String) session.getAttribute("session_user_id"));
	String session_user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
	String session_team_name = CmmUtil.nvl((String) session.getAttribute("session_team_no"));
	String session_team_no = CmmUtil.nvl((String) session.getAttribute("session_team_no"));
	String session_user_name = CmmUtil.nvl((String) session.getAttribute("session_user_name"));
	String team_name = CmmUtil.nvl((String)request.getAttribute("team_name"));
%>
<!-- 나중에 팀이름으로 바꾸기 -->

<%
	Calendar calendar = new GregorianCalendar(Locale.KOREA);
	int y = calendar.get(Calendar.YEAR);

	UserDTO uDTO = (UserDTO) request.getAttribute("uDTO");
	if (uDTO == null)
		uDTO = new UserDTO();
	System.out.print("uDTO.Day : " + uDTO.getDay());
	String[] local = CmmUtil.nvl(uDTO.getAddr1()).split(" ");
	String[] test = CmmUtil.nvl(uDTO.getDay()).split("-");
	String n = test[0];
	int nas = Integer.parseInt(n);
	int na = y - nas + 1;
%>

<script>
	window.onload = function() {
		var list = document.getElementById("list");
		var exile = document.getElementById("exile");
		var del = document.getElementById("delete");
		var up = document.getElementById("update");
		var no = <%=session_user_no%>;
		var team = <%=session_team_no%>;
		var user_no = <%=uDTO.getUser_no()%>

		<%if(session_user_id.equals("admin")){%>
		list.onclick = function() {
			location.href = "/userList.do";
		};
		<%}else{%>
		var nav1 = document.getElementById("nav1");
		var nav2 = document.getElementById("nav2");
		var nav3 = document.getElementById("nav3");
		nav1.onclick = function() {
			nav2.style.display = "";
			nav3.style.display = "";
		};
		<%}%>
		
		<%if(session_user_id.equals("admin")){%>
		exile.onclick = function() {
			var y = confirm("회원을 추방하시겠습니까?");
			if ( y == true ){
				location.href = "/userDrop.do?user_no="+user_no;
			} else {
				return false;
			}
		}
		<%}%>
	};
	
	function dodrop(no) {
		var user_no = no;
		var y = confirm("탈퇴하시겠습니까?");
		if ( y == true ){
			location.href = "/userDrop.do?user_no="+user_no;
		} else {
			return false;
		}
	}
	function doupdate(no) {
		var user_no = no;
		location.href = "/userUpdate.do?user_no="+user_no;
	}
	function doteamdrop(team) {
		var team_no = team;
		var y = confirm("동호회 탈퇴를 하시겠습니까?");
		if (y == true){
			location.href = "/teamD.do?team_no="+team_no;
		} else {
			return false;
		}
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
</style>
</head>

<body id="page-top">
	<div class="wrapper">
		<div class="sidebar" data-color="green" data-background-color="white" data-image="/bootstrap/assets/img/sidebar_Trail.png">
			<!--
        Tip 1: You can change the color of the sidebar using: data-color="purple | azure | green | orange | danger"

        Tip 2: you can also add an image using data-image tag
    -->
			<div class="logo">
				<a href="home.do" class="simple-text logo-normal">산 책 조 아</a>
			</div>
			<div class="sidebar-wrapper">
				<%if(session_user_id.equals("admin")){%>
					<ul class="nav">
					<li class="nav-item"><a class="nav-link" href="/main.do">
							<i class="material-icons">home</i>
							<p>메인</p>
					</a></li>
					<li class="nav-item active"><a class="nav-link"
						href="/userList.do"> <i class="material-icons">person</i>
							<p>회원 관리</p>
					</a></li>
					<li class="nav-item"><a class="nav-link"
						href="/teamL.do"> <i
							class="material-icons">dvr</i>
							<p>동호회 관리</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/boardL.do"> <i
							class="material-icons">list</i>
							<p>자유게시판</p>
					</a></li>
				</ul>
				<%}else {%>
				<ul class="nav">
					<li class="nav-item"><a class="nav-link" href="/main.do">
							<i class="material-icons">home</i>
							<p>메인</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/apiMain.do"> <i class="material-icons">follow_the_signs</i>
							<p>정보</p>
					</a></li>
					<li class="nav-item"><a class="nav-link" id="nav1"> <i
							class="material-icons">person</i>
							<p>마이페이지</p>
					</a>
						<ul class="nav-item" id="nav2">
							<li class="nav-item " style="list-style-type: none"><a
								class="nav-link" href="/regList.do"> <i
									class="material-icons">assignment</i>
									<p>작성글</p>
							</a></li>
						</ul>
						<ul class="nav-item" id="nav3">
							<li class="nav-item active " style="list-style-type: none"><a
								class="nav-link"
								href="/userDetail.do?user_no=<%=session_user_no%>"> <i
									class="material-icons">assignment_ind</i>
									<p>상세</p>
							</a></li>
						</ul></li>
					<li class="nav-item"><a class="nav-link"
						href="/boardL.do"> <i class="material-icons">list</i>
							<p>자유게시판</p>
					</a></li>
					<li class="nav-item "><a class="nav-link" href="/teamL.do">
							<i class="material-icons">group</i>
							<p>동호회</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/chart.do"> <i
							class="material-icons">insert_chart_outlined</i>
							<p>분석</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/walk.do"> <i
							class="material-icons">directions_walk</i>
							<p>산책</p>
					</a></li>
				</ul>
				<%} %>
			</div>
		</div>
		<div class="main-panel">
			<!-- Navbar -->
            <jsp:include page="top.jsp" flush="true"/>
            <!-- End Navbar -->
			<div class="content">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header card-header-success">
									<h2 class="card-title ">
										<b>User Profile</b>
									</h2>
								</div>
								<div class="card-body">
									<form>
										<div class="row">
											<div class="col-md-6">
												<div class="form-group">
													<label class="bmd-label-floating">이름</label> <input
														type="text" class="form-control" 
														value="<%=CmmUtil.nvl(uDTO.getUser_name())%>" disabled>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-group">
													<label class="bmd-label-floating">ID</label> <input
														type="text" class="form-control" style="background-color: white"
														value="<%=CmmUtil.nvl(uDTO.getUser_id())%>" disabled>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-6">
												<div class="form-group">
													<label class="bmd-label-floating">이메일</label> <input
														type="text" class="form-control" style="background-color: white"
														value="<%=CmmUtil.nvl(uDTO.getEmail())%>" disabled>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-group">
													<label class="bmd-label-floating">동호회</label>
														<%if(uDTO.getAuth().equals("UA")) {%>
															<img src="bootstrap/assets/img/king.png">
															<a onclick="doteamdrop(<%=session_team_no %>);" style="color:background; font-weight:bolder; float: right;">동호회탈퇴</a>
															<input type="text" class="form-control" style="background-color: white"
															value="<%=team_name%>" disabled>
														<%}else if(uDTO.getAuth().equals("UD")){ %>
															<input type="text" class="form-control" style="background-color: white"
															value="가입 대기중" disabled>
														<%}else { %>
															<input type="text" class="form-control" style="background-color: white"
															value="<%=team_name%>" disabled>
														<%} %>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-6">
												<div class="form-group">
													<label class="bmd-label-floating">생년월일</label> <input
														type="text" class="form-control" style="background-color: white"
														value="<%=CmmUtil.nvl(uDTO.getDay())%>" disabled>
												</div>
											</div>
											<div class="col-md-6">
											<div class="form-group">
												<label class="bmd-label-floating">성별</label> <input
													type="text" class="form-control" style="background-color: white"
														value="<%=CmmUtil.nvl(uDTO.getGender())%>" disabled>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-6">
												<div class="form-group">
													<label class="bmd-label-floating">나이</label> <input
														type="text" class="form-control" style="background-color: white" value="<%=na%>" disabled>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-group">
													<label class="bmd-label-floating">지역</label> <input
														type="text" class="form-control" style="background-color: white" value="<%=local[0]%>"
														disabled>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-12">
												<div class="form-group">
													<label class="bmd-label-flating">전화번호</label>
													<input type="text" class="form-control" style="background-color: white" value="<%=CmmUtil.nvl(uDTO.getPhone())%>" disabled>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-12">
												<div class="form-group">
													<div class="form-group">
														<label class="bmd-label-floating">주소</label>
														<input type="text" class="form-control" style="background-color: white" disabled
															value="<%=CmmUtil.nvl(uDTO.getAddr1())%>&emsp;<%=CmmUtil.nvl(uDTO.getAddr2())%>">
													</div>
												</div>
											</div>
										</div>
										<%
											if (session_user_id.equals("admin")) {
										%>
										<button type="button" id="exile" class="btn btn-danger pull-right" onclick="exile(<%=uDTO.getUser_no() %>)">회원 추방</button>
										<button type="button" id="list" class="btn btn-success pull-right">리스트로 이동</button>
										<%
											} else {
										%>
										<button type="button" onclick="dodrop(<%=session_user_no %>);" class="btn btn-success pull-right"
											style="width: 100px">탈퇴</button>
										<button type="button" onclick="doupdate(<%=session_user_no %>);" class="btn btn-success pull-right"
											style="width: 100px">수정</button>
										<%
											}
										%>
										<div class="clearfix"></div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
            <footer class="footer ">
                <div class="container-fluid">
                    <nav class="pull-left">
						<p class="text-muted small mb-0">문의 : 관리자 (cksgnl4285@naver.com)</p>
						<br>
						<p class="text-muted small mb-0" align="left">정보출처 : 공공데이터포털 
							(<a id="m" href="http://www.data.go.kr" target="_blank">www.data.go.kr</a>)</p>
					</nav>
                    <div class="copyright pull-right">
                        &copy; 2021, made with love by chanhwi for a better web.
                    </div>
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
<script src="bootstrap/assets/js/plugins/demo.js"></script>
</body>
</html>