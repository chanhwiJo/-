<%@page import="poly.dto.FavoriteDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="poly.dto.BoardDTO"%>
<%@page import="poly.dto.ManageDTO"%>
<%@page import="poly.dto.UserDTO"%>
<%@page import="poly.util.CmmUtil"%>
<%@page import="poly.dto.TxtDTO" %>
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

	String session_user_no = CmmUtil.nvl((String)session.getAttribute("session_user_no")); 
	String session_user_name = CmmUtil.nvl((String)session.getAttribute("session_user_name"));
	
%>
<%
	List<FavoriteDTO> fList = (List<FavoriteDTO>)request.getAttribute("fList");
	if(fList == null){
		fList = new ArrayList();
	}
%>
<script>
	window.onload = function() {
		var nav1 = document.getElementById("nav1");
		var nav2 = document.getElementById("nav2");
		var nav3 = document.getElementById("nav3");
		nav1.onclick = function() {
			nav2.style.display = "";
			nav3.style.display = "";
		}
	}
</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> <!-- 대기정보 api를 사용하기 위한 jqeury -->
<script src="/jquery.min.js"></script>
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
.page-linkm{
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
.page-linkm:not([href]):not([tabindex]){
	color: #999999
}
.page-linkt{
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
.page-linkt:not([href]):not([tabindex]){
	color: #999999
}
</style>
</head>

<body id="page-top">
	<div class="wrapper">
		<div class="sidebar" data-color="green" data-background-color="white"
			data-image="/bootstrap/assets/img/sidebar_Trail.png">
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
                					<h2 class="card-title">
										<b>산책로 즐겨찾기</b>
									</h2>
                				</div>
                				<div class="card-body">
                					<div class="row text-success">
                						<div class="col-md-2"><strong>코스번호</strong></div>
										<div class="col-md-3"><strong>코스명</strong></div>
										<div class="col-md-3"><strong>포인트 명칭</strong></div>
										<div class="col-md-2"><strong>자치구</strong></div>
										<div class="col-md-2"></div>
                					</div>
                					<hr>
                					<div class="row">
                						<%for(FavoriteDTO fDTO : fList){ %>
                						<div class="col-md-2 " align="left"><%=CmmUtil.nvl(fDTO.getCpi_idx()) %></div>
                						<div class="col-md-3 " align="left"><%=CmmUtil.nvl(fDTO.getCourse_name()) %></div>
                						<div class="col-md-3 " align="left"><%=CmmUtil.nvl(fDTO.getCpi_name()) %></div>
                						<div class="col-md-2 " align="left"><%=CmmUtil.nvl(fDTO.getArea_gu()) %></div>
                						<div class="col-md-1 " align="left">
                							<form action="/api.do" method="get">
                								<input hidden="hidden" type="text" name="course_name" value="<%=fDTO.getCourse_name()%>">
                								<input hidden="hidden" type="text" name="cpi_name" value="<%=fDTO.getCpi_name()%>">
                								<button type="submit" style="border: white; background: white;"><img src="bootstrap/assets/img/glass.png"></button>
                							</form>
                						</div>
                						<div class="col-md-1 " align="left">
                							<form action="/favorite_Delete.do" method="get">
                								<input hidden="hidden" type="text" name="course_name" value="<%=fDTO.getCourse_name()%>">
                								<input hidden="hidden" type="text" name="cpi_name" value="<%=fDTO.getCpi_name()%>">
                								<button type="submit" style="border: white; background: white;"><img src="bootstrap/assets/img/drop.png"></button>
                							</form>
                						</div>
                						<hr style="width: 100%;"/>
                						<%} %>
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
<script src="bootstrap/assets/js/plugins/perfect-scrollbar.jquery.min.js"></script>
<!--  Charts Plugin, full documentation here: https://gionkunz.github.io/chartist-js/ -->
<script src="bootstrap/assets/js/plugins/chartist.min.js"></script>
<!-- Library for adding dinamically elements -->
<script src="bootstrap/assets/js/plugins/arrive.min.js" type="text/javascript"></script>
<!--  Notifications Plugin, full documentation here: http://bootstrap-notify.remabledesigns.com/    -->
<script src="bootstrap/assets/js/plugins/bootstrap-notify.js"></script>
<!-- demo init -->
<script src="/bootstrap/assets/js/plugins/demo.js"></script>

</html>
