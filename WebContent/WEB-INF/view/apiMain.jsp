<%@page import="java.awt.print.Printable"%>
<%@page import="javax.script.ScriptEngineManager"%>
<%@page import="javax.script.ScriptEngine"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="org.jsoup.select.Elements"%>
<%@page import="poly.util.TextUtil"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@page import="java.util.ArrayList"%>
<%@page import="poly.dto.BoardDTO"%>
<%@page import="java.util.List"%>
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
	String session_user_name = CmmUtil.nvl((String) session.getAttribute("session_user_name"));
	String check = CmmUtil.nvl((String) session.getAttribute("check"));
	
	String url = "http://openapi.seoul.go.kr:8088/";
	String servicekey = "4141687278636b7337324b4a44694c/";
	String pageNo = (String)request.getAttribute("no");
	int first = Integer.parseInt(pageNo);
	int last = first + 9;
	
	if(Integer.parseInt(pageNo) > 1){
		first = (Integer.parseInt(pageNo) - 1) * 10;
		last = first + 9;
	}
	
	String allurl = url + servicekey + "xml/" + "SeoulGilWalkCourse/" + first + "/" + last;
	Document text = Jsoup.connect(allurl).get(); // url의 전체 데이터
	Elements item = text.select("row"); // url의 row만 가져옴
	
	int s = 0;
	int count = 10;
	String[] cpi_idx = new String[10]; // 코스번호 넣을 배열
	String[] course_name = new String[10]; // 코스명 넣을 배열
	String[] cpi_name = new String[10]; // 포인트 명칭 넣을 배열
	String[] area_gu = new String[10]; // 자치구 넣을 배열
	
	if(pageNo.equals("146")) { // 마지막 페이지 일 경우 배열의 크기를 5로 지정
		cpi_idx = new String[5];
		course_name = new String[5];
		cpi_name = new String[5];
		area_gu = new String[5];
		count = 5;
	}	

	for (Element add : item) { // row값에 파싱한 데이터들을 Element형 변수들에 추가
		Elements CPI_IDX = add.getElementsByTag("CPI_IDX");
		Elements COURSE_NAME  = add.getElementsByTag("COURSE_NAME");
		Elements CPI_NAME = add.getElementsByTag("CPI_NAME");
		Elements AREA_GU = add.getElementsByTag("AREA_GU");
		
		cpi_idx[s] = CPI_IDX.get(0).text().trim();
		course_name[s] = COURSE_NAME .get(0).text().trim();
		cpi_name[s] = CPI_NAME.get(0).text().trim();
		area_gu[s] = AREA_GU.get(0).text().trim();
		
		s++;
		if (s > count) {
			break;
		}
	}
	
%>
<%
	// 페이징
	int pages = Integer.parseInt(pageNo);
	int countList = 10;
	int countPage = 10;
	int totalPage = 146;
	int startPage = ((pages -1) / 10) * 10 + 1; // 1, 11, 21, 31...
	int endPage = startPage + countPage - 1; // 10, 20, 30, 40...
	if (endPage > totalPage) {
		endPage = totalPage;
	}
%>
<script>
	window.onload = function() {
		<%if(!session_user_id.equals("admin")){%>
			var nav1 = document.getElementById("nav1");
			var nav2 = document.getElementById("nav2");
			var nav3 = document.getElementById("nav3");
			nav1.onclick = function() {
				nav2.style.display = "";
				nav3.style.display = "";
			};
		<%}%>
		
		var s = document.getElementById("search");
		s.onclick = function(){
			$('#search').val('');
		};
		
		var sbtn = document.getElementById("sbtn");
		sbtn.onclick = function() {
			console.log("검색 클릭");
			
			if(COURSE_NAME = ""){
				location.href="/apiMain.do";
			}else{
				var COURSE_NAME = $('#search').val();
				console.log("검색값 : " + COURSE_NAME);
				location.href="/apiSearch.do?COURSE_NAME=" + COURSE_NAME;
			}
		}
	}
	
	function doDetail(cpi_name, course_name){
		var CPI_NAME = cpi_name;
		var COURSE_NAME = course_name;
		location.href="/api.do?COURSE_NAME="+COURSE_NAME+"&CPI_NAME="+CPI_NAME;
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

#notice {
	font-size: 15px;
	color: red;
}
</style>
</head>
<body id="page-top">
	<div class="wrapper">
		<div class="sidebar" data-color="green" data-image="/bootstrap/assets/img/sidebar_Trail.png">
			<!--
        Tip 1: You can change the color of the sidebar using: data-color="purple | azure | green | orange | danger"

        Tip 2: you can also add an image using data-image tag
    -->
			<div class="logo">
				<a href="home.do" class="simple-text logo-normal"> 산 책 조 아 </a>
			</div>
			<div class="sidebar-wrapper">
				<ul class="nav">
					<li class="nav-item "><a class="nav-link"
						href="/main.do"> <i
							class="material-icons">home</i>
							<p>메인</p>
					</a></li>
					<li class="nav-item active "><a class="nav-link"
						href="/apiMain.do"> <i class="material-icons">follow_the_signs</i>
							<p>정보</p>
					</a></li>
					<li class="nav-item "><a class="nav-link" id="nav1">
							<i class="material-icons">person</i>
							<p>마이페이지</p>
					</a>
						<ul class="nav-item" id="nav2" style="display: none">
							<li class="nav-item" style="list-style-type: none"><a
								class="nav-link" href="/regList.do"> <i
									class="material-icons">assignment</i>
									<p>작성글</p>
							</a></li>
						</ul>
						<ul class="nav-item" id="nav3" style="display: none">
							<li class="nav-item" style="list-style-type: none"><a
								class="nav-link" href="/userDetail.do?user_no=<%=session_user_no%>"> <i
									class="material-icons">assignment_ind</i>
									<p>상세</p>
							</a></li>
						</ul></li>
					<li class="nav-item "><a class="nav-link"
						href="/boardL.do"> <i
							class="material-icons">list</i>
							<p>자유게시판</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/teamL.do"> <i
							class="material-icons">group</i>
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
										<b>산책로 리스트</b>
									</h2>
									<a href="/favorite.do" style="font-size: 12px; color: white;">즐 겨 찾 기</a>
								</div>
								<div class="card-body">
									<div align="right">
										<form class="navbar-form">
											<div class="input-group no-border" style="width: 30%">
												<input type="text" value="" class="form-control" id="search"
													name="search" placeholder="코스명  Search...">
												<button type="button"
													class="btn btn-white btn-round btn-just-icon" id="sbtn">
													<i class="material-icons">search</i>
													<div class="ripple-container"></div>
												</button>
											</div>
										</form>
									</div>
									<div id="divTable">
											<div class="row text-success">
												<div class="col-md-2"><strong>코스번호</strong></div>
												<div class="col-md-3"><strong>코스명</strong></div>
												<div class="col-md-3"><strong>포인트 명칭</strong></div>
												<div class="col-md-2"><strong>자치구</strong></div>
												<div class="col-md-2"></div>
												<hr width="100%">
											</div>
											<div class="row">
												<%
													for (int i = 0; i < course_name.length; i++) {
												%>
													<div class="col-md-2"><%=cpi_idx[i] %></div>
													<div class="col-md-3"><%=course_name[i] %></div>
													<div class="col-md-3"><%=cpi_name[i] %></div>
													<div class="col-md-2"><%=area_gu[i] %></div>
													<div class="col-md-2"><img onclick="doDetail('<%=cpi_name[i]%>','<%=course_name[i]%>');" src="bootstrap/assets/img/glass.png"></div>
													<hr width="100%">
												<% }%>
											</div>
									</div>
									<div id="paging">
										<nav aria-label="Page navigation example">
											<ul class="pagination justify-content-center">
												<%if(startPage != 1) {%>
												<li class="page-item">
													<a class="page-link" href="/apiMain.do?no=<%=((pages -11) / 10) * 10 + 1%>" aria-label="Previous">
														<span aria-hidden="true">&laquo;</span>
														<span class="sr-only">Previous</span>
													</a>
												</li>
												<%} %>
												<%for (int iCount = startPage; iCount <= endPage; iCount++) {
													if(iCount == pages) {%>
														<li class="page-item"><a class="page-link"><b>(<%=iCount%>)</b></a></li>
													<%}else{ %>
														<li class="page-item"><a class="page-link" href="/apiMain.do?no=<%=iCount%>"><%=iCount%></a></li>
													<%} }%>
												<%if(endPage != 146) {%>
												<li class="page-item">
													<a class="page-link" href="/apiMain.do?no=<%=((pages + 9) / 10) * 10 + 1%>" aria-label="Next">
														<span aria-hidden="true">&raquo;</span>
														<span class="sr-only">Next</span>
													</a>
												</li>
												<%} %>
											</ul>
										</nav>
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