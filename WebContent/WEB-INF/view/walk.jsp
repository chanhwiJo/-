<%@page import="poly.util.CmmUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
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
<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" />
<link rel="stylesheet" href="bootstrap/assets/css/material-dashboard.css?v=2.0.0">

<!-- Documentation extras -->
<!-- CSS Just for demo purpose, don't include it in your project -->
<link href="bootstrap/assets/assets-for-demo/demo.css" rel="stylesheet" />
<!-- iframe removal -->
<%
	String session_user_id = CmmUtil.nvl((String) session.getAttribute("session_user_id"));
	String session_user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
	String session_team_name = CmmUtil.nvl((String) session.getAttribute("session_team_no"));
	String session_auth = CmmUtil.nvl((String) session.getAttribute("session_auth"));
	String session_user_name = CmmUtil.nvl((String)session.getAttribute("session_user_name"));
%>
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

/* timeChart */
#timeChart {
	width: 500px;
	height: 500px;
}

</style>

<!-- Stop Watch -->
<script type="text/javascript" src="bootstrap/assets/js/stopwatch.js"></script>
<!-- stopWatch style -->
<style>
	*{
		margin: 0px;
		padding: 0px;
	}
	body{
		height: 100vh;
		flex-direction: row;
		align-items: center;
		justify-content: center;
 	}
 	.box{
		width: 200px;
		height: 200px;
	}
	.timerBox{
		width: 200px;
	}
	.timerBox .time{
		font-size: 30pt;
		color: #009000;
		text-align: center;
		font-family: sans-serif;
	}
	.btnBox{
		margin: 20px auto;
		text-align: center;
	}
	.btnBox .fa{
		margin: 0px 5px;
		font-size: 30pt;
		color: #41e873;
		cursor: pointer;
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
					<li class="nav-item"><a class="nav-link" href="/main.do">
							<i class="material-icons">home</i>
							<p>메인</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/apiMain.do"> <i class="material-icons">follow_the_signs</i>
							<p>정보</p>
					</a></li>
					<li class="nav-item "><a class="nav-link" id="nav1"> <i
							class="material-icons">person</i>
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
								class="nav-link"
								href="/userDetail.do?user_no=<%=session_user_no%>"> <i
									class="material-icons">assignment_ind</i>
									<p>상세</p>
							</a></li>
						</ul></li>
					<li class="nav-item "><a class="nav-link"
						href="/boardL.do"> <i class="material-icons">list</i>
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
					<li class="nav-item active"><a class="nav-link"
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
			
			<!-- 산책시간 차트 -->
			
			<script src="bootstrap/assets/js/Chart.js"></script>
			<script>
			
				window.onload = function () {
					<%if(!session_user_id.equals("admin")){%>
					var nav1 = document.getElementById("nav1");
					var nav2 = document.getElementById("nav2");
					var nav3 = document.getElementById("nav3");
					nav1.onclick = function() {
						nav2.style.display = "";
						nav3.style.display = "";
					};
					<%}%>
				}
			
				// 산책시간 차트 준비
	           	$(document).ready(function(){
	           		timeChart();
	        	});
				
	           	// 산책시간 차트
	           	function timeChart(){
	           		
	                $.ajax({
	                	url:"getTimeData.do",
	                	method:"POST",
	                	success:function(data){
	                		var day = [];
	            			var time = [];
	                		$.each(data, function(key, value){
	                			console.log(value);
	                			if(value != null) {
	                				day.push(value.data)
	                				time.push(value.data1);
	                			}
	                			console.log("day : " + day); // 날짜
	                			console.log("time : " + time); // 산책시간
	                		});
	                		var chartdata = {
	                				labels:day,
	                				datasets:[{
	                					label : '산책시간',
	                					fill:true,
	                					backgroundColor : 'rgba(49, 181, 9, 0.8)',
	                					borderColor: 'rgba(49, 181, 9, 0.8)',
	                					data:time
	                				}]
	                		};
	                		var timeChart = document.getElementById('timeChart');
	                		timeChart = new Chart(timeChart, {
	                			type: "line",
	                			data: chartdata,
	                			options: {
	                				maintainAspectRatio : false,
	                				scales : {
	                					yAxes : [{
	                						ticks : {
	                							beginAtZero : true
	                						}
	                					}]
	                				}
	                			}
	                		});
	                		
	                		timeChart = new Chart(chartdata, timeChart);
	                		
	                		var content = "";
	                		var sum = 0;
	                		for(var i=0; i<time.length; i++){
	                			sum += parseInt(time[i]);
	                		}
	                		console.log("sum : " + sum);
	                		sum = "합계 시간 : " + sum;
	                		$('#sum').html(sum);
	                		
	                		var avg = 0;
	                		for(var i=0; i<time.length; i++){
	                			avg += parseInt(time[i]);
	                		}
	                		avg = avg / time.length;
	                		console.log("avg : " + avg);
	                		var today_walk = 0;
	                		var praise = 0;
	                		for(var i=0; i<time.length; i++){
	                			if(i < time.length) {
	                				praise = parseInt(time[i])-avg;
	                				today_walk = parseInt(time[i]);
	                				if(parseInt(time[i]) > avg){
	                					content = "평균보다 <span class='text-success'>" + praise + "</span> 만큼 산책을 더하셨군요! "+"<span class='text-success'>" +" 잘하셨습니다.</span>";
	                				}else{
	                					content = "";
	                				}
	                			}
	                		}
	                		console.log("praise : " + praise);
	                		$('#praiseText').html(content);
	                		console.log("today_walk : " + today_walk);
	                		avg = "평균 시간 : " + avg;
	                		$('#avg').html(avg);
	                		
	                		var max = 0;
	                		for(var i=0; i<time.length; i++){
	                			max = Math.max(parseInt(time[i]));
	                		}
	                		console.log("max : " + max);
	                		max = "최고 시간 : " + max;
	                		$('#max').html(max);
	                		
	                		var min = 0;
	                		for(var i=0; i<time.length; i++){
	                			min = Math.min(parseInt(time));
	                		}
	                		console.log("min : " + min);
	                		min = "최저 시간 : " + min;
	                		$('#min').html(min);
	                		
	                		// 현재 시간
	                		var curDate = new Date();
	                		var curTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + curDate.getDate() + " " + curDate.getHours() + ":" + curDate.getMinutes();
	                		console.log("currentTime : "+curTime)
	                		
	                		currentTime = "현재 시간 : " + curTime;
	                		$('#currentTime').html(currentTime);
	                		
	                		today = "오늘 산책 시간 : " + today_walk;
	                		$('#today').html(today);
	                		
	                	} // success
	                });
	           	}
	           	
            </script>
			
			<div class="content">
				<div class="container-fluid">
					
					<!-- 산책시간 차트 -->
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header card-header-success">
									<h2 class="card-title ">
										<b>산책시간 분석</b>
									</h2>
								</div>
							<div class="card card-chart">
									<div class="ct-chart">
										<canvas id="timeChart"></canvas>
									</div>
								<hr>
								<br>
								<div class="card-body">
									<div class="row">
										<div class="col-md-3">
											<div id="box" class="box">
												<div id="timerBox" class="timerBox">
													<br>
													<div id="time" value="00:00:00" class="time">00:00:00</div>
													<div class="btnBox">
														<i id="startbtn" class="fa fa-play" aria-hidden="true"></i>
														<i id="pausebtn" class="fa fa-pause" aria-hidden="true"></i>
														<i id="stopbtn" class="fa fa-stop" aria-hidden="true"></i>
													</div>
												</div>
											</div>
										</div>
										<div class="col-md-9">
											<div class="row">
												<div class="col-md-5" id="currentTime" style="font-size: 20px; font-weight: bold;"></div>
												<div class="col-md-4" id="today" style="font-size: 20px; font-weight: bold;"></div>
											</div>
											<br>
											<div class="row">
												<div class="col-md-5" id="sum" style="font-size: 20px; font-weight: bold;"></div>
												<div class="col-md-4" id="avg" style="font-size: 20px; font-weight: bold;"></div>
											</div>
											<br>
											<div class="row">
												<div class="col-md-5" id="max" style="font-size: 20px; font-weight: bold;"></div>
												<div class="col-md-4" id="min" style="font-size: 20px; font-weight: bold;"></div>
											</div>
											<br>
											<div class="row">
												<div class="col-md-9" id="praiseText" style="font-size: 20px; font-weight: bold;"></div>			
											</div>
											<br>
										</div>
									</div>
									<hr>
									<div class="card-footer">
										<form method="post" action="/calender.do">
											<input hidden="hidden" type="text" name="user_no" value="<%=session_user_no%>">
											<input hidden="hidden" type="text" name="user_id" value="<%=session_user_id%>">
                                    		<input hidden="hidden" type="text" name="user_name" value="<%=session_user_name%>">
                                    		<button class="btn btn-success pull-right">캘린더</button>
                                    	</form>
                                    	<form method="post" action="chat.do">
											<input hidden="hidden" type="text" name="chatId" value="<%=session_user_id%>">
                                    		<button class="btn btn-success pull-right">채팅</button>
                                    	</form>
                                	</div>
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
