<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<!-- Favicons -->
    <link rel="apple-touch-icon" href="bootstrap/assets/img/icon.png">
    <link rel="icon" href="bootstrap/assets/img/icon.png">
    
<title>산 책 조 아</title>

<!-- Bootstrap Core CSS -->
<link
	href="bootstrap/mainBootstrap/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Custom Fonts -->
<link
	href="bootstrap/mainBootstrap/vendor/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
<link
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700,300italic,400italic,700italic"
	rel="stylesheet" type="text/css">
<link
	href="bootstrap/mainBootstrap/vendor/simple-line-icons/css/simple-line-icons.css"
	rel="stylesheet">

<!-- Custom CSS -->
<link href="bootstrap/mainBootstrap/css/stylish-portfolio1.css"
	rel="stylesheet">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
var idCheck = false; //아이디체크확인
var keyCheck = false; //인증체크
window.onload = function(){
	var re_btn = document.getElementById("re_btn"); //가입취소 버튼
	var post_btn = document.getElementById("post_btn"); //주소찾기 버튼
	var email_btn = document.getElementById("email_btn"); //이메일 전송 버튼
	var key_btn = document.getElementById("key_btn"); //인증확인 버튼
	var id = document.getElementById("user_id");
	var email = document.getElementById("email");
	
	re_btn.onclick = function() {
		location.href = "/home.do";
	};
	
	id.onkeydown = function(event){ //아이디 한글 no
		event = event || window.event;

        var keyID = (event.which) ? event.which : event.keyCode;

        //48~57: 숫자키 / 96~105: 숫자 키패드
        if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105)
              || (keyID == 8) || (keyID == 46) || (keyID == 110) || (keyID == 190) //8->backspace, 46->delete, 110,190->.
              || (keyID >= 65 && keyID <= 90) && //65~90 영소문자, 
              (keyID != 16) && (keyID != 20) && (keyID != 21)) { //16->shift, 20->capslock, 21->한/영
              
           return true;
        } else {
           return false;
        }
	};
	
	email.onkeydown = function(event){ //email 한글 no
		event = event || window.event;

        var keyID = (event.which) ? event.which : event.keyCode;

        //48~57: 숫자키 / 96~105: 숫자 키패드
        if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105)
              || (keyID == 8) || (keyID == 46) || (keyID == 110) || (keyID == 190) //8->backspace, 46->delete, 110,190->.
              || (keyID >= 65 && keyID <= 90) && //65~90 영소문자, 
              (keyID != 16) && (keyID != 20) && (keyID != 21)) { //16->shift, 20->capslock, 21->한/영
              
           return true;
        } else {
           return false;
        }
	};
	
	id.oninput = function(){ //아이디 중복 확인
		var id = document.getElementById("user_id");
		var user_id = $('#user_id').val();
		
		$.ajax({
			url : '/idCheck.do',
			method : 'post',
			data : {
				'user_id' : user_id
			},
			success : function(data) {
				if (!$('#user_id').val()) {
						$('#idc').html('<div style="color:#eb8d8d; ">아이디를 입력해주세요.</div>');
						$('#user_id').focus();
						idCheck = false;
				}else if ($.trim(data) != 0) {
						$('#idc').html('<div style="color:#eb8d8d; ">이미 존재하는 아이디 입니다.</div>');
						$('#user_id').focus();
						idCheck = false;
				}else{
					$('#idc').html('<div style="color:#8a99e6; ">사용 가능한 아이디입니다.</div>');
					idCheck = true;
				}
			}
		})
	};
	
	email.oninput = function() { //이메일 중복 확인
		var email = document.getElementById("email");
		var email = $('#email').val();
		
		$.ajax({
			url : '/emailCheck.do',
			method : 'post',
			data : {
				'email' : email
			},
			success : function(data) {
				if (!$('#email').val()) {
					$('#emailc').html('<div style="color:#eb8d8d; ">이메일을 입력해주세요.</div>');
					$('#email').focus();
					emailCheck = false;
			}else if ($.trim(data) != 0) {
					$('#emailc').html('<div style="color:#eb8d8d; ">이미 가입된 이메일 입니다.</div>');
					$('#email').focus();
					emailCheck = false;
			}else{
				$('#emailc').html('<div style="color:#8a99e6; ">사용 가능한 이메일입니다.</div>');
				emailCheck = true;
			}
			}
		})
	};
	
	post_btn.onclick = function(){ //주소찾기
		new daum.Postcode({
			oncomplete : function(data) {
				var fullAddr = '';
				var extraAddr = '';
				if (data.userSelectedType === 'R') {
				fullAddr = data.roadAddress;

            	} else {
               		fullAddr = data.jibunAddress;
            	}
            	if (data.userSelectedType === 'R') {
               		if (data.bname !== '') {
                  		extraAddr += data.bname;
              		}
               		if (data.buildingName !== '') {
                  		extraAddr += (extraAddr !== '' ? ', '
                        	+ data.buildingName
                        	: data.buildingName);
               		}
               		fullAddr += (extraAddr !== '' ? ' ('
                     	+ extraAddr
                     	+ ')'
                     	: '');
            	}
            	document.getElementById('post').value = data.zonecode;
	            document.getElementById('addr1').value = fullAddr;
            	document.getElementById('addr2').focus();
         	}
      	}).open();
	};
}

function doSubmit(f) { //전송시 유효성 체크
	if (idCheck == false) {
		$('#idc').html('<p style="color:#eb8d8d;">다른 아이디를 입력해주세요.</p>');
		f.user_id.focus();
		return false;
	}else{
		$('#idc').html('');
	}
	if (f.user_name.value == "") {
		$('#namec').html('<p style="color:#eb8d8d;">이름을 입력해주세요.</p>');
		f.user_name.focus();
		return false;
	}else{
		$('#namec').html('');
	}
	if(f.password.value == "") {
		$('#pwc').html('<p style="color:#eb8d8d;">비밀번호를 입력해주세요.</p>');
		f.password.focus();
		return false;
	}else{
		$('#pwc').html('');
	}
	if(f.password.value != f.pw_check.value) {
		$('#pwc').html('<p style="color:#eb8d8d;">비밀번호가 일치하지않습니다. 다시 확인해주세요.</p>');
		f.password.focus();
		return false;
	}else{
		$('#pwc').html('');
	}
	if (f.email.value == "") {
		$('#emailc').html('<p style="color:#eb8d8d;">이메일을 입력해주세요.</p>');
		f.email.focus();
		return false;
	}else {
		$('#emailc').html('');
	}
	if (emailCheck == false) {
		$('#emailc').html('<p style="color:#eb8d8d;">다른 이메일를 입력해주세요.</p>');
		f.email.focus();
		return false;
	}else {
		$('#emailc').html('');
	}
	if(f.day.value == "") {
		$('#dayc').html('<p style="color:#eb8d8d;">생년월일을 입력해주세요.</p>');
		f.day.focus();
		return false;
	}else{
		$('#dayc').html('');
	}
	if(f.post.value == "") {
		$('#postc').html('<p style="color:#eb8d8d;">주소를 입력해주세요.</p>');
		f.post.focus();
		return false;
	}else {
		$('#postc').html('');
	}
}
function pwCheck(){
	var inputed = f.password.value;
	 $('#wrongPw').hide();
     $('#failPw').hide();
     $('#successPw').hide();
	if(inputed.length < 6){
		$('#wrongPw').show();
		$('#successPw').hide();
		return false;
	}else{
		$('#wrongPw').hide();
		$('#successPw').show();
		return true;
	}
	
}

function pw2Check(){
	var inputed = f.password.value;
	var inputed2 = f.pw_check.value;
     $('#wrongPw2').hide();
     $('#failPw2').hide();
     $('#successPw2').hide();
	if(inputed != inputed2){
		$('#wrongPw2').show();
		$('#successPw2').hide();
		return false;
	}else {
		$('#wrongPw2').hide();
		$('#successPw2').show();
		return true;
	}
}
</script>
</head>
<body id="page-top">
	
    <!-- Navigation -->
    <a class="menu-toggle rounded" href="#">
      <i class="fa fa-bars"></i>
    </a>
    <nav id="sidebar-wrapper">
      <ul class="sidebar-nav">
        <li class="sidebar-brand">
          <a class="js-scroll-trigger" href="/main.do">산 책 조 아</a>
        </li>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="home.do">홈</a>
        </li>
        <li class="sidebar-nav-item">
          <a class="js-scroll-trigger" href="login.do">로그인</a>
        </li>
      </ul>
    </nav>

	<!-- join -->
	<section class="content-section bg-light" id="join">
		<div class="container" style="width: 40%">
			<div class="content-section-heading text-center">
				<h3 class="text-secondary mb-0">Join</h3>
				<h2 class="mb-5">회원가입</h2>
			</div>
			<div class="card card-login mx-auto mt-5">
				<div class="card-header" align="center">Join</div>
				<div class="card-body">
					<form method="post" name="f" onsubmit="return doSubmit(this);" action="join_proc.do">
						<div class="row">
							<div class="col-md-6">
								<div class="form-group">
									<label for="InputId">아이디</label>
									<div class="input-group">
										<input type="text" class="form-control" id="user_id" name="user_id" placeholder="아이디를 입력해주세요." oninput="id.oninput()">
									</div>
									<div id="idc"></div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
								<label for="InputName">이름</label>
									<input type="text" class="form-control" id="user_name" name="user_name"
										placeholder="이름을 입력해 주세요.">
									<div id="namec"></div>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label for="InputPassword1">비밀번호</label>
							<input type="password" class="form-control" id="user_pw1" name="password"
								maxlength="12" placeholder="6~12자리의 비밀번호를 입력해주세요." oninput="pwCheck()">
						<div id="pw"></div>
						<div id="wrongPw" style="display: none; color: #eb8d8d; ">6~16자의 비밀번호를 입력해주세요.</div>
						<div id="successPw" style="display: none; color: #8a99e6; ">사용가능한 비밀번호입니다.</div>
						</div>
						<div class="form-group">
							<label for="InputPassword2">비밀번호 확인</label>
							<input type="password" class="form-control" id="user_pw2" name="pw_check"
								maxlength="12" placeholder="비밀번호 확인을 위해 다시 한번 입력 해 주세요." oninput="pw2Check()">
								<div id="wrongPw2" style="display: none; color: #eb8d8d; ">비밀번호가 일치하지 않습니다.</div>
						  		<div id="successPw2" style="display: none; color: #8a99e6; ">비밀번호가 일치합니다.</div>
							<div id="pwcheck"></div>
						</div>
						<div class="form-group">
							<label for="InputEmail">이메일</label>
							<div class="input-group">
								<input type="email" class="form-control" id="email" name="email"
									placeholder="이메일을 입력해주세요." oninput="email.input()">
							</div>
							<div id="emailc"></div>
						</div>
						<div class="form-group">
							<label for="InputDay">생년월일</label>
							<input type="date" class="form-control" id="day" name="day">
							<div id="dayc"></div>
						</div>
						<div class="form-group">
							<label for="InputGender">성별</label>
							<br>
							<input type="radio" name="gender" value="1" checked="checked"> 남자
							&emsp;&emsp;&emsp;
							<input type="radio" name="gender" value="2"> 여자
							<div id="genderc"></div>
						</div>
						<div class="form-group">
							<label for="InputPhone">전화번호</label>
							<br>
							<input type="text" class="form-control" name="phone" placeholder="전화번호를 입력해주세요.">
							<div id="phonec"></div>
						</div>
						<div class="form-group">
							<label for="InputPost">우편번호</label>
							<div class="input-group">
								<input type="text" class="form-control" id="post" name="post" readonly>
								<span class="input-group-btn">
									<button type="button" class="btn btn-success" id="post_btn">
										주소 찾기
									</button>
								</span>
							</div>
							<div id="postc"></div>
						</div>
						<div class="form-group">
							<label for="Inputaddr">주소</label>
							<input type="text" class="form-control" id="addr1" name="addr1" readonly>
							<input type="text" class="form-control" id="addr2" name="addr2"
								placeholder="상세주소">
							<div id="addrc"></div>
						</div>
						<br>
						<div class="form-group text-center">
							<button type="submit" class="btn btn-success">
								회원가입<i class="fa fa-check spaceLeft"></i>
							</button>
							<button type="reset" class="btn btn-submit" id="re_btn">
								가입취소<i class="fa fa-times spaceLeft"></i>
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>

	<!-- Footer -->
	<footer class="footer text-center">
		<div class="container">
			<p class="text-muted small mb-0">문의 : 관리자 (cksgnl4285@naver.com)</p>
			<br>
			<p class="text-muted small mb-0">Copyright &copy; Your Website 2021</p>
		</div>
	</footer>

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded js-scroll-trigger" href="#page-top">
		<i class="fa fa-angle-up"></i>
	</a>

	<!-- Bootstrap core JavaScript -->
	<script src="bootstrap/mainBootstrap/vendor/jquery/jquery.min.js"></script>
	<script src="bootstrap/mainBootstrap/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Plugin JavaScript -->
	<script src="bootstrap/mainBootstrap/vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for this template -->
	<script src="bootstrap/mainBootstrap/js/stylish-portfolio.min.js"></script>

</body>

</html>

