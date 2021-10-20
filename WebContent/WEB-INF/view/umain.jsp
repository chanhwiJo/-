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
	String session_user_id = CmmUtil.nvl((String)session.getAttribute("session_user_id"));
	UserDTO u = (UserDTO) request.getAttribute("u");
	ManageDTO m = (ManageDTO) request.getAttribute("m");
	BoardDTO b = (BoardDTO) request.getAttribute("b");
	TxtDTO t = (TxtDTO) request.getAttribute("t");
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
<script type="text/javascript">
	$(window).on("load", function(){
		// 페이지 로딩 완료 후 , MongoDB 날씨 데이터 가져오기
		weather();
		// 페이지 로딩 완료 후 , MongoDB 대기 데이터 가져오기
		air();
		// 페이지 로딩 완료 후 , 산책로 정보 api 실행
		trail();
	});
	/*
	// 몽고 날씨 데이터 가져오기
	function weather() {
		
		// Ajax 호출
		$.ajax({
			url : "/weather.do",
			type : "post",
			dataType : "JSON",
			contentType : "application/json; charset=UTF-8",
			success : function(json) {
				for (var i=0; i < json.length; i++) {
					var main = json[i].main;
					console.log("날씨 : " + json[i].main);
					var temp = json[i].temp;
					console.log("온도 : " + json[i].temp);
					var humidity = json[i].humidity;
					console.log("습도 : " + json[i].humidity);
					var wind = json[i].wind;
					console.log("바람 : " + json[i].wind);
					var clouds = json[i].clouds;
					console.log("구름 : " + json[i].clouds);
					var description = json[i].description;
					console.log("날씨 상세 : " + json[i].description);
					var icon = json[i].icon;
					console.log("이미지 : " + json[i].icon);
				}
				$('#main').html(main);
				$('#temp').html(temp);
				$('#humidity').html(humidity);
				$('#wind').html(wind);
				$('#clouds').html(clouds);
				$('#description').html(description);
				$('#icon').attr("src", icon);
			}
		})
	}
	*/
	/*
	// 몽우 대기 데이터 가져오기
	function air() {
		
		// Ajax 호출
		$.ajax({
			url : "/air.do",
			type : "post",
			dataType : "JSON",
			contentType : "application/json; charset=UTF-8",
			success : function(json) {
				for (var i=0; i < json.length; i++) {
					var pm10 = json[i].pm10;
					console.log("미세먼지 : " + json[i].pm10);
					var pm25 = json[i].pm25;
					console.log("초미세먼지 : " + json[i].pm25);
					var o3 = json[i].o3;
					console.log("오존층 : " + json[i].o3);
					var no2 = json[i].no2;
					console.log("이산화 질소 : " + json[i].no2);
					var co = json[i].co;
					console.log("이산화 탄소 : " + json[i].co);
					var so2 = json[i].so2;
					console.log("이산화 황 : " + json[i].so2);
					var air = json[i].air;
					console.log("초미세먼지 : " + json[i].air);
				}
				$('#pm10').html(pm10);
				$('#pm25').html(pm25);
				$('#o3').html(o3);
				$('#no2').html(no2);
				$('#co').html(co);
				$('#so2').html(so2);
				$('#air').html(air);
			}
		})
	}
	*/
	
	//날씨정보 api
	function weather() {
		var weatherApiURL = "http://api.openweathermap.org/data/2.5/weather?q=seoul&appid=ddee8cc2c5200bcd83e14e7967de3af3";
		$.ajax({
			url : weatherApiURL,
			dataType : "json",
			type : "GET",
			success : function(resp) {
				console.log(resp);
				console.log("현재온도 : " + (Math.ceil(resp.main.temp - 273.15)));
				console.log("현재습도 : " + resp.main.humidity);
				console.log("날씨 : " + resp.weather[0].main);
				console.log("상세날씨설명 : " + resp.weather[0].description);
				console.log("날씨 이미지 : " + "http://openweathermap.org/img/w/" + resp.weather[0].icon + ".png");
				console.log("바람   : " + resp.wind.speed);
				console.log("나라   : " + resp.sys.country);
				console.log("도시이름  : " + resp.name);
				console.log("이미지  : " + resp.weather[0].icon);
				console.log("구름  : " + (resp.clouds.all) + "%");

				var temp = resp.main.temp - 273.15;
				$('#temp').html(Math.ceil(temp));
				$('#humi').html(resp.main.humidity);
				$('#weather').html(resp.weather[0].main);
				$('#wind').html(resp.wind.speed);
				$('#name').html(resp.name);
				$('#icon').html(resp.icon);

				var imgURL = "http://openweathermap.org/img/w/"
						+ resp.weather[0].icon + ".png";
				$('#icon').attr("src", imgURL);
			}
		})
	}
	
	//대기정보 api
	function air() {
		$.ajax({
		  type: "GET",
		  url: "http://openapi.seoul.go.kr:8088/6d4d776b466c656533356a4b4b5872/json/RealtimeCityAir/1/51",
		  data: {},
		  success: function(res){
				
				console.log("미세먼지 : " + res["RealtimeCityAir"]["row"][1]['PM10']);
				console.log("초미세먼지 : " + res["RealtimeCityAir"]["row"][1]['PM25']);
				console.log("오존 : " + res["RealtimeCityAir"]["row"][1]['O3']);	
				console.log("이산화 질소 : " + res["RealtimeCityAir"]["row"][1]['NO2']);
				console.log("일산화 탄소 : " + res["RealtimeCityAir"]["row"][1]['CO']);
				console.log("이산화 황 : " + res["RealtimeCityAir"]["row"][1]['SO2']);
				console.log("대기 : " + res["RealtimeCityAir"]["row"][1]['IDEX_NM']);
				
				$('#PM10').html(res["RealtimeCityAir"]["row"][1]['PM10']);
		  		$('#PM25').html(res["RealtimeCityAir"]["row"][1]['PM25']);
		  		$('#O3').html(res["RealtimeCityAir"]["row"][1]['O3']);
		  		$('#NO2').html(res["RealtimeCityAir"]["row"][1]['NO2']);
		  		$('#CO').html(res["RealtimeCityAir"]["row"][1]['CO']);
		  		$('#SO2').html(res["RealtimeCityAir"]["row"][1]['SO2']);
		  		$('#IDEX_NM').html(res["RealtimeCityAir"]["row"][1]['IDEX_NM']);
		  }
		});
		
	}
	
	// 산책로 정보 api
	function trail() {
		//산책로 api 데이터 가져오기
		$.ajax({
			type : "GET",
			url : "http://openapi.seoul.go.kr:8088/4141687278636b7337324b4a44694c/json/SeoulGilWalkCourse/1/1",
			data : {},
			success: function(res) {
				console.log(res);
				console.log("total_count : " + res["SeoulGilWalkCourse"]["list_total_count"]);
				$('#total_count').html(res["SeoulGilWalkCourse"]["list_total_count"]);
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
                		<div class="col-md-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-rose card-header-icon">
                                    <div class="card-icon">
                                        <i><img id="icon"></i>
                                    </div>
                                    <p class="card-category">Weather</p>
                                    <h3 class="card-title">
                                    <b>날씨 : </b><b id="weather"></b>&nbsp;
                                    <b>온도 : </b><b id="temp"></b>℃<br>
                                    <b>습도 : </b><b id="humi"></b>%&nbsp;
                                    <b>풍속 : </b><b id="wind"></b>㎧<br>
                                    </h3>
                                </div>
                                <div class="card-footer">
                                    <div class="stats">
                                    	날씨
                                    </div>
                                    <div><a style="color: green;" href="/futureWeather.do">날씨를 더 알고 싶다면?</a></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-info card-header-icon">
                                    <div class="card-icon">
                                        <i class="material-icons">air</i>
                                    </div>
                                    <p class="card-category">air</p>
                                    <h3 class="card-title">
                                    <b>대기 : </b><b id="IDEX_NM"></b>&nbsp;
                                    <b>오존 : </b><b id="O3"></b>o³<br>
                                    <b>미세먼지 : </b><b id="PM10"></b>㎛&nbsp;
                                    <b>초미세먼지 : </b><b id="PM25"></b>㎛<br>
                                   
                                    </h3>
                                </div>
                                <div class="card-footer">
                                    <div class="stats">
                                    	대기
                                    </div>
                                </div>
                            </div>
                        </div>
                	</div>
                    <div class="row">
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-warning card-header-icon">
                                    <div class="card-icon">
                                        <i class="material-icons">highlight</i>
                                    </div>
                                    <p class="card-category">Informations</p>
                                    <h3 class="card-title"><strong id="total_count"></strong></h3>
                                </div>
                                <div class="card-footer">
                                    <div class="stats">
                                    	공공데이터포털에서 제공하는 산책로 수
                                    </div>
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
                                    <h3 class="card-title"><strong><%=u.getData() %></strong></h3>
                                </div>
                                <div class="card-footer">
                                    <div class="stats">
                                    	회원가입한 회원 수
                                    </div>
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
                                    <h3 class="card-title"><strong><%=m.getNum() %></strong></h3>
                                </div>
                                <div class="card-footer">
                                    <div class="stats">
                                    	동호회 개수
                                    </div>
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
                                    <h3 class="card-title"><strong><%=b.getData() %></strong></h3>
                                </div>
                                <div class="card-footer">
                                    <div class="stats">
                                    	총 게시물 수
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                    	<div class="col-md-12">
                            <div class="card card-stats">
                            <br>
                            <strong>&emsp;산책의 좋은 점</strong>
                                <div class="card-footer">
                                    <div class="stats">
                                    	<b style="color: black; font-size: 15px;"><%=t.getTxt() %></b>
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
