<%@page import="java.awt.print.Printable"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="poly.util.CmmUtil"%>
<%@page import="poly.util.TextUtil"%>
<%@page import="org.jsoup.select.Elements"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
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
	String session_user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
	String session_user_id = CmmUtil.nvl((String) session.getAttribute("session_user_id"));
	String session_user_name = CmmUtil.nvl((String) session.getAttribute("session_user_name"));
	String course_name = CmmUtil.nvl((String) request.getAttribute("course_name"));
	String cpi_name = CmmUtil.nvl((String) request.getAttribute("cpi_name"));
	
	String url = "http://openapi.seoul.go.kr:8088/";
	String servicekey = "4141687278636b7337324b4a44694c/";
	String allurl = url + servicekey + "xml/" + "SeoulGilWalkCourse/1/1/" + course_name + "/" + cpi_name;
	
	Document text = Jsoup.connect(allurl).get();
	
	Elements item = text.select("row");
	Elements totalCount = text.select("list_total_count");
	
	Elements COURSE_CATEGORY = text.select("COURSE_CATEGORY");
	Elements COURSE_CATEGORY_NM = text.select("COURSE_CATEGORY_NM");
	Elements AREA_GU = text.select("AREA_GU");
	Elements LEAD_TIME = text.select("LEAD_TIME");
	Elements DISTANCE = text.select("DISTANCE");
	Elements COURSE_LEVEL = text.select("COURSE_LEVEL");
	Elements RELATE_SUBWAY = text.select("RELATE_SUBWAY");
	Elements TRAFFIC_INFO = text.select("TRAFFIC_INFO");
	Elements CONTENT = text.select("CONTENT");
	Elements COURSE_NAME = text.select("COURSE_NAME");
	Elements DETAIL_COURSE = text.select("DETAIL_COURSE");
	Elements CPI_IDX = text.select("CPI_IDX");
	Elements CPI_NAME = text.select("CPI_NAME");
	Elements CPI_CONTENT = text.select("CPI_CONTENT");
	Elements PDF_FILE_PATH = text.select("PDF_FILE_PATH");
	
	String PATH = PDF_FILE_PATH.text().toString(); // Element형 subString하기위한 String형 변수 선언

%>

<script>

	window.onload = function() {
		
		var list = document.getElementById("list");
		<%if(!session_user_id.equals("admin")){%>
		var nav1 = document.getElementById("nav1");
		var nav2 = document.getElementById("nav2");
		var nav3 = document.getElementById("nav3");
		nav1.onclick = function() {
			nav2.style.display = "";
			nav3.style.display = "";
		};
	<%}%>
		list.onclick = function() {
			location.href = "/apiMain.do";
		};
		
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

.sam hr{
    margin-top: 0;
    margin-bottom: 0;
}

.sam{
display: block;
  width: 100%;
  padding: 0.4375rem 0;
  font-size: 1rem;
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
					<div align="center">
						<div class="col-md-10" style="text-align: left;">
							<div class="card">
								<div class="card-header card-header-success">
									<h2 class="card-title ">
										<b><%=COURSE_CATEGORY_NM.text() %></b>
									</h2>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-md-6">
											<div class="form-group">
												<label class="bmd-label-floating">포인트명칭</label>
												<div class="sam"><%=CPI_NAME.text() %><hr></div>
											</div>
										</div>
										<div class="col-md-6">
											<div class="form-group">
												<label class="bmd-label-floating">코스레벨</label>
												<div class="sam"><%=COURSE_LEVEL.text() %><hr></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-6">
											<div class="form-group">
												<label class="bmd-label-floating">소요시간</label>
												<div class="sam"><%=LEAD_TIME.text() %><hr></div>
											</div>
										</div>																				
										<div class="col-md-6">
											<div class="form-group">
												<label class="bmd-label-floating">거리</label>
												<div class="sam"><%=DISTANCE.text() %><hr></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-6">
											<div class="form-group">
												<label class="bmd-label-floating">자치구</label>
												<div class="sam"><%=AREA_GU.text() %><hr></div>
											</div>
										</div>
										<div class="col-md-6">
											<div class="form-group">
												<label class="bmd-label-floating">연계지하철</label>
												<div class="sam"><%=RELATE_SUBWAY.text() %><hr></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12" >
											<div class="form-group">
												<label class="bmd-label-floating">설명</label>
												<div class="sam"><%=CONTENT.text() %><hr></div>
											</div>
										</div>
									</div>
										<div class="row">
											<div class="col-md-12">
												<div class="form-group">
													<label class="bmd-label-floating">포인트 설명</label>
													<div class="sam"><%=CPI_CONTENT.text() %><hr></div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-12">
												<div class="form-group">
													<label class="bmd-label-floating">세부코스</label>
													<div class="sam"><%=DETAIL_COURSE.text()%><hr></div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-12">
												<div class="form-group">
													<label class="bmd-label-floating">교통편</label>
													<div class="sam"><%=TRAFFIC_INFO.text()%><hr></div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-md-12">
												<div class="form-group">
													<label class="bmd-label-floating">PDF파일</label>
													<div class="sam">
														<%if(PATH.substring(PATH.length()-4, PATH.length()).equals(".zip")) { %>
															<img src="bootstrap/assets/img/pdf.png">
															<a href="<%=PDF_FILE_PATH.text()%>"><%=PDF_FILE_PATH.text()%></a>
														<%}else { %>
															PDF파일이 없습니다.
														<%} %>
														<hr>
													</div>	
												</div>
											</div>
										</div>
										<button type="button" id="list" class="btn btn-success pull-right">리스트로 이동</button>
										<form method="get" action="/favorite_Insert.do">
										<input hidden="hidden" type="text" name="course_name" value="<%=COURSE_NAME.text()%>">
										<input hidden="hidden" type="text" name="cpi_name" value="<%=CPI_NAME.text()%>">
										<input hidden="hidden" type="text" name="cpi_idx" value="<%=CPI_IDX.text()%>">
										<input hidden="hidden" type="text" name="area_gu" value="<%=AREA_GU.text()%>">
										<button class="btn btn-success pull-right">즐겨찾기 추가</button>
										</form>
									<div class="clearfix"></div>
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

</html>
