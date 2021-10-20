<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="/jquery.min.js"></script>

<!-- Styles -->
<style>
#chartdiv {
	width: 100%;
	height: 600px;
}
</style>

<style type="text/css" >

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
<!-- Resources -->
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
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

			var chart = am4core.create("chartdiv",
					am4plugins_wordCloud.WordCloud);
			var series = chart.series
					.push(new am4plugins_wordCloud.WordCloudSeries());

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

<body>
	<div id="chartdiv"></div>

</body>
</html>