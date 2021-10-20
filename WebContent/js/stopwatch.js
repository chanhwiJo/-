let time = 0;
let starFlag = true;
$(document).ready(function(){
  buttonEvt();
});

function init(){
  document.getElementById("time").innerHTML = "00:00:00";
}

function buttonEvt(){
  var hour = 0;
  var min = 0;
  var sec = 0;
  var timer;

  // start btn
  $("#startbtn").click(function(){

    if(starFlag){
      $(".fa").css("color","#FAED7D")
      this.style.color = "#4C4C4C";
      starFlag = false;

      if(time == 0){
        init();
      }

      timer = setInterval(function(){
        time++;

        min = Math.floor(time/60);
        hour = Math.floor(min/60);
        sec = time%60;
        min = min%60;

        var th = hour;
        var tm = min;
        var ts = sec;
        if(th<10){
        th = "0" + hour;
        }
        if(tm < 10){
        tm = "0" + min;
        }
        if(ts < 10){
        ts = "0" + sec;
        }

        document.getElementById("time").innerHTML = th + ":" + tm + ":" + ts;
      }, 1000);
    }
  });

  // pause btn
  $("#pausebtn").click(function(){
    if(time != 0){
      $(".fa").css("color","#FAED7D")
      this.style.color = "#4C4C4C";
      clearInterval(timer);
      starFlag = true;
    }
  });
  
  // stop btn
	$("#stopbtn").click(function(){
		const id = document.getElementById('time').textContent;
		console.log(id);
	
		    if(time != 0){
		      $(".fa").css("color","#FAED7D")
		      this.style.color = "#4C4C4C";
		      clearInterval(timer);
		      starFlag = true;
		      time = 0;
		      init();
		     } 
		     var myHeaders = new Headers();
		     myHeaders.append("Content-Type", "application/x-www-form-urlencoded");
		     
		     var urlencoded = new URLSearchParams();
		     urlencoded.append("id", id);
		     
		     var requestOptions = {
		     method : 'POST',
		     headers: myHeaders,
		     body:urlencoded,
		     redirect: 'follow'
		     };
		     
		     fetch("stopwatch2.do", requestOptions)
		     .then(response => response.text(		     ))
		     .then(result => 
		     {
		     	console.table(result)
		     	if(result == true){
		     		location.href = 'planner.do';
		     	}else{
		     	alert("데이터 저장에 실패하였습니다")
		     	}
		     }
		     )
		     .catch(error => console.log('error', error));
	
	 	});
  
  
  }