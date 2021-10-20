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
<body>
<%for(int i=0; i<40; i++){ %>
<table border="1">
	<tr>
		<td id="dt_txt<%=i%>" colspan="6"></td>
	</tr>
	<tr>
		<td>온도</td>
		<td id="temp<%=i%>"></td>
		<td>최저 온도</td>
		<td id="temp_min<%=i%>"></td>
		<td>최고 온도</td>
		<td id="temp_max<%=i%>"></td>
	</tr>
	<tr>
		<td>습도</td>
		<td id="humidity<%=i%>"></td>
		<td>아이콘</td>
		<td><img id="icon<%=i%>"></td>
		<td>운량</td>
		<td id="clouds<%=i%>"></td>
	</tr>
	<tr>
		<td>풍속</td>
		<td id="speed<%=i%>"></td>
		<td>풍향</td>
		<td id="deg<%=i%>"></td>
		<td>돌풍</td>
		<td id="gust<%=i%>"></td>
	</tr>
</table>
<%} %>
</body>
</html>