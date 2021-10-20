<%@page import="poly.dto.UserDTO"%>
<%@page import="poly.dto.ManageDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="poly.dto.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="poly.util.CmmUtil"%>
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
	String session_user_id = CmmUtil.nvl((String) session.getAttribute("session_user_id"));
	String session_user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
	String session_team_name = CmmUtil.nvl((String) session.getAttribute("session_team_no"));
	String session_auth = CmmUtil.nvl((String) session.getAttribute("session_auth"));
	String session_user_name = CmmUtil.nvl((String)session.getAttribute("session_user_name"));
%>

<%
	List<UserDTO> uList = (List<UserDTO>) request.getAttribute("uList");
	if(uList == null) {
		uList = new ArrayList();
	}
	UserDTO uDTO = (UserDTO) request.getAttribute("uDTO");
	if(uDTO == null) {
		uDTO = new UserDTO();
	}
	String team_name = CmmUtil.nvl((String) request.getAttribute("team_name"));
	
	UserDTO cDTO = (UserDTO)request.getAttribute("cDTO");
	int count = Integer.parseInt(cDTO.getData());
	System.out.println("count : " + count);
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
				location.href="/teamUL.do";
			}else{
				$.ajax({
					url : "/teamUserSearch.do",
					method : "post",
					data : {'search' : search},
					datatype : "json",
					success : function(data) {
						var contents = "";
						var content = "";
						var contentss = "";
						var local = new Array();
						
						contents += "<div id='divTable'>";
						contents += "<div class='row text-success'>";
						contents += "<div class='col-md-2' align='left'><strong>번호</strong></div>";
						contents += "<div class='col-md-2' align='left'><strong>아이디</strong></div>";
						contents += "<div class='col-md-2' align='left'><strong>이름</strong></div>";
						contents += "<div class='col-md-3' align='left'><strong>지역</strong></div>";
						contents += "<div class='col-md-3' align='left'></div></div>";
						contents += "<hr style='width: 100%;'>";
						
						$.each(data, function (key, value) {
							content += "<div class='row'>";
								content += "<div class='col-md-2' align='left'>"+value.user_no+"</div>";
								content += "<div class='col-md-2' align='left'>"+value.user_id+"</div>";
								content += "<div class='col-md-2' align='left'>"+value.user_name+"</div>";
								local = value.addr1.split(' ');
								content += "<div class='col-md-3' align='left'>"+local[0]+" "+local[1]+"</div>";
								content += "<div class='col-md-3' align='left'><img onclick='doDetail("+value.user_no+");'";
								content += "src='bootstrap/assets/img/glass.png'>&emsp;"
								if(value.auth == "UD") {
									content += "<img onclick='doapprove("+value.user_no+");'";
									content += "src='bootstrap/assets/img/out.png'>&emsp;";
								}else{
									content += "<img src='bootstrap/assets/img/in.png'>&emsp;"
								}
								content += "<img onclick='dojoinD("+value.user_no+");'";
								content += "src='bootstrap/assets/img/drop.png'></div></div>";
								content += "<hr style='width: 100%;'>";
						});
						
						contentss += "</div>"
						
						if(content == ""){
							content += '<div align="center" style="color:red;">"'+search+'" 에 해당하는 검색결과가 없습니다.</div>';
							$('#divTable').html(content);
						}else{
							$('#divTable').html(contents+content+contentss);
						}
					}
				});
				
				$.ajax({
					url : "/userTeamSearchNum.do",
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
			if(num == $(this).attr('id') && num == null){
				return false;
			}
			var search = $(this).attr('value');
			if(search == $(this).attr('value') && search == null){
				return false;
			}
			console.log("num : " + num);
			console.log("search : " + search);
			$.ajax({
				url : "/userTeamSearchPaging.do",
				method : "post",
				data : {"search" : search, "num" : num},
				dataType : "json",
				success : function(data, st, xhr) {
					console.log(data);
					var contents = "";
					var content = "";
					var contentss = "";
					var local = new Array();
					
					contents += "<div id='divTable'>";
					contents += "<div class='row text-success'>";
					contents += "<div class='col-md-2' align='left'><strong>번호</strong></div>";
					contents += "<div class='col-md-2' align='left'><strong>아이디</strong></div>";
					contents += "<div class='col-md-2' align='left'><strong>이름</strong></div>";
					contents += "<div class='col-md-3' align='left'><strong>지역</strong></div>";
					contents += "<div class='col-md-3' align='left'></div></div>";
					contents += "<hr style='width: 100%;'>";
					
					$.each(data, function (key, value) {
						content += "<div class='row'>";
							content += "<div class='col-md-2' align='left'>"+value.user_no+"</div>";
							content += "<div class='col-md-2' align='left'>"+value.user_id+"</div>";
							content += "<div class='col-md-2' align='left'>"+value.user_name+"</div>";
							local = value.addr1.split(' ');
							content += "<div class='col-md-3' align='left'>"+local[0]+" "+local[1]+"</div>";
							content += "<div class='col-md-3' align='left'><img onclick='doDetail("+value.user_no+");'";
							content += "src='bootstrap/assets/img/glass.png'>&emsp;"
							if(value.auth == "UD") {
								content += "<img onclick='doapprove("+value.user_no+");'";
								content += "src='bootstrap/assets/img/out.png'>&emsp;";
							}else{
								content += "<img src='bootstrap/assets/img/in.png'>&emsp;"
							}
							content += "<img onclick='dojoinD("+value.user_no+");'";
							content += "src='bootstrap/assets/img/drop.png'></div></div>";
							content += "<hr style='width: 100%;'>";
					});
					
					contentss += "</div>"
					$('#divTable').html(contents+content+contentss);
					
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
		
		$(document).on("click", ".page-link", function() {
			var num = $(this).attr('id');
			if(num == $(this).attr('id') && num == null){
				return false;
			}
			console.log("num : " + num);
			$.ajax({
				url : "/userTeamPagin.do",
				method : "post",
				data :{"num" : num},
				dataType : "json",
				success : function(data, st, xhr) {
					console.log(data);
					var contents = "";
					var content = "";
					var contentss = "";
					var local = new Array();
					
					contents += "<div id='divTable'>";
					contents += "<div class='row text-success'>";
					contents += "<div class='col-md-2' align='left'><strong>번호</strong></div>";
					contents += "<div class='col-md-2' align='left'><strong>아이디</strong></div>";
					contents += "<div class='col-md-2' align='left'><strong>이름</strong></div>";
					contents += "<div class='col-md-3' align='left'><strong>지역</strong></div>";
					contents += "<div class='col-md-3' align='left'></div></div>";
					contents += "<hr style='width: 100%;'>";
					
					$.each(data, function (key, value) {
						content += "<div class='row'>";
							content += "<div class='col-md-2' align='left'>"+value.user_no+"</div>";
							content += "<div class='col-md-2' align='left'>"+value.user_id+"</div>";
							content += "<div class='col-md-2' align='left'>"+value.user_name+"</div>";
							local = value.addr1.split(' ');
							content += "<div class='col-md-3' align='left'>"+local[0]+" "+local[1]+"</div>";
							content += "<div class='col-md-3' align='left'><img onclick='doDetail("+value.user_no+");'";
							content += "src='bootstrap/assets/img/glass.png'>&emsp;"
							if(value.auth == "UD") {
								content += "<img onclick='doapprove("+value.user_no+");'";
								content += "src='bootstrap/assets/img/out.png'>&emsp;";
							}else{
								content += "<img src='bootstrap/assets/img/in.png'>&emsp;"
							}
							content += "<img onclick='dojoinD("+value.user_no+");'";
							content += "src='bootstrap/assets/img/drop.png'></div></div>";
							content += "<hr style='width: 100%;'>";
					});
					
					contentss += "</div>"
					$('#divTable').html(contents+content+contentss);

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
		
		var nav1 = document.getElementById("nav1");
		var nav2 = document.getElementById("nav2");
		var nav3 = document.getElementById("nav3");
		nav1.onclick = function() {
			nav2.style.display = "";
			nav3.style.display = "";
		};
		
	};
	function doDetail(no){
		var user_no = no;
		location.href="/teamUR.do?user_no="+user_no;
	}
	function dojoinD(no) {
		var user_no = no;
		var y = confirm("삭제하시겠습니까?");
		if (y==true){
			location.href="/joinD.do?user_no="+user_no;
		}else {
			return false;
		}
		
	}
	function doapprove(no) {
		var user_no = no;
		var y = confirm("가입 승인하시겠습니까?");
		if (y==true){
			location.href="/teamAdd.do?user_no="+user_no;
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
#notice {
	font-size: 15px;
	color: red;
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
			data-image="/bootstrap/assets/img/sidebar_Trail.png">
			<!--
        Tip 1: You can change the color of the sidebar using: data-color="purple | azure | green | orange | danger"

        Tip 2: you can also add an image using data-image tag
    -->
			<div class="logo">
				<a href="home.do" class="simple-text logo-normal">산 책 조 아</a>
			</div>
			<div class="sidebar-wrapper">
				<ul class="nav">
					<li class="nav-item"><a class="nav-link" href="/main.do">
							<i class="material-icons">home</i>
							<p>메인</p>
					</a></li>
					<%
						if(session_user_id.equals("admin")) {
					%>
					<li class="nav-item"><a class="nav-link" href="/userList.do">
							<i class="material-icons">person</i>
							<p>회원 관리</p>
					</a></li>
					<li class="nav-item active"><a class="nav-link"
						href="/teamL.do"> <i
							class="material-icons">dvr</i>
							<p>동호회 관리</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/boardL.do"> <i class="material-icons">list</i>
							<p>자유게시판</p>
					</a></li>
					<%
						}else {
					%>
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
									class="material-icons">list</i>
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
					<li class="nav-item "><a class="nav-link" href="/boardL.do">
							<i class="material-icons">list</i>
							<p>자유게시판</p>
					</a></li>
					<li class="nav-item active"><a class="nav-link"
						href="/teamL.do"> <i class="material-icons">group</i>
							<p>동호회</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/chart.do"> <i
							class="material-icons">insert_chart_outlined</i>
							<p>분석</p>
					</a></li>
					<li class="nav-item "><a class="nav-link"
						href="/walk.do"> <i
							class="material-icons">directions_walk</i>
							<p>산책</p>
					</a></li>
					<%} %>
				</ul>
			</div>
		</div>
		<div class="main-panel">
			<!-- Navbar -->
            <jsp:include page="../top.jsp" flush="true"/>
            <!-- End Navbar -->
			<div class="content">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header card-header-success">
									<h2 class="card-title ">
										<b><%=team_name %></b>
									</h2>
								</div>
								<div class="card-body">
									<div class="form-group">
										<label style="font-size: 20px; color: #7e8892"><strong>리더</strong></label><br>
										<label><%=uDTO.getUser_name() %> (<%=uDTO.getUser_id() %>)</label>
									</div>
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
											<div class="col-md-2" align="left"><strong>번호</strong></div>
											<div class="col-md-2" align="left"><strong>아이디</strong></div>
											<div class="col-md-2" align="left"><strong>이름</strong></div>
											<div class="col-md-3" align="left"><strong>지역</strong></div>
											<div class="col-md-3" align="left"><strong></strong></div>
											<hr style="width:100%";>
										</div>
										<div class="row">
											<%for (UserDTO lDTO : uList){ %>
											<div class="col-md-2" align="left"><strong><%=lDTO.getUser_no() %></strong></div>
											<div class="col-md-2" align="left"><strong><%=lDTO.getUser_id() %></strong></div>
											<div class="col-md-2" align="left"><strong><%=lDTO.getUser_name() %></strong></div>
											<div class="col-md-3" align="left"><strong><%=lDTO.getAddr1() %></strong></div>
											<div class="col-md-3" align="left">
												<img onclick="doDetail(<%=lDTO.getUser_no() %>);" src="bootstrap/assets/img/glass.png">&emsp;
														<%if(lDTO.getAuth().equals("UD")) {%>
														<img onclick="doapprove(<%=lDTO.getUser_no() %>);" src="bootstrap/assets/img/out.png">&emsp;
														<%}else{ %>
														<img src="bootstrap/assets/img/in.png">&emsp;
														<%} %>
														<img onclick="dojoinD(<%=lDTO.getUser_no() %>);" src="bootstrap/assets/img/drop.png"></div>
											<%} %>
											<hr width="100%">
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
</body>
</html>