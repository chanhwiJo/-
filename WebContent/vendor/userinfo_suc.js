
      var checkId = 0;
      var pwCheck = 0;
      var emailCheck = 0;
      function reset_reg_form() {
         $("#reg_form")[0].reset();
         $('#wrongId').hide();
         $('#failId').hide();
         $('#successId').hide();
         $('#wrongPw').hide();
         $('#wrongPw2').hide();
         $('#successMail').hide();
         $('#failMail').hide();
         $('#wrongMail').hide();

      }
      function idCheck() {
         var inputed = f.user_id.value;
         var CheckForm = /^[a-z0-9]{5,16}$/;
         if (!CheckForm.test(inputed)) {
            $('#wrongId').show();
            $('#failId').hide();
            $('#successId').hide();
            checkId = 0;
         } else {
            $.ajax({
               data : {
                  user_id : inputed
               },
               url : "idCheck.do",
               success : function(data) {
                  if (inputed == "" && data == '0') {
                     $('#wrongId').hide();
                     $('#failId').show();
                     $('#successId').hide();
                     checkId = 0;
                  } else if (data == '0') {
                     $('#wrongId').hide();
                     $('#failId').hide();
                     $('#successId').show();
                     checkId = 1;
                  } else if (data == '1') {
                     $('#wrongId').hide();
                     $('#failId').show();
                     $('#successId').hide();
                     checkId = 0;
                  }
               }
            })
         }
      }
      function checkPw() {
         var inputed = f.password.value;
         if (inputed.length < 6) {
            $('#wrongPw').show();
            $('#wrongPw2').hide();
         } else {
            $('#wrongPw').hide();
            $('#wrongPw2').hide();
         }
      }
      function checkPw2() {
         var inputed = f.password.value;
         var inputed2 = f.RepeatPassword.value;
         if (inputed != inputed2) {
            $('#wrongPw2').show();
         } else {
            $('#wrongPw2').hide();
         }
      }
      function checkMail() {
         var inputed = f.email.value;
         var CheckForm = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
         //정규식 표현    ^xy(xy를 제외한) (:이상                                   /$/끝내기 i : 대소문자 구별

         if (!CheckForm.test(inputed)) {
            $('#successMail').hide();
            $('#failMail').hide();
            $('#wrongMail').show();
            emailCheck = 0;
         } else {
            $.ajax({
               data : {
                  email : inputed
               },
               url : "checkMail.do",
               success : function(data) {
                  if (inputed == "" && data == '0') {
                     $('#successMail').hide();
                     $('#failMail').show();
                     $('#wrongMail').hide();
                     emailCheck = 0;
                  } else if (data == '0') {
                     $('#successMail').show();
                     $('#failMail').hide();
                     $('#wrongMail').hide();
                     emailCheck = 1;
                  } else if (data == '1') {
                     $('#successMail').hide();
                     $('#failMail').show();
                     $('#wrongMail').hide();
                     emailCheck = 0;
                  }
               }
            })
         }
      }


   
      function doRegUserCheck(f) {
         if (f.user_id.value == "") {
            alert("아이디를 입력하세요.");
            f.user_id.focus();
            return false;
         }   
         if (checkId == 0) {
            alert("사용하실수 없는 아이디 입니다.");
            f.user_id.focus();
            return false;
         }
         if (f.user_name.value == "") {
            alert("이름을 입력하세요.");
            f.user_name.focus();
            return false;
         }
      
         if (f.password.value == "") {
            alert("비밀번호를 입력하세요.");
            f.password.focus();
            return false;
         }
         if (f.password.value.length < 6) {
            alert("6~16자의 비밀번호를 사용해주세요.");
            f.password.focus();
            return false;
         }
         if (f.password.value.length > 16) {
            alert("6~16자의 비밀번호를 사용해주세요.");
            f.password.focus();
            return false;
         }
         if (f.RepeatPassword.value == "") {
            alert("비밀번호 재입력을 입력하세요.");
            f.RepeatPassword.focus();
            return false;
         }
         if (f.password.value != f.RepeatPassword.value) {
            alert("비밀번호가 같지 않습니다.");
            f.password.focus();
            return false;
         }            
         
         if (f.email.value == "") {
            alert("Email을 입력하세요.");
            f.email.focus();
            return false;
         }
         
         
         if (emailCheck == 0) {
            alert("사용하실수 없는 이메일 입니다.");
            f.email.focus();
            return false;
         }
         if (f.addr1.value == ""){
            alert("주소를 입력해주세요.");
            return false;
         }
            
         return true;
         }
      function userReg() {
         if (doRegUserCheck(document.getElementById('reg_form'))){
            
            $.ajax({
               url : "insertUserInfo.do",
               type : "post",
               data : {
                  'user_id' : $('#user_reg_id').val(),
                  'user_name' : $('#user_reg_name').val(),
                  'password' : $('#user_reg_password').val(),
                  'email' : $('#user_reg_mail').val(),
                  'addr1' : $('#user_reg_addr1').val()
               },
               success : function(a) {
                  console.log(a);
                  reset_reg_form();
                  if (a == 0) {
                     alert("회원가입되었습니다.");
                  location.href = "/login.do";
                     } else if (a == 1) {
                        alert("이미 가입된 회원입니다.");
                        reset_reg_form();
                     } else if (a == 2) {
                        alert("오류로 인해 회원가입이 실패하였습니다.");
                        reset_reg_form();
                     }
               }
            })
         }
   
      }
