<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>calender test</title>

<link rel="stylesheet" href="vendor/css/bootstrap.min.css">  <!-- 이거 넣어야 모달창 켜짐 -->
<link rel="stylesheet" href="vendor/css/fullcalendar.min.css">
<link rel="stylesheet" href="css/main.css">
<link rel="stylesheet" href="vendor/css/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="vendor/css/select2.min.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans:400,500,600">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">

</head>
<body>

<!-- 캘린더 화면 띄우기 -->
<div id="loading"></div>
<div id="calendar"></div>

<!-- 일자 클릭시 메뉴오픈 -->
<div id="contextMenu" class="dropdown clearfix">
	<img id="icon">
	<ul class="dropdown-menu dropNewEvent" role="menu" aria-labelledby="dropdownMenu" style="display: block; position: static; margin-bottom: 5px;">
		<li><a tabindex="-1" href="#">중요</a></li>
		<li><a tabindex="-1" href="#">보통</a></li>
		<li class="divider"></li>
		<li><a tabindex="-1" href="#" data-role="close">Close</a></li>
	</ul>
</div>

<!-- 일정 추가 MODAL -->
<div class="modal fade" tabindex="-1" role="dialog" id="eventModal">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-xs-12">
						<label class="col-xs-4" for="edit-allDay">하루종일</label>
						<input class='allDayNewEvent' id="edit-allDay" type="checkbox">
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12">
						<label class="col-xs-4" for="edit-title">일정명</label>
						<input class="inputModal" type="text" name="edit-title" id="edit-title" required="required" />
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12">
						<label class="col-xs-4" for="edit-start">시작</label>
						<input class="inputModal" type="text" name="edit-start" id="edit-start" />
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12">
						<label class="col-xs-4" for="edit-end">끝</label>
						<input class="inputModal" type="text" name="edit-end" id="edit-end" />
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12">
						<label class="col-xs-4" for="edit-type">구분</label>
						<select class="inputModal" type="text" name="edit-type" id="edit-type">
							<option value="중요">중요</option>
							<option value="보통">보통</option>
						</select>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12">
						<label class="col-xs-4" for="edit-color">색상</label>
						<select class="inputModal" name="color" id="edit-color">
							<option value="#D25565" style="color: #D25565;">빨간색</option>
							<option value="#2de048" style="color: #2de048;">초록색</option>
							<option value="#9775fa" style="color: #9775fa;">보라색</option>
							<option value="#ffa94d" style="color: #ffa94d;">주황색</option>
							<option value="#74c0fc" style="color: #74c0fc;">파란색</option>
							<option value="#495057" style="color: #495057;">검정색</option>
						</select>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12">
						<label class="col-xs-4" for="edit-desc">설명</label>
							<textarea rows="4" cols="50" class="inputModal" name="edit-desc" id="edit-desc"></textarea>
					</div>
				</div>
			</div> <!-- modal-body -->
			<div class="modal-footer modalBtnContainer-addEvent">
				<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
				<button type="button" class="btn btn-success" id="save-event">저장</button>
			</div>
			<div class="modal-footer modalBtnContainer-modifyEvent">
				 <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
				<button type="button" class="btn btn-danger" id="deleteEvent">삭제</button>
				<button type="button" class="btn btn-success" id="updateEvent">저장</button>
			</div>
		</div> <!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script src="/vendor/js/jquery.min.js"></script>
<script src="/vendor/js/bootstrap.min.js"></script>
<script src="/vendor/js/moment.min.js"></script>
<script src="/vendor/js/fullcalendar.min.js"></script>
<script src="/vendor/js/ko.js"></script>
<script src="/vendor/js/select2.min.js"></script>
<script src="/vendor/js/bootstrap-datetimepicker.min.js"></script>
<script src="/js/main.js"></script>
<script src="/js/addEvent.js"></script>
<script src="/js/editEvent.js"></script>
<script src="/js/etcSetting.js"></script>

</body>

</html>