<%@page import="poly.util.CmmUtil"%>
<%@page import="poly.dto.UserDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
	String session_user_name = CmmUtil.nvl((String)session.getAttribute("session_user_name"));
	UserDTO cDTO = (UserDTO)request.getAttribute("cDTO");
	int count = Integer.parseInt(cDTO.getData());
	System.out.println("count : " + count);
	List<UserDTO> uList = (List<UserDTO>)request.getAttribute("uList");
	if(uList == null){
		uList = new ArrayList();
	}
%>
<script>
	window.onload = function() {
		
		var s = document.getElementById("search");
		s.onclick = function(){
			$('#search').val('');
		};
		
		var sbtn = document.getElementById("sbtn");
		sbtn.onclick = function() {
			var contents = "";
			var search = $('#search').val();
			var num = 1;
			
			if(search == "") {
				location.href="/userList.do";
			}else{
				$.ajax({
					url : "/userSearch.do",
					method : "post",
					data : {'search' : search},
					datatype : "json",
					success : function(data) {
						var contents = "";
						var content = "";
						var contentss = "";
						
						contents += "<div id='divTable'>";
						contents += "<div class='row text-success'>";
						contents += "<div class='col-md-2'><strong>번호</strong></div>";
						contents += "<div class='col-md-2'><strong>이름</strong></div>";
						contents += "<div class='col-md-2'><strong>ID</strong></div>";
						contents += "<div class='col-md-2'><strong>동호회</strong></div>";
						contents += "<div class='col-md-2'><strong>권한</strong></div>";
						contents += "</div></div>";
						contents += "<hr width='100%'>";
						
						$.each(data, function (key, value) {
							var team_no = "";
							if(value.team_no == null){
								team_no = "미가입";
							}else{
								team_no = value.team_no;
							}
							content += "<div class='row'>";
							content += "<div class='col-md-2'>"+value.user_no+"</div>";
							content += "<div class='col-md-2'>"+value.user_name+"</div>";
							content += "<div class='col-md-2'>"+value.user_id+"</div>";
							content += "<div class='col-md-2'>"+team_no+"</div>";
							content += "<div class='col-md-2'>"+value.auth+"</div>";
							content += "<div class='col-md-2'><img onclick='doDetail("+value.user_no+");'"+"src='bootstrap/assets/img/glass.png'>&emsp;";
							content += "<img onclick='doExile("+value.user_no+");'"+"src='bootstrap/assets/img/drop.png'></div></div>";
							content += "<hr width='100%'>";
						});
						
						contentss += "</div>";
						
						if(content == ""){
							content += '<div align="center" style="color:red;">"'+search+'" 에 해당하는 검색결과가 없습니다.</div>';
							$('#divTable').html(content);
						}else{
							$('#divTable').html(contents+content+contentss);
						}
					}
				});
				
				$.ajax({
					url : "/userSearchNum.do",
					method : "post",
					data : {'search' : search},
					datatype : "int",
					success : function(data) {
						console.log(data);
						var page = 1;
						var countPage = 10;
						var countList = 10;
						var totalCount = data;
						var totalPage =  parseInt(totalCount / countList);
						if(totalCount % countList > 0){
							totalPage++;
						}
						if(totalPage < page){
							page = totalPage;
						}
						
						var startPage = ((page - 1) / 10) * 10 + 1;
						var endPage = startPage + countPage - 1
						
						if(endPage > totalPage) {
							endPage = totalPage;
						}
						console.log(startPage);
						console.log(endPage);
						console.log(page);
						var content = "";
						content += "<div id='paging'>";
						content += "<nav aria-label='Page navigation example'>";
						content += "<ul class='pagination justify-content-center'>";
						if(startPage != 1) {
							content += "<li class='page-item'>";
							content += "<a class='page-links' id="+startPage-10+" value='"+search+"' aria-label='Previous'>";
							content += "<span aria-hidden='true'>&laquo;</span>";
							content += "<span class='sr-only'>Previous</span></a></li>";
						}
						for(var iCount = startPage; iCount <= endPage; iCount++){
							if(iCount == page) {
								content += "<li class='page-item'><a class='page-links'><b>("+iCount+")</b></a></li>";
							}else{
								content += "<li class='page-item'><a class='page-links' id='"+iCount+"' value='"+search+"'>"+iCount+"</a></li>";
							}
						}
						if(endPage != totalPage) {
							content += "<li class='page-item'>";
							content += "<a class='page-links' id="+startPage+10+" value='"+search+"' aria-label='Next'>";
							content += "<span aria-hidden='true'>&raquo;</span>";
							content += "<span class='sr-only'>Next</span></a></li>";
						}
						content += "</ul></nav></div>";
						if(totalCount != 0){
							$('#paging').html(content);
						}else{
							$('#paging').html('');
						}
					},
					error : function(error) {alert("num : "  + error)}
				});
				
			}
		};
		
		$(document).on("click", ".page-links", function() {
			var num = $(this).attr('id');
			if(num == $(this).attr('id') && num == null){ // 현재 페이지인 경우 클릭 에러 방지
				return false;
			}
			var search = $(this).attr('value');
			console.log("num : " + num);
			console.log("search : " + search);
			$.ajax({
				url : "/userSearchPaging.do",
				method : "post",
				data : {"search" : search, "num" : num},
				dataType : "json",
				success : function(data, st, xhr) {
					console.log(data);
					var contents = "";
					contents += "<div id='divTable'>";
					contents += "<div class='row text-success'>";
					contents += "<div class='col-md-2'><strong>번호</strong></div>";
					contents += "<div class='col-md-2'><strong>이름</strong></div>";
					contents += "<div class='col-md-2'><strong>ID</strong></div>";
					contents += "<div class='col-md-2'><strong>동호회</strong></div>";
					contents += "<div class='col-md-2'><strong>권한</strong></div>";
					contents += "<div class='col-md-2'></div>";
					contents += "</div>";
					contents += "<hr width='100%'>";
					
					$.each(data, function(key, value) {
						var team_no = "";
						if(value.team_no == null){
							team_no = "미가입";
						}else{
							team_no = value.team_no;
						}
						contents += "<div class='row'>";
						contents += "<div class='col-md-2'>"+value.user_no+"</div>";
						contents += "<div class='col-md-2'>"+value.user_name+"</div>";
						contents += "<div class='col-md-2'>"+value.user_id+"</div>";
						contents += "<div class='col-md-2'>"+team_no+"</div>";
						contents += "<div class='col-md-2'>"+value.auth+"</div>";
						contents += "<div class='col-md-2'><img onclick='doDetail("+value.user_no+");' src='bootstrap/assets/img/glass.png'>&emsp;";
						contents += "<img onclick='doExile("+value.user_no+");' src='bootstrap/assets/img/drop.png'>";
						contents += "</div></div>";
						contents += "<hr width='100%'>";
					});
					
					contents += "</div></div>";
					$('#divTable').html(contents);
					
					countPage = 10;
					countList = 10;
					page = num;
					if(totalPage < page){
						page = totalPage;
					}
					
					startPage =  parseInt(((page - 1) / 10)) * 10 + 1;
					endPage = startPage + countPage - 1;
					
					if(endPage > totalPage) {
						endPage = totalPage;
					}
					console.log(startPage);
					console.log(endPage);
					console.log(page);
					content = "";
					content += "<div id='paging'>";
					content += "<nav aria-label='Page navigation example'>";
					content += "<ul class='pagination justify-content-center'>";
					if(startPage != 1) {
						content += "<li class='page-item'>";
						content += "<a class='page-links' id="+startPage-10+" value='"+search+"' aria-label='Previous'>";
						content += "<span aria-hidden='true'>&laquo;</span>";
						content += "<span class='sr-only'>Previous</span></a></li>";
					}
					for(var iCount = startPage; iCount <= endPage; iCount++){
						if(iCount == page) {
							content += "<li class='page-item'><a class='page-links'><b>("+iCount+")</b></a></li>";
						}else{
							content += "<li class='page-item'><a class='page-links' id='"+iCount+"' value='"+search+"'>"+iCount+"</a></li>";
						}
					}
					if(endPage != totalPage) {
						content += "<li class='page-item'>";
						content += "<a class='page-links' id="+startPage+10+" value='"+search+"' aria-label='Next'>";
						content += "<span aria-hidden='true'>&raquo;</span>";
						content += "<span class='sr-only'>Next</span></a></li>";
					}
					content += "</ul></nav></div>";
					$('#paging').html(content);
				},
				error : function(xhr, st, error) {alert(error)}
			});
		});
		
		//첫화면페이징 시작
		var page = 1;
		var countPage = 10;
		var countList = 10;
		var totalCount = <%=count%>;
		var totalPage =  parseInt(totalCount / countList);
		
		if(totalCount % countList > 0){
			totalPage++;
		}
		if(totalPage < page){
			page = totalPage;
		}
		
		var startPage = ((page - 1) / 10) * 10 + 1;
		var endPage = startPage + countPage - 1;
		
		if(endPage > totalPage) {
			endPage = totalPage;
		}
		console.log(startPage);
		console.log(endPage);
		console.log(page);
		var content = "";
		content += "<div id='paging'>";
		content += "<nav aria-label='Page navigation example'>";
		content += "<ul class='pagination justify-content-center'>";
		if(startPage != 1) {
			content += "<li class='page-item'>";
			content += "<a class='page-link' id="+startPage-10+" aria-label='Previous'>";
			content += "<span aria-hidden='true'>&laquo;</span>";
			content += "<span class='sr-only'>Previous</span></a></li>";
		}
		for(var iCount = startPage; iCount <= endPage; iCount++){
			if(iCount == page) {
				content += "<li class='page-item'><a class='page-link'><b>("+iCount+")</b></a></li>";
			}else{
				content += "<li class='page-item'><a class='page-link' id='"+iCount+"'>"+iCount+"</a></li>";
			}
		}
		if(endPage != totalPage) {
			content += "<li class='page-item'>";
			content += "<a class='page-link' id="+startPage+10+" aria-label='Next'>";
			content += "<span aria-hidden='true'>&raquo;</span>";
			content += "<span class='sr-only'>Next</span></a></li>";
		}
		content += "</ul></nav></div>";
		$('#paging').html(content);
		//첫화면페이징 끝
		
		//본론페이징 시작
		$(document).on("click", ".page-link", function() {
			var num = $(this).attr('id');
			if(num == $(this).attr('id') && num == null){ // 현재 페이지인 경우 클릭 에러 방지
				return false;
			}
			console.log("num : " + num);
			$.ajax({
				url : "/userPaging.do",
				method : "post",
				data : {"num" : num},
				dataType : "json",
				success : function(data, st, xhr) {
					console.log(data);
					console.log(st);
					console.log(xhr);
					var contents = "";
					contents += "<div id='divTable'>";
					contents += "<div class='row text-success'>";
					contents += "<div class='col-md-2'><strong>번호</strong></div>";
					contents += "<div class='col-md-2'><strong>이름</strong></div>";
					contents += "<div class='col-md-2'><strong>ID</strong></div>";
					contents += "<div class='col-md-2'><strong>동호회</strong></div>";
					contents += "<div class='col-md-2'><strong>권한</strong></div>";
					contents += "</div>";
					contents += "<hr width='100%'>";
					
					$.each(data, function(key, value) {
						var team_no = "";
						if(value.team_no == null){
							team_no = "미가입";
						}else{
							team_no = value.team_no;
						}
						contents += "<div class='row'>";
						contents += "<div class='col-md-2'>"+value.user_no+"</div>";
						contents += "<div class='col-md-2'>"+value.user_name+"</div>";
						contents += "<div class='col-md-2'>"+value.user_id+"</div>";
						contents += "<div class='col-md-2'>"+team_no+"</div>";
						contents += "<div class='col-md-2'>"+value.auth+"</div>";
						contents += "<div class='col-md-2'><img onclick='doDetail("+value.user_no+");' src='bootstrap/assets/img/glass.png'>&emsp;";
						contents += "<img onclick='doExile("+value.user_no+");' src='bootstrap/assets/img/drop.png'>";
						contents += "</div></div>";
						contents += "<hr width='100%'>";
					});
					
					contents += "</div>";
					$('#divTable').html(contents);
					
					page = num;
					if(totalPage < page){
						page = totalPage;
					}
					
					startPage =  parseInt(((page - 1) / 10)) * 10 + 1;
					endPage = startPage + countPage - 1
					
					if(endPage > totalPage) {
						endPage = totalPage;
					}
					console.log(startPage);
					console.log(endPage);
					console.log(page);
					content = "";
					content += "<div id='paging'>";
					content += "<nav aria-label='Page navigation example'>";
					content += "<ul class='pagination justify-content-center'>";
					if(startPage != 1) {
						content += "<li class='page-item'>";
						content += "<a class='page-link' id="+startPage-10+" aria-label='Previous'>";
						content += "<span aria-hidden='true'>&laquo;</span>";
						content += "<span class='sr-only'>Previous</span></a></li>";
					}
					for(var iCount = startPage; iCount <= endPage; iCount++){
						if(iCount == page) {
							content += "<li class='page-item'><a class='page-link'><b>("+iCount+")</b></a></li>";
						}else{
							content += "<li class='page-item'><a class='page-link' id='"+iCount+"'>"+iCount+"</a></li>";
						}
					}
					if(endPage != totalPage) {
						content += "<li class='page-item'>";
						content += "<a class='page-link' id="+startPage+10+" aria-label='Next'>";
						content += "<span aria-hidden='true'>&raquo;</span>";
						content += "<span class='sr-only'>Next</span></a></li>";
					}
					content += "</ul></nav></div>";
					$('#paging').html(content);
				},
				error : function(xhr, st, error) {alert(error)}
			});
		});
		//본론페이징 끝
	}
	function doDetail(no){
		var user_no = no;
		location.href="/userDetail.do?user_no="+user_no;
	}
	function doExile(no){
		var user_no = no;
		var y = confirm("회원을 추방하시겠습니까?");
		if ( y == true){
			location.href="/userDrop.do?user_no="+user_no;
		}else {
			return false;	
		}
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
.page-links{
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
.page-links:not([href]):not([tabindex]){
	color: #999999
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
					<li class="nav-item active"><a class="nav-link"
						href="/userList.do"> <i class="material-icons">person</i>
							<p>회원 관리</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/teamL.do"> <i
							class="material-icons">dvr</i>
							<p>동호회 관리</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/boardL.do"> <i
							class="material-icons">list</i>
							<p>자유게시판</p>
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
						<div class="col-md-12">
							<div class="card">
								<div class="card-header card-header-success">
									<h2 class="card-title ">
										<b>User List</b>
									</h2>
								</div>
								<div class="card-body">
									<div align="right">
										<form class="navbar-form">
											<div class="input-group no-border" style="width: 30%">
												<input type="text" value="" class="form-control" id="search" name="search" placeholder="name or ID Search...">
												<button type="button" class="btn btn-white btn-round btn-just-icon" id="sbtn">
													<i class="material-icons">search</i>
													<div class="ripple-container"></div>
												</button>
											</div>
										</form>
									</div>
									<div id="divTable">
										<div class="row text-success">
											<div class="col-md-2"><strong>번호</strong></div>
											<div class="col-md-2"><strong>이름</strong></div>
											<div class="col-md-2"><strong>ID</strong></div>
											<div class="col-md-2"><strong>동호회</strong></div>
											<div class="col-md-2"><strong>권한</strong></div>
											<div class="col-md-2"></div>
											<hr width="100%;">
										</div>
										<div class="row">
											<%for (UserDTO uDTO : uList) {%>
											<%
												String name = "";
												if(uDTO.getTeam_no() == null) {
													name = "미가입";
												}else{
													name = uDTO.getTeam_no();
												}
											%>
											<div class="col-md-2"><%=uDTO.getUser_no() %></div>
											<div class="col-md-2"><%=uDTO.getUser_name() %></div>
											<div class="col-md-2"><%=uDTO.getUser_id() %></div>
											<div class="col-md-2"><%=name%></div>
											<div class="col-md-2"><%=uDTO.getAuth() %></div>
											<div class="col-md-2">
												<img onclick="doDetail(<%=uDTO.getUser_no() %>);" src="bootstrap/assets/img/glass.png">&emsp;
												<img onclick="doExile(<%=uDTO.getUser_no() %>);" src="bootstrap/assets/img/drop.png">
											</div>
											<hr width="100%;">
											<%} %>
										</div>
									</div>
									<div id="paging">
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
