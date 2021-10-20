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

/* 워드 카운트 */
#chartdiv {
	width: 100%;
	height: 500px;
}
</style>

</head>
<style type="text/css">

.wrap-loading{ /*화면 전체를 어둡게 합니다.*/

    position: fixed;

    left:0;

    right:0;

    top:0;

    bottom:0;

    background: rgba(0,0,0,0.2); /*not in ie */

    filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */

    

}

    .wrap-loading div{ /*로딩 이미지*/

        position: fixed;

        top:50%;

        left:50%;

        margin-left: -21px;

        margin-top: -21px;

    }

    .display-none{ /*감추기*/

        display:none;

    }

        
</style>
<div class="wrap-loading display-none">
	<div><img src="bootstrap/assets/img/loading.gif"></div>
</div>
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
					<li class="nav-item active"><a class="nav-link"
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
			<script src="jquery.min.js"></script>
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
			
	           	$(document).ready(function(){
	           		
	           		genderChart();
		           	teamChart();
		           	ageChart();
		           	addrChart();
		           	regChart();
		           	boardChart();
	           		
	        	});
	           	
	           	
	        
	           	function genderChart(){
	           		
	                $.ajax({
	                	url:"genderData.do",
	                	method:"POST",
	                	success:function(data){
	                		var num1 = [];
	            			var num2 = [];
	                		$.each(data, function(key, value){
	                			console.log(value);
	                			if(value != null) {
	                				num1.push(value.gender)
	                				num2.push(value.data);
	                			}
	                			console.log(num1); // 성별
	                			console.log(num2); // 수
	                		});
	                		var chartdata = {
	                				labels:num1,
	                				datasets:[{
	                					label: "성별",
	                					backgroundColor: [
	                						'rgba(54, 162, 235, 0.6)',
	          	          					'rgba(255,99,132,0.6)'
	                                    ],
	                                    data:num2
	                				}]
	                		};
	                		var ctx = document.getElementById("gender"); // canvas id > gender
	                		gender = new Chart(ctx, {
	                			type: 'bar',
	                			data: chartdata,
		                		options: {
		        					tooltips: {
		        						mode: 'index',
		        						intersect: false
		        					},
		        					responsive: true,
		                            scales: {
		                                yAxes: [{
		                                    ticks: {
		                                        beginAtZero:true
		                                    }
		                                }]
		                            }
		                        }
	                		});
	                		var content = "";
	                		var win = "";
	                		var loser = "";
	                		var vs = 0;
	                		
	                		if(parseInt(num2[0]) > parseInt(num2[1])){
	                			vs = parseInt(num2[0])-parseInt(num2[1]);
	                			win = num1[0];
	                			loser = num1[1];
	                			
	                			content = win+" > "+loser+", &nbsp; <span class='text-success'>"+win+" "+vs+"명 <i class='fa fa-long-arrow-up'></i></span>";
	                		}else if(parseInt(num2[0]) == parseInt(num2[1])){
	                			content = "남자와 여자의 비율은 <span class='text-success'>50%</span>로 동일";
	                		}else{
	                			vs = parseInt(num2[1])-parseInt(num2[0]);
	                			win = num1[1];
	                			loser = num1[0];
	                			
	                			content = win+" > "+loser+", &nbsp; <span class='text-success'>"+win+" "+vs+"명 <i class='fa fa-long-arrow-up'></i></span>";
	                		}
	                		
	                		$('#gtext').html(content);
	                	},
	                	error: function(data){
	                		console.log(data);
	                	}
	                });
	           	};
	           	
	           	function teamChart(){
	           		
	                $.ajax({
	                	url:"teamData.do",
	                	method:"POST",
	                	success:function(data){
	                		var num1 = ["가입", "미가입"];
	            			var num2 = [];
	                		$.each(data, function(key, value){
	                			console.log(value);
	                			if(value != null) {
	                				num2.push(value.data)
	                				num2.push(value.data1);
	                			}
	                			console.log(num1);
	                			console.log(num2);
	                		});
	                		var chartdata = {
	                				labels:num1,
	                				datasets:[{
	                					label:'동호회 가입여부',
	                					backgroundColor: [
	                						'rgba(153, 102, 204, 0.6)',
	          				                'rgba(204, 051, 204, 0.6)'
	                                    ],
	                                    data:num2
	                				}]
	                		};
	                		var tctx = document.getElementById("team");
	                		team = new Chart(tctx, {
	                			type: 'bar',
	                			data: chartdata,
		                		options: {
		        					tooltips: {
		        						mode: 'index',
		        						intersect: false
		        					},
		        					responsive: true,
		                            scales: {
		                                yAxes: [{
		                                    ticks: {
		                                        beginAtZero:true
		                                    }
		                                }]
		                            }
		                        }
	                		});
	                		
	                		var content = "";
	                		var win = "";
	                		var loser = "";
	                		var vs = 0;
	                		
	                		if(parseInt(num2[0]) > parseInt(num2[1])){
	                			vs = parseInt(num2[0])-parseInt(num2[1]);
	                			win = num1[0];
	                			loser = num1[1];
	                			content = win+" > "+loser+", &nbsp; <span class='text-success'>"+win+" "+vs+"명 <i class='fa fa-long-arrow-up'></i></span>";
	                		}else if(parseInt(num2[0]) == parseInt(num2[1])){
	                			content = "가입수와 미가입수의 비율은 <span class='text-success'>50%</span>로 동일";
	                		}else{
	                			vs = parseInt(num2[1])-parseInt(num2[0]);
	                			win = num1[1];
	                			loser = num1[0];
	                			content = win+" > "+loser+", &nbsp; <span class='text-success'>"+win+" "+vs+"명 <i class='fa fa-long-arrow-up'></i></span>";
	                		}
	                		
	                		$('#ttext').html(content);
	                		
	                	},
	                	error: function(data){
	                		console.log(data);
	                	}
	                });
	           	};	           	
	           	
	           	function ageChart(){
	           		
	           		$.ajax({
	                	url:"ageData.do",
	                	method:"POST",
	                	success:function(data){
	                		var num1 = [];
	            			var num2 = [];
	            			var num = ['10대 미만', '10대', '20대', '30대', '40대', '50대', '60대 이상'];
	                		$.each(data, function(key, value){
	                			console.log(value);
	                			if(value != null) {
	                				num1.push(value.data)
	                				num2.push(value.data1);
	                			}
	                			console.log(num1);
	                			console.log(num2);
	                		});
			                var config = {
			                	type: 'pie',
			                	data: {
			                		datasets: [{
			                			data: num2,
			                        	backgroundColor: [
			                        		'rgba(255, 051, 051, 0.8)', // 10대 미만
			                        		'rgba(051, 102, 255, 0.8)', // 10대
			            					'rgba(153, 255, 102, 0.8)', // 20대
			            					'rgba(255, 255, 153, 0.8)', // 30대
			            					'rgba(255, 153, 255, 0.8)', // 40대
			            					'rgba(153, 255, 255, 0.8)', // 50대
			            					'rgba(255, 153, 051, 0.8)' // 60대 이상
			                        	],
			                		}],
			                		labels: num
			                	},
			                	options: {
			                		responsive: true,
			                		legend: {
				    					position: 'right',
				    				}
			                	}
			                };
		                    var agechart = document.getElementById('age').getContext('2d');
		                    age = new Chart(agechart, config);
		                    
		                    var content = ""; // html
			                var max = parseInt(num2[0]);
			                var month = ""; // 대
			                var hap = 0; // 합계
			                var p = 0; // %
			                
			                for(var i = 0; i < num2.length; i++){
			                	hap += parseInt(num2[i]);
			                }
			                for(var i = 0; i < num2.length; i++){
			                	if(parseInt(num2[i]) > max) {
			                		max = parseInt(num2[i]);
			                		month = num[i];
			                	}else if(parseInt(num2[i]) == max){
			                		if(i == 0){
			                			month = num[i];
			                		}else{
			                			month += ", "+num[i];
			                		}
			                	}
			                }
			                p = parseInt(max / hap * 100);
			                if(p <= 10) {
			               		content = "<span class='text-success'>"+month+"</span>가 <span class='text-success'>"+p+"%</span>로 가장 수가 많은 연령대임";
			                	$('#agetext').html(content);
			                } else {
			                	content = "<span class='text-success'>"+month+"</span>이 <span class='text-success'>"+p+"%</span>로 가장 수가 많은 연령대임";
			                	$('#agetext').html(content);
			                }
		               },
		               error: function(data){
		           		console.log(data);
		               }
		           	});
	           	};
	           	
	           	function addrChart(){
	           		
	           		$.ajax({
		            	url:"addrData.do",
		                method:"POST",
		                success:function(data){
		                	var num1 = [];
		            		var num2 = [];
		                	$.each(data, function(key, value){
		                		console.log(value);
		                		if(value != null) {
		                			num1.push(value.data)
		                			num2.push(value.data1);
		                		}
		                		console.log(num1); //지역
		                		console.log(num2); //인원수
		                	});
				            var config = {
				                data: {
				                	datasets: [{
				                		data: num2,
				                   		backgroundColor: [
				                   			'rgba(255, 0, 0, 0.5)',
				                       		'rgba(0, 0, 255, 0.5)',
				                       		'rgba(0, 255, 0, 0.5)',
				                       		'rgba(255, 255, 0, 0.5)',
				                       		'rgba(0, 255, 255, 0.5)',
				                       		'rgba(255, 0, 255, 0.5)'
				                		],
				                		label : 'My dataset'
				             		}],
				                	labels: num1
				                },
				                options: {
				    				responsive: true,
				    				legend: {
				    					position: 'right'
				    				},
				    				scale: {
				    					ticks: {
				    						beginAtZero: true
				    					},
				    					reverse: false
				    				},
				    				animation: {
				    					animateRotate: false,
				    					animateScale: true
				    				}
				    			}
				    		};
			                var addrchart = document.getElementById('addr');
			                addr = new Chart.PolarArea(addrchart, config);
			                
			                var content = "";
			                var max = parseInt(num2[0]);
			                var month = "";
			                var hap = 0;
			                var p = 0;
			                
			                for(var i = 0; i < num2.length; i++){
			                	hap += parseInt(num2[i]);
			                }
			                for(var i = 0; i < num2.length; i++){
			                	if(parseInt(num2[i]) > max) {
			                		max = parseInt(num2[i]);
			                		month = num1[i];
			                	}else if(parseInt(num2[i]) == max){
			                		if(i == 0){
			                			month = num1[i];
			                		}else{
			                			month += ", "+num1[i];
			                		}
			                	}
			                }
			                p = parseInt(max / hap * 100);
			                content = "<span class='text-success'>"+month+"</span>이(가) <span class='text-success'>"+p+"%</span>로 회원이 많이 분포되어있음";
			                $('#addrtext').html(content);
			                
			    		},
		               	error: function(data){
		           		console.log(data);
		               }
		           	});
	           	};
	           	
	           	function regChart(){
	           		
	           		$.ajax({
		            	url:"regData.do",
		                method:"POST",
		                success:function(data){
		            		var num2 = [];
		                	$.each(data, function(key, value){
		                		console.log(value);
		                		if(value != null) {
		                			num2.push(value.data1);
		                		}
		                		console.log(num2);
		                	});
			            var MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
			    		var configs = {
			    			type: 'line',
			    			data: {
			    				labels: MONTHS,
			    				datasets: [{
			    					label: '가입자 수',
			    					fill: false,
			    					backgroundColor: 'rgba(000, 102, 153, 0.8)',
			    					borderColor: 'rgba(000, 102, 153, 0.8)',
			    					data: num2
			    				}]
			    			},
			    			options : {
								maintainAspectRatio : false, // default value. false일 경우 포함된 div의 크기에 맞춰서 그려짐.
								scales : {
									yAxes : [ {
										ticks : {
											beginAtZero : true
										}
									} ]
								}
							}
			    		};
		                var regchart = document.getElementById('reg').getContext('2d');
		                reg = new Chart(regchart, configs);
		                
		                var content = "";
		                var max = parseInt(num2[0]);
		                var month = "";
		                var hap = 0;
		                var p = 0;
		                
		                for(var i = 0; i < num2.length; i++){
		                	hap += parseInt(num2[i]);
		                }
		                for(var i = 0; i < num2.length; i++){
		                	if(parseInt(num2[i]) > max) {
		                		max = parseInt(num2[i]);
		                		month = parseInt(i+1);
		                	}else if(parseInt(num2[i]) == max){
		                		if(i == 0) {
		                			month = parseInt(i+1);
		                		}else{
		                			month += ", "+parseInt(i+1);
		                		}
		                	}
		                }
		                p = parseInt(max / hap * 100);
		                content = "<span class='text-success'>"+month+"월</span>이 <span class='text-success'>"+p+"%</span>로 가입률이 높음";
		                $('#jtext').html(content);
		           	},
	               	error: function(data){
	           		console.log(data);
	               	}
               });
	         };
	           	
            </script>
            <!-- Resources -->
			<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
			<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
			<script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
			<script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
			<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
			
			<!-- Chart code -->
			<script>
			am4core.ready(function() {

			//산책로 api 데이터 가져오기
			var allurl = "http://openapi.seoul.go.kr:8088/4141687278636b7337324b4a44694c/json/SeoulGilWalkCourse/1/1000/";
			console.log(allurl);
			$.ajax({
				type : "GET",
				url : allurl,
				dataType : "json",
				success : function(res) {
				var arr = [];
		
				// Themes begin
				am4core.useTheme(am4themes_animated);
				// Themes end

				var chart = am4core.create("chartdiv", am4plugins_wordCloud.WordCloud);
				var series = chart.series.push(new am4plugins_wordCloud.WordCloudSeries());

				series.labels.template.tooltipText = "{word}: {value}";
				series.accuracy = 4;
				series.step = 15;
				series.rotationThreshold = 0.7;
				series.maxCount = 200;
				series.minWordLength = 2;
				series.labels.template.margin(4, 4, 4, 4);
				series.maxFontSize = am4core.percent(30);

				series.text += '"';
			
				for(var i = 0; i < 1000; i++){
					arr[i] = res.SeoulGilWalkCourse.row[i].COURSE_NAME;
					console.log(i + "번째 arr : " + arr[i].replace(/\s/gi,""));
					series.text += arr[i].replace(/\s/gi,"");
					series.text += " ";
					series.text = series.text.replaceAll("undefined", "")
				}
				series.text += '"';
				console.log(series.text)
			
				series.colors = new am4core.ColorSet();
				series.colors.passOptions = {}; // makes it loop
			
				//series.labelsContainer.rotation = 45;
				series.angles = [ 0, -90 ];
				series.fontWeight = "700"
			
				},
				beforeSend:function(){
					// 이미지 보여주기
					$('.wrap-loading').removeClass('display-none');
				},
				complete:function(){
					// 이미지 감추기
					$('.wrap-loading').addClass('display-none');
				},
				timeout:10000
			});
		}); // end am4core.ready()
</script>
			
			<div class="content">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-6">
							<div class="card card-chart">
									<div class="ct-chart">
										<canvas id="gender"></canvas>
									</div>
								<div class="card-body">
									<h4 class="card-title">성별 분석</h4>
									<p class="card-category" id="gtext"></p>
								</div>
								<div class="card-footer">
									<div class="stats">
										회원 남녀 비율 확인
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="card card-chart">
									<div class="ct-chart">
										<canvas id="team"></canvas>
									</div>
								<div class="card-body">
									<h4 class="card-title">동호회 가입여부 분석</h4>
									<p class="card-category" id="ttext"></p>
								</div>
								<div class="card-footer">
									<div class="stats">
										동호회 가입 비율 확인
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6">
							<div class="card card-chart">
									<div class="ct-chart">
										<canvas id="age"></canvas>
									</div>
								<div class="card-body">
									<h4 class="card-title">나이 분석</h4>
									<p class="card-category" id="agetext"></p>
								</div>
								<div class="card-footer">
									<div class="stats">
										회원 나이 비율 확인
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="card card-chart">
									<div class="ct-chart">
										<canvas id="addr"></canvas>
									</div>
								<div class="card-body">
									<h4 class="card-title">지역 분석</h4>
									<p class="card-category" id="addrtext"></p>
								</div>
								<div class="card-footer">
									<div class="stats">
										회원 거주지 비율 확인
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="card card-chart">
									<div class="ct-chart">
										<canvas id="reg"></canvas>
									</div>
								<div class="card-body">
									<h4 class="card-title">월별 회원 가입 비율 분석</h4>
									<p class="card-category" id="jtext"></p>
								</div>
								<div class="card-footer">
									<div class="stats">
										달마다 가입된 가입자수 확인
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="card card-chart">
									<div class="ct-chart">
										<div class="stats" style="width: 100%; text-align: center;">
											<br>
											<b style="font-size: 20px; font-weight: bold;">워드 카운트</b>
										</div>
										<div id="chartdiv"></div>
									</div>
								<div class="card-body">
									<h4 class="card-title">워드 카운트 분석</h4>
								</div>
								<div class="card-footer">
									<div class="stats">
										산책로 단어 수 확인
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
