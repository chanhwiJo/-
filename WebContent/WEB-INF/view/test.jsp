<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(window).on("load", function() {
		//페이지 로딩 완료 후 , 날씨 정보 api 실행
		weather();
		//페이지 로딩 완료 후 , 대기 정보 api 실행
		air();
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
				console.log("temp : " + Math.ceil(res.list[1].main.temp - 273.15) + "℃");
				console.log("temp_min : " + Math.ceil(res.list[1].main.temp_min - 273.15) + "℃");
				console.log("temp_max : " + Math.ceil(res.list[1].main.temp_max - 273.15) + "℃");
				console.log("humidity : " + res.list[1].main.humidity + "%");
				
				console.log("weather : " + res.list[1].weather[0].main);
				var icon = res.list[1].weather[0].icon;
				console.log("icon : " + "http://openweathermap.org/img/w/" + icon + ".png");
				
				console.log("clouds : " + res.list[1].clouds.all + "℃");
				
				console.log("speed : " + res.list[1].wind.speed);
				console.log("deg : " + res.list[1].wind.deg);
				console.log("gust : " + res.list[1].wind.gust);
				console.log("dt_txt : " + res["list"][1]["dt_txt"]);
					
			}
		})
	}
	
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
</script>


<body>
	온도 : <div id="temp"></div>
	습도 : <div id="humi"></div>
	날씨 : <div id="weather"></div>
	바람 : <div id="wind"></div>
	지역 : <div id="name"></div>
	이미지 : <img id="icon">
<hr>
	미세먼지 : <div id="PM10"></div>
	초미세먼지 : <div id="PM25"></div>
	오존 : <div id="O3"></div>
	이산화 질소 : <div id="NO2"></div>
	일산화 탄소 : <div id="CO"></div>
	이산화 황 : <div id="SO2"></div>
	대기 : <div id="IDEX_NM"></div>
</body>
</html>