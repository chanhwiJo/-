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
	System.out.print(session_user_no);
	String session_user_name = CmmUtil.nvl((String)session.getAttribute("session_user_name"));
	
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
<script type="text/javascript">
	$(window).on("load", function() {

		// 미래 날씨 정보 api 실행
		weatherFuture();
	});
	
	// 미래 날씨 정보 api
	function weatherFuture() {
		var weatherFutureApiURL = "https://api.openweathermap.org/data/2.5/forecast?q=seoul&id=524901&appid=ddee8cc2c5200bcd83e14e7967de3af3";
		$.ajax({
			url : weatherFutureApiURL,
			dataType : "json",
			type : "GET",
			success : function(res) {
				
				console.log(res)
				for(var i = 0; i < 40; i++){			
				
				console.log("dt_txt : " + res["list"][i]["dt_txt"]);
				console.log("temp : " + Math.ceil(res.list[i].main.temp - 273.15) + "℃");
				console.log("temp_min : " + Math.ceil(res.list[i].main.temp_min - 273.15) + "℃");
				console.log("temp_max : " + Math.ceil(res.list[i].main.temp_max - 273.15) + "℃");
				console.log("humidity : " + res.list[i].main.humidity + "%");
				
				console.log("weather : " + res.list[i].weather[0].main);
				var icon = res.list[i].weather[0].icon;
				console.log("icon : " + "http://openweathermap.org/img/w/" + icon + ".png");
				
				console.log("clouds : " + res.list[i].clouds.all);
				
				console.log("speed : " + res.list[i].wind.speed);
				console.log("deg : " + res.list[i].wind.deg);
				console.log("gust : " + res.list[i].wind.gust);
				
				$('#temp' + i).html(Math.ceil(res.list[i].main.temp - 273.15) + "℃");
				$('#temp_min' + i).html(Math.ceil(res.list[i].main.temp_min - 273.15) + "℃");
				$('#temp_max' + i).html(Math.ceil(res.list[i].main.temp_max - 273.15) + "℃");
				$('#humidity' + i).html(res.list[i].main.humidity + "%");
				$('#weather' + i).html(res.list[i].weather[0].main);
				$('#icon' + i).attr("src", "http://openweathermap.org/img/w/" + res.list[i].weather[0].icon + ".png");
				$('#clouds' + i).html(res.list[i].clouds.all + "%");
				$('#speed' + i).html(res.list[i].wind.speed + "㎧");
				$('#deg' + i).html(res.list[i].wind.deg + "°");
				$('#gust' + i).html(res.list[i].wind.gust + "㎧");
				$('#dt_txt' + i).html(res["list"][i]["dt_txt"]);
				
				}
				
				
			}
		})
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
					<li class="nav-item active "><a class="nav-link"
						href="/main.do"> <i
							class="material-icons">home</i>
							<p>메인</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
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
										<b>날씨 리스트</b>
									</h2>
                				</div>
                				<br>
                				<hr width="100%">
                				<div id="divTable">
                					<%for(int i=0; i<40; i++){ %>
                					<div class="row">
                						<div class="col-md-2" style="text-align: center;"><strong>날짜</strong></div>
                						<div class="col-md-10" id="dt_txt<%=i%>"></div>              						
                					</div>
                					<hr width="100%">
                					<div class="row">
                						<div class="col-md-2" style="text-align: center;"><strong></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>날씨</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>온도</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>최저온도</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>최고온도</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>습도</strong></div>
                					</div>
                					<div class="row">
                						<div class="col-md-2" style="text-align: center;"><strong><img id="icon<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="weather<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="temp<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="temp_min<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="temp_max<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="humidity<%=i%>"></strong></div>
                					</div>
                					<div class="row">
                						<div class="col-md-2" style="text-align: center;"><strong></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>운량</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>풍속</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>풍향</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong>돌풍</strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong></strong></div>
                					</div>
                					<div class="row">
                						<div class="col-md-2" style="text-align: center;"><strong></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="clouds<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="speed<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="deg<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong id="gust<%=i%>"></strong></div>
                						<div class="col-md-2" style="text-align: center;"><strong></strong></div>
                					</div>
                					<hr width="100%">
                					<%} %>
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
