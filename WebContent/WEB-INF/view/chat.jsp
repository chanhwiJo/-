<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
//모든 페이지에 필수로 있어야하는 것들
String id = (String) session.getAttribute("session_user_id");
%>
<html lang="en">
<head>
<script type="text/javascript">
var id = "<%=id%>";
console.log("id : " + id);
</script>
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
<link rel="stylesheet" href="../css/chat.css">
</head>
<body>
    
    <!-- chat -->
	<section class="content-section bg-light" id="id_search">
		<div class="container" style="width: 30%">
			<div class="content-section-heading text-center">
				<h3 class="mb-0">Chat</h3>
				<h2 class="mb-5">Chat</h2>
			</div>
			<div class="card card-login mx-auto mt-5">
				<div class="card-header" align="center" style="color: black;">Chat</div>
				<div class="card-body">
					<div class="form-group">
					<!-- 채팅 박스 -->
					<div id="chat" class="floating-chat">
						<br>
						<div align="center">Chatting</div>
						<br>
						<div class="chat">
							<div class="header">
							<span class="title"> Live Chat </span>
							<button>
								<i class="fa fa-times" aria-hidden="true"></i>
							</button>
							</div>
						<ul id="messages" class="messages">
						</ul>
							<div class="footer">
								<div class="text-box" id="text-box" contenteditable="true" disabled="true"></div>
								<button id="sendMessage">send</button>
							</div>
						</div>
					</div>
						<br>
							<form action="/walk.do">
								<button class="btn btn-success pull-right">채팅종료</button>
							</form>
						<br>
					</div>
				</div>
			</div>
		</div>
	</section>
    
<script  src="/js/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/7f70eb1ead.js" crossorigin="anonymous"></script>
<!-- 웹소켓 채팅 -->
<script>
	var element = $('.floating-chat');
	var myStorage = localStorage;
	var ws;
	var messages = $('.messages');
	
	var tema_logo = "";
	var member_id = "<%=id%>";
	console.log("member_id : " + member_id);
	setTimeout(function() {
		element.addClass('enter');
	}, 1000);
	element.click(openSocket);
	function openSocket() {
		var messages = element.find('.messages');
		var textInput = element.find('.text-box');
		element.find('>i').hide();
		element.addClass('expand');
		element.find('.chat').addClass('enter');
		var strLength = textInput.val().length * 2;
		textInput.keydown(onMetaAndEnter).prop("disabled", false).focus();
		element.off('click', openSocket);
		element.find('.header button').click(closeSocket);
		element.find('#sendMessage').click(send);
		messages.scrollTop(messages.prop("scrollHeight"));
		if (ws !== undefined && ws.readyState !== WebSocket.CLOSED) {
			writeResponse("WebSocket is already opened.");
			return;
		}
		// 웹소켓 객체 만드는 코드
		ws = new WebSocket("ws://13.125.108.211:8080/echo.do");/* localhost:9005 *//* 13.125.108.211 */
		ws.onopen = function(event) {
			if (event.data === undefined)
				return;
			writeResponse(event.data);
		};
		ws.onmessage = function(event) {
			writeResponse(event.data);
		};
		ws.onclose = function(event) {
			writeResponse("Chat Closed");
		}
	}
	function send() {
		var userInput = $('.text-box');
		var newMessage = userInput.html().replace(/\<div\>|\<br.*?\>/ig, '\n')
				.replace(/\<\/div\>/g, '').trim().replace(/\n/g, '<br>');
		if (newMessage.replaceAll("&nbsp;", "").replaceAll("<br>", "").trim() == "") {
			return;
		}
		var text = member_id + "<br>" + newMessage;
		console.log(text)
		ws.send(text);
		text = "";
		var messagesContainer = $('.messages');
		// clean out old message
		userInput.html('');
		// focus on input
		userInput.focus();
		messagesContainer.finish().animate({
			scrollTop : messagesContainer.prop("scrollHeight")
		}, 250);
	}
	function closeSocket() {
		element.find('.chat').removeClass('enter').hide();
		element.find('>i').show();
		element.removeClass('expand');
		element.find('.header button').off('click', closeSocket);
		element.find('#sendMessage').off('click', send);
		element.find('.text-box').off('keydown', onMetaAndEnter).prop(
				"disabled", true).blur();
		setTimeout(function() {
			element.find('.chat').removeClass('enter').show()
			element.click(openSocket);
		}, 500);
		ws.close();
	}
	function writeResponse(text) {
		var messagesContainer = $('.messages');
		
		var message = text.split("<br>")[1];
		var member = text.split("<br>")[0];
			
			
		//캐릭터 이미지 나 이외의 다른사람들
		if (member != member_id) {
			messagesContainer.append([ '<li class="self">','<img class="chat_logo" src="/img/me1.jpg">', member, '<br>', message, '</li>' ].join(''));
		} else {
			messagesContainer.append([ '<li class="other">','<img class="chat_logo" src="/img/other2.jpg">', member, '<br>', message, '</li>' ].join(''));
		}
		messagesContainer.finish().animate({
			scrollTop : messagesContainer.prop("scrollHeight")
		}, 250);
	}
	function onMetaAndEnter(event) {
		if ((event.metaKey || event.ctrlKey) && event.keyCode == 13) {
			send();
		}
	}
</script>
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