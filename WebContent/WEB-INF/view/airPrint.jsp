<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="jquery.min.js"></script>
<script type="text/javascript">
	$(window).on("load", function() {
		// 페이지 로딩 완료 후, 날씨 데이터 가져오기 함수 실행
		air();
	});
	
	// 대기 데이터 가져오기
	function air() {
		
		// Ajax 호출
		$.ajax({
			url : "/getAir.do",
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
				$('#air').html(air);
			}
		})
	}
</script>
</head>
<body>
<h1>대기 데이터 가져오기</h1>
<hr/>
대기 : <div id="air"></div>
</body>
</html>