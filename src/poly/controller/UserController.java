package poly.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import poly.dto.BoardDTO;

import poly.dto.KeyDTO;
import poly.dto.MailDTO;
import poly.dto.ManageDTO;
import poly.dto.TxtDTO;
import poly.dto.UserDTO;
import poly.service.IMailService;
import poly.service.IUserService;
import poly.util.CmmUtil;
import poly.util.EncryptUtil;
import poly.util.MailKey;
import poly.util.Random;
import poly.util.SHA256;
import poly.util.TextUtil;

@Controller
public class UserController {

	private Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "UserService")
	private IUserService userService;
	
	@Resource(name = "MailService")
	private IMailService mailService;

	// 회원가입 페이지
	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String join(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info(getClass() + "join start!!!");
		log.info(getClass() + "join end!!!");
		return "home/join";
	}

	// 회원가입
	@RequestMapping(value = "/join_proc", method = RequestMethod.POST)
	public String join_proc(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info(getClass() + "join_proc start!!!");

		String user_id = CmmUtil.nvl(request.getParameter("user_id"));
		String password = CmmUtil.nvl(EncryptUtil.encHashSHA256(request.getParameter("password")));
		String user_name = CmmUtil.nvl(request.getParameter("user_name"));
		String day = CmmUtil.nvl(request.getParameter("day"));
		String genders = CmmUtil.nvl(request.getParameter("gender"));
		String gender = "";
		String phone = CmmUtil.nvl(request.getParameter("phone"));
		String post = CmmUtil.nvl(request.getParameter("post"));
		String add1 = CmmUtil.nvl(request.getParameter("addr1"));
		String add2 = CmmUtil.nvl(request.getParameter("addr2"));
		String addr1 = TextUtil.exchangeEscapeNvl(add1);
		String addr2 = TextUtil.exchangeEscapeNvl(add2);
		String email = CmmUtil.nvl(request.getParameter("email"));

		if (genders.equals("1")) {
			gender = "남자";
		} else {
			gender = "여자";
		}

		log.info("user_id : " + user_id);
		log.info("password : " + password);
		log.info("user_name : " + user_name);
		log.info("day : " + day);
		log.info("gender : " + gender);
		log.info("phone : " + phone);
		log.info("post : " + post);
		log.info("addr 1 : " + addr1);
		log.info("addr 2 : " + addr2);
		log.info("email : " + email);

		UserDTO uDTO = new UserDTO();

		// 회원가입
		uDTO.setUser_id(user_id);
		uDTO.setPassword(password);
		uDTO.setUser_name(user_name);
		uDTO.setDay(day);
		uDTO.setGender(gender);
		uDTO.setPhone(phone);
		uDTO.setPost(post);
		uDTO.setAddr1(addr1);
		uDTO.setAddr2(addr2);
		uDTO.setEmail(email);
		int re = userService.insertJoin(uDTO);

		if (re != 0) {
			model.addAttribute("msg", "산책조아 가입되었습니다.");
			model.addAttribute("url", "/login.do");
		} else {
			model.addAttribute("msg", "회원가입에 실패하였습니다.");
			model.addAttribute("url", "/join.do");
		}
		log.info(getClass() + "join_proc end!!!");
		return "/alert";
	}

	// 아이디 중복 체크
	@RequestMapping(value = "/idCheck", method = RequestMethod.POST)
	public void idCheck(@RequestParam(value = "user_id") String user_id, HttpServletResponse response)
			throws Exception {
		log.info(this.getClass() + "idCheck start!!");

		user_id = CmmUtil.nvl(user_id);
		log.info(user_id);

		UserDTO uDTO = new UserDTO();
		uDTO.setUser_id(user_id);

		int check = userService.getUserid(uDTO);
		System.out.println("check : " + check);

		response.getWriter().print(check);
		response.getWriter().flush();
		response.getWriter().close();

		log.info(this.getClass() + "idCheck end!!");
	}
	
	// 이메일 중복 체크
	@RequestMapping(value = "/emailCheck", method = RequestMethod.POST)
	public void emailCheck(@RequestParam(value = "email") String email, HttpServletResponse response)
			throws Exception {
		log.info(this.getClass() + "emailCheck start!!");

		email = CmmUtil.nvl(email);
		log.info(email);

		UserDTO uDTO = new UserDTO();
		uDTO.setEmail(email);

		int check = userService.getEmail(uDTO);
		System.out.println("check : " + check);

		response.getWriter().print(check);
		response.getWriter().flush();
		response.getWriter().close();

		log.info(this.getClass() + "emailCheck end!!");
	}
	
	// 이메일 중복확인, 이메일 보냄
	@RequestMapping(value = "/emailEx", method = RequestMethod.POST)
	public void emailEx(@RequestParam(value = "user_email") String email, HttpServletResponse response)
			throws Exception {
		log.info(this.getClass() + "emailEx start!!");

		String keynum = new MailKey().getKey(5, false);
		KeyDTO kDTO = new KeyDTO();
		kDTO.setEmail(email);
		kDTO.setKeynum(keynum);

		log.info("keynum : " + keynum);
		log.info("email : " + email);

		int re = userService.insertKey(kDTO);
		log.info("인증 DB 넣기 OK");

		// 메일발송 로직
		MailDTO mDTO = new MailDTO();
		mDTO.setToMail(email);
		mDTO.setTitle("산책조아 인증번호입니다.");
		mDTO.setContents("인증번호는 [ " + kDTO.getKeynum() + " ] 입니다.");
		
		// 메일 발송
		mailService.doSendMail(mDTO);
		
		log.info("송신자 : " + mDTO.getToMail());
		log.info("제목 : " + mDTO.getTitle());
		log.info("내용 : " + mDTO.getContents());
		
		response.getWriter().print(re);
		response.getWriter().flush();
		response.getWriter().close();

		log.info(this.getClass() + "emailEx end!!");
	}

	// 인증번호 아이디 확인
	@RequestMapping(value = "/NECheck", method = RequestMethod.POST)
	public void NECheck(@RequestParam(value = "user_email") String email,
			@RequestParam(value = "user_name") String user_name, HttpServletResponse response) throws Exception {
		log.info(this.getClass() + ".NECheck start");

		log.info("user_name : " + user_name);
		log.info("email : " + email);

		UserDTO uDTO = new UserDTO();

		uDTO.setUser_name(user_name);
		uDTO.setEmail(email);

		// 아이디 찾기
		uDTO = userService.getIdSearch(uDTO);

		response.getWriter().print(uDTO);
		response.getWriter().flush();
		response.getWriter().close();

		log.info("머라고 넘어갈까 : " + uDTO);

		log.info(this.getClass() + "NECheck end!!!");
	}

	// 이메일인증
	@RequestMapping(value = "/keyCheck", method = RequestMethod.POST)
	public void keyCheck(@RequestParam(value = "user_email") String email,
			@RequestParam(value = "email_key") String keynum, HttpServletResponse response) throws Exception {
		log.info(this.getClass() + ".keyCheck start");

		log.info("email : " + email);
		log.info("key : " + keynum);

		KeyDTO kDTO = new KeyDTO();

		kDTO.setEmail(email);
		kDTO.setKeynum(keynum);

		kDTO = userService.getEmailKey(kDTO);

		response.getWriter().print(kDTO);
		response.getWriter().flush();
		response.getWriter().close();

		log.info(this.getClass() + "ketCheck end!!!");
	}
	
	//로그인 화면
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpServletRequest request, HttpServletResponse response, 
			Model model) throws Exception {
		log.info(getClass() + "login start!!!");
		log.info(getClass() + "login end!!!");
		return "home/login";
	}
	
	//로그인 실행
	@RequestMapping(value = "/login_proc", method = RequestMethod.POST)
	public String login_proc(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(this.getClass() + "login_proc start!!!");
		
		String user_id = req.getParameter("user_id");
		String password = req.getParameter("password");
		
		log.info(this.getClass() + "user_id : " + user_id);
		log.info(this.getClass() + "password : " + password);
		
		UserDTO uDTO = new UserDTO();
		uDTO.setUser_id(user_id);
		uDTO.setPassword(EncryptUtil.encHashSHA256(password));
		
		uDTO = userService.getUserInfo(uDTO);
		//팀번호 이용해서 팀이름 얻어와서 세션에 올리기
		if(uDTO != null) {
			session.setAttribute("session_user_no", uDTO.getUser_no());
			session.setAttribute("session_user_name", uDTO.getUser_name());
			session.setAttribute("session_user_id", uDTO.getUser_id());
			session.setAttribute("session_team_no", uDTO.getTeam_no());
			session.setAttribute("session_auth", uDTO.getAuth());
			session.setAttribute("session_password", uDTO.getPassword());
			log.info(this.getClass() + "login_proc end!!!	성공");
			return "home/home";
		}else{
			model.addAttribute("msg", "아이디 혹은 비밀번호가 잘못됬습니다. 다시 확인해주세요");
			model.addAttribute("url", "/login.do");
			log.info(this.getClass() + "login_proc end!!!	실패");
			return "/alert";
		}
	}
	
	//로그아웃
	@RequestMapping(value = "/logout")
	public String logout(Model model, HttpSession session) throws Exception{
		log.info(getClass() + "logout start!!!");
		
		session.setAttribute("session_user_no", "");
		session.setAttribute("session_user_name", "");
		session.setAttribute("session_user_id", "");
		session.setAttribute("session_team_no", "");
		session.setAttribute("session_auth", "");
		
		model.addAttribute("msg", "로그아웃되었습니다.");
		model.addAttribute("url", "home.do");
		
		log.info(getClass() + "logout end!!!");
		return "/alert";
	}
	
	//아이디찾기 화면
	@RequestMapping(value = "/idSearch", method = RequestMethod.GET)
	public String idSearch(HttpServletRequest request, HttpServletResponse response, 
			Model model) throws Exception {
		log.info(getClass() + "idSearch start!!!");
		log.info(getClass() + "idSearch end!!!");
		return "home/idSearch";
	}
	
	//아이디찾기 실행
	@RequestMapping(value = "/idSearch_Proc")
	public String idSearch_Proc(HttpServletRequest req, HttpServletResponse res, Model model)
		throws Exception {
		
		log.info(this.getClass() + "idSearch_proc start!!!");
		
		String user_name = req.getParameter("user_name");
		String email = req.getParameter("email");
		String phone = req.getParameter("phone");
		
		log.info("user_name : " + user_name);
		log.info("email : " + email);
		log.info("phone : " + phone);
		
		UserDTO uDTO = new UserDTO();
		
		uDTO.setUser_name(user_name);
		uDTO.setEmail(email);
		uDTO.setPhone(phone);
		
		uDTO = userService.getIdSearch(uDTO);
		
		if (uDTO != null) {
			model.addAttribute("msg", "회원님의 아이디는 [ " + uDTO.getUser_id() + " ] 입니다.");
			model.addAttribute("url", "/login.do");
		}else{
			model.addAttribute("msg", "입력하신 정보와 일치하는 회원이 없습니다. 다시 확인해주세요.");
			model.addAttribute("url", "/idSearch.do");
		}
		
		log.info(this.getClass() + "idSearch_proc end!!!");
		
		return "/alert";
	}
	
	//비밀번호변경 화면
	@RequestMapping(value = "/passwordReset", method = RequestMethod.GET)
	public String passwordReset(HttpServletRequest request, HttpServletResponse response, 
			Model model) throws Exception {
		log.info(getClass() + "passwordReset start!!!");
		log.info(getClass() + "passwordReset end!!!");
		return "home/passwordReset";
	}
	
	//비밀번호 변경
	@RequestMapping(value = "/reset_proc")
	public String pwreset(HttpServletRequest req, HttpServletResponse res, Model model)
		throws Exception {
		log.info(getClass() + "reset_pw start!!!");
		
		String user_id = CmmUtil.nvl(req.getParameter("user_id"));
		String email = CmmUtil.nvl(req.getParameter("email"));
		String password = CmmUtil.nvl(SHA256.SHA256_encode(req.getParameter("password")));
		
		log.info("id : " + user_id);
		log.info("email : " + email);
		log.info("pw : " + password);
		
		UserDTO pDTO = new UserDTO();
			
			pDTO.setUser_id(user_id);
			pDTO.setPassword(password);
			
			int re = userService.updatePassword(pDTO);
			
			if(re != 0) {
				model.addAttribute("msg", "비밀번호가 변경되었습니다.");
				model.addAttribute("url", "/login.do");
			}else{
				model.addAttribute("msg", "비밀번호변경에 실패하였습니다.");
				model.addAttribute("url", "/passwordReset.do");
			}
		
		log.info(getClass() + "reset_pw end!!!");
		return "/alert";
	}
	
	// 비밀번호 찾기 화면
	@RequestMapping(value = "/passwordFind", method = RequestMethod.GET)
	public String passwordFind(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
			log.info(getClass() + "passwordReset start!!!");
			log.info(getClass() + "passwordReset end!!!");
			return "home/passwordFind";
		}
	
	// 비밀번호 찾기(아이디 인증)
	@RequestMapping(value = "solution")
	public String findPasswordSolution(HttpServletRequest req, HttpServletResponse res, HttpSession session, Model model)
			throws Exception {

		log.info(this.getClass().getName() + ".solution start!");
		int check = 0;
		String msg = "";
		String url = "";
		UserDTO pDTO = null;

		try {

			String user_id = CmmUtil.nvl(req.getParameter("user_id"));

			log.info("user_id :" + user_id);

			pDTO = new UserDTO();

			pDTO.setUser_id(user_id);

			check = userService.idCheck(pDTO);
			log.info("check : " + check);

			if (check == 1) {
				session.setAttribute("session_user_id", pDTO.getUser_id());
				msg = "인증페이지로 이동합니다.";
				url = "myConfirm.do";
			} else if (check == 0) {
				model.addAttribute("msg", "아이디가 존재하지 않습니다.");
				model.addAttribute("url", "solution.do");
			}

		} catch (Exception e) {

			log.info(e.toString());
			e.printStackTrace();

		} finally {

			log.info(this.getClass().getName() + ".solution end!");
			model.addAttribute("msg", msg);
			model.addAttribute("url", url);
		}

		return "/alert";

	}
	
	// 인증 화면
	@RequestMapping(value = "myConfirm")
	public String myConfirm() {
		log.info(this.getClass().getName() + ".myConfirm start!");
		log.info(this.getClass().getName() + ".myConfirm end!");
		return "/home/myConfirm";
	}

	// 인증 처리
		@RequestMapping(value = "myConfirm_proc.do")
		public String myConfirm_proc(HttpServletRequest req, HttpServletResponse res, HttpSession session, Model model) throws Exception {
			log.info(this.getClass().getName() + ".myConfirm_proc start!");
			
			int check, ures, mres = 0;
			
			String user_id = CmmUtil.nvl((String)session.getAttribute("session_user_id"));
			String email = CmmUtil.nvl(req.getParameter("email"));
			String phone = CmmUtil.nvl(req.getParameter("phone"));
			
			log.info("user_id : " + user_id);
			log.info("email : " + email);
			log.info("phone : " + phone);
			
			UserDTO uDTO = new UserDTO();
			
			uDTO.setUser_id(user_id);
			uDTO.setEmail(email);
			uDTO.setPhone(phone);
			
			check = userService.checkPassword(uDTO);
			
			log.info("check : " + check);
			
			if (check == 1) {
				session.setAttribute("session_user_id", uDTO.getUser_id());
				// 비밀번호 랜덤변경
				String password = Random.setPassword(6);
				log.info("password : " + password);
				// 임시 비밀번호 생성
				String temp = password;
				log.info("temp : " + temp);
				// DTO에 원래 비밀번호 해시암호화, 이메일로 보낼 임시번호는 기존에 있던 비밀번호
				uDTO.setPassword(EncryptUtil.encHashSHA256(password));
				uDTO.setTemp(temp);

				// 비밀번호 자동 변경
				ures = userService.autoPassword(uDTO);
				log.info("ures : " + ures);

				// 임시비밀번호 이메일 보냄
				mres = userService.pwmail(uDTO);
				log.info("mres : " + mres);
				
				model.addAttribute("msg", "인증되었습니다. 임시 비밀번호를 이메일에서 확인하세요.");
				model.addAttribute("url", "login.do");
			} else {
				model.addAttribute("msg", "인증에 실패했습니다.");
				model.addAttribute("url", "myConfirm.do");
			}
			
			log.info(this.getClass().getName() + ".myConfirm_proc end!");
			return "/alert";
		}
	
	
	//비밀번호 변경을 위해 아이디, 이메일 확인
	@RequestMapping(value="/passwordCheck", method=RequestMethod.POST)
    public void passwordCheck(@RequestParam(value = "user_email") String email, @RequestParam(value = "user_id") String id,
    		HttpServletResponse response) throws Exception{
		log.info(this.getClass() + ".passwordCheck start");
		
		log.info("email : " + email);
		log.info("id : " + id);
		
		UserDTO uDTO = new UserDTO();
		uDTO.setEmail(email);
		uDTO.setUser_id(id);
		
		uDTO = userService.getPassword(uDTO);

		response.getWriter().print(uDTO);
		response.getWriter().flush();
		response.getWriter().close();
		
		log.info(this.getClass() + "passwordCheck end!!!");
	}
	
	//홈
	@RequestMapping(value="home", method=RequestMethod.GET)
	public String home(HttpServletRequest request, HttpServletResponse response, HttpSession session,
					Model model) throws Exception {
		log.info(getClass() + "home start!!!");
		log.info(getClass() + "home end!!!");
		return "home/home";
	}
	
	//메인화면
	@RequestMapping(value="main", method=RequestMethod.GET)
	public String main(HttpServletRequest request, HttpServletResponse response, 
					Model model, HttpSession session) throws Exception {
		log.info(getClass() + "main start!!!");
		
		String log_user = CmmUtil.nvl((String)session.getAttribute("session_user_id"));
		
		log.info("log_user : " + log_user);
		
		UserDTO u = userService.getUserNum();
		ManageDTO m = userService.getManageNum();
		BoardDTO b = userService.getBoardNum();
		
		log.info("u :" + u.getData());
		log.info("m :" + m.getNum());
		log.info("b :" + b.getData());
		
		//글귀출력
		TxtDTO t = new TxtDTO();
		
		t = userService.txtPrint(t);
		
		if(log_user.equals("admin")){
			log.info(this.getClass() + "admin_main end!!!");
			model.addAttribute("u", u);
			model.addAttribute("m", m);
			model.addAttribute("b", b);
			return "/amain";
		}else if(log_user.equals("")){
			model.addAttribute("msg", "회원만 볼 수 있는 페이지 입니다. 로그인 해주세요");
			model.addAttribute("url", "/login.do");
			log.info(this.getClass() + "not main end!!!");
			return "/alert";
		}else{
			log.info(this.getClass() + "user_main end!!!");
			model.addAttribute("u", u);
			model.addAttribute("m", m);
			model.addAttribute("b", b);
			model.addAttribute("t", t);
			return "/umain";
		}
	}
	
	//마이페이지(작성글)
	@RequestMapping(value="/regList", method=RequestMethod.GET)
	public String regList(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session) throws Exception{
		log.info(getClass() + "regList start!!!");
		
		String user_no = (String) session.getAttribute("session_user_no");
		
		//작성글 리스트
		List<BoardDTO> bList = userService.getRegList(user_no);
		
		if(bList == null) {
			bList = new ArrayList<BoardDTO>();
		}
		BoardDTO cDTO = userService.getRegNum(user_no);
		
		model.addAttribute("bList", bList);
		model.addAttribute("cDTO", cDTO);
		
		bList = null;
		
		log.info(getClass() + "regList end!!!");
		return "/regList";
	}
	
	//마이페이지(상세)
	@RequestMapping(value="userDetail", method=RequestMethod.GET)
	public String userDetail(HttpServletRequest re, HttpServletResponse res, HttpSession session,
					Model model) throws Exception {
		log.info(getClass() + "userDetail start!!!");
		
		String user_no = CmmUtil.nvl(re.getParameter("user_no"));
		log.info("user_no : " + user_no);
		
		UserDTO uDTO = new UserDTO();
		
		uDTO.setUser_no(user_no);
		
		uDTO = userService.getUserDetail(uDTO);
		if (uDTO == null) {
			uDTO = new UserDTO();
		}
		String team_no = uDTO.getTeam_no();
		String team_name = "";
		if(team_no.equals("0")){
			team_name = "미가입";
		}else{
			ManageDTO mDTO = new ManageDTO();
			mDTO.setTeam_no(team_no);
			mDTO = userService.getTeamName(mDTO);
			team_name = mDTO.getTeam_name();
		}
		log.info("team_name : " + team_name);
		model.addAttribute("uDTO", uDTO);
		model.addAttribute("team_name", team_name);
		log.info("uDTO : " + uDTO.getDay());
		
		log.info(getClass() + "userDetail end!!!");
		return "userDetail";
	}
	
	// 계정 수정 화면
	@RequestMapping(value="userUpdate", method=RequestMethod.GET)
	public String userUpdate(HttpServletRequest re, HttpServletResponse res, HttpSession session,
					Model model) throws Exception {
		log.info(getClass() + "userUpdate start!!!");
		
		String user_no = CmmUtil.nvl(re.getParameter("user_no"));
		log.info("user_no : " + user_no);
		
		UserDTO uDTO = new UserDTO();
		
		uDTO.setUser_no(user_no);
		
		uDTO = userService.getUserDetail(uDTO);
		if (uDTO == null) {
			uDTO = new UserDTO();
		}
		String team_no = uDTO.getTeam_no();
		String team_name = "";
		if(team_no.equals("0")){
			team_name = "미가입";
		}else{
			ManageDTO mDTO = new ManageDTO();
			mDTO.setTeam_no(team_no);
			mDTO = userService.getTeamName(mDTO);
			team_name = mDTO.getTeam_name();
		}
		log.info("team_name : " + team_name);
		model.addAttribute("uDTO", uDTO);
		model.addAttribute("team_name", team_name);
		model.addAttribute("uDTO", uDTO);
		
		log.info(getClass() + "userUpdate end!!!");
		return "userUpdate";
	}
	
	// 계정 수정
	@RequestMapping(value="userup_proc", method=RequestMethod.POST)
	public String update_proc(HttpServletRequest re, HttpServletResponse res, HttpSession session, Model model) throws Exception {
		log.info(getClass() + "update_proc start!!!");
		
		String user_no = (String) session.getAttribute("session_user_no");
		String day = CmmUtil.nvl(re.getParameter("day"));
		String genders = CmmUtil.nvl(re.getParameter("gender"));
		String gender = "";
		String phone = CmmUtil.nvl(re.getParameter("phone"));
		String post = CmmUtil.nvl(re.getParameter("post"));
		String add1 = CmmUtil.nvl(re.getParameter("addr1"));
		String add2 = CmmUtil.nvl(re.getParameter("addr2"));
		String addr1 = TextUtil.exchangeEscapeNvl(add1);
		String addr2 = TextUtil.exchangeEscapeNvl(add2);
		String password = CmmUtil.nvl(EncryptUtil.encHashSHA256(re.getParameter("password")));
		
		if(genders.equals("1")){
			gender = "남자";
		}else{
			gender = "여자";
		}
		
		log.info("user_no : " + user_no);
		log.info("day : " + day);
		log.info("gender : " + gender);
		log.info("phone : " + phone);
		log.info("post : " + post);
		log.info("addr1 : " + addr1);
		log.info("addr2 : " + addr2);
		log.info("password : " + password);
		
		UserDTO uDTO = new UserDTO();
		
		uDTO.setUser_no(user_no);
		uDTO.setDay(day);
		uDTO.setGender(gender);
		uDTO.setPhone(phone);
		uDTO.setPost(post);
		uDTO.setAddr1(addr1);
		uDTO.setAddr2(addr2);
		uDTO.setPassword(password);
		
		int r = userService.updateUser(uDTO);
		
		if (r != 0) {
			model.addAttribute("msg", "회원 정보가 수정되었습니다.");
			model.addAttribute("url", "/userDetail.do?user_no="+user_no);
		}else{
			model.addAttribute("msg", "회원 정보 수정에 실패했습니다.");
			model.addAttribute("url", "/userUpdate.do?user_no="+user_no);
		}
		
		log.info(getClass() + "update_proc end!!!");
		return "/alert";
	}
	
	// 계정 탈퇴
	@RequestMapping(value="userDrop", method=RequestMethod.GET)
	public String userDrop(HttpServletRequest req, HttpServletResponse res, HttpSession session,
					Model model) throws Exception {
		log.info(getClass() + "userDrop start!!!");
		
		String user_no = CmmUtil.nvl(req.getParameter("user_no"));
		log.info("user_no : " + user_no);
		
		UserDTO uDTO = new UserDTO();
		uDTO.setUser_no(user_no);
		
		int re = userService.deleteUser(uDTO);
		
		if(re != 0) {
			if(session.getAttribute("session_user_id").equals("admin")) {
				model.addAttribute("msg", "회원을 추방했습니다.");
				model.addAttribute("url", "/userList.do");
			} else {
			session.setAttribute("session_user_no", "");
			session.setAttribute("session_user_id", "");
			session.setAttribute("session_team_no", "");
			session.setAttribute("session_auth", "");
			model.addAttribute("msg", "탈퇴되었습니다.");
			model.addAttribute("url", "/home.do");
			}
		}else{
			model.addAttribute("msg", "탈퇴에 실패하였습니다.");
			model.addAttribute("url", "/userDetail.do?user_no="+user_no);
		}
		
		log.info(getClass() + "userDrop end!!!");
		return "/alert";
	}
	
	// 작성글 검색
	@RequestMapping(value="/regSearch")
	public @ResponseBody List<BoardDTO> regSearch(@RequestParam(value="search") String search, HttpSession session) throws Exception {
		log.info(getClass()  + "regSearch start!!!");
		
		String user_no = (String) session.getAttribute("session_user_no");
		
		log.info("search : " + search);
		log.info("user_no : " + user_no);
		
		BoardDTO bDTO = new BoardDTO();
		
		bDTO.setSearch("%"+search+"%");
		bDTO.setReg_no(user_no);
		
		List<BoardDTO> bList = userService.getRegSearch(bDTO);
		
		log.info(getClass() + "regSearch end!!!");
		return bList;
	}
	
	// 작성글 검색 결과 수
	@RequestMapping(value="/regSearchNum")
	public @ResponseBody int regSearchNum(@RequestParam(value="search") String search, Model model, HttpSession session) throws Exception {
		log.info(getClass()  + "regSearchNum start!!!");
		String reg_no = (String) session.getAttribute("session_user_no");
		
		log.info("reg_no : " + reg_no);
		log.info("reg : " + search);
		
		BoardDTO sDTO = new BoardDTO();
		sDTO.setSearch("%"+search+"%");
		sDTO.setReg_no(reg_no);
		sDTO = userService.getRegSearchNum(sDTO);
		
		int num = Integer.parseInt(sDTO.getData());
		
		log.info(getClass() + "regSearchNum end!!!");
		return num;
	}
	
	// 작성글 페이징
	@RequestMapping(value="/regSearchPaging")
	public @ResponseBody List<BoardDTO> regSearchPaging(@RequestParam(value="search") String search, @RequestParam(value="num") int num, Model model, HttpSession session) throws Exception {
		log.info(getClass()  + "regSearchPaging start!!!");
		String reg_no = (String) session.getAttribute("session_user_no");
		
		log.info("user_no : " + reg_no);
		log.info("search : " + search);
		log.info("num : " + num);
		
		BoardDTO uDTO = new BoardDTO();
		uDTO.setSearch("%"+search+"%");
		num = (num * 10) - 10;
		uDTO.setNum(num);
		uDTO.setReg_no(reg_no);
		
		List<BoardDTO> bList = userService.getRegSearchPage(uDTO);
		
		log.info(getClass() + "regSearchPaging end!!!");
		return bList;
	}
	
	// 회원 리스트
	@RequestMapping(value="userList", method=RequestMethod.GET)
	public String userList(HttpServletRequest re, HttpServletResponse res, HttpSession session, Model model ) throws Exception {
		log.info(getClass() + "userList start!!!");
		
		List<UserDTO> uList = userService.getUserList();
		if(uList == null) {
			uList = new ArrayList<>();
		}
		
		UserDTO cDTO = userService.getUserNum();
		
		model.addAttribute("uList", uList);
		model.addAttribute("cDTO", cDTO);
		
		log.info(getClass() + "userList end!!!");
		return "userList";
	}
	
	// 회원 리스트 페이징
	@RequestMapping(value="/userPaging")
	public @ResponseBody List<UserDTO> userPaging(@RequestParam(value="num") int num, HttpSession session) throws Exception {
		log.info(getClass()  + "userPaging start!!!");
		log.info("num : " + num);
		
		UserDTO uDTO = new UserDTO();
		
		num = (num * 10) - 10;
		
		uDTO.setNum(num);
		
		List<UserDTO> uList = userService.getUserPaging(uDTO);
		
		log.info(getClass() + "userPaging end!!!");
		return uList;
	}
	
	// 회원 검색
	@RequestMapping(value="/userSearch")
	public @ResponseBody List<UserDTO> userSearch(@RequestParam(value="search") String search, Model model, HttpSession session) throws Exception {
		log.info(getClass()  + "userSearch start!!!");
		log.info("search : " + search);
		
		UserDTO uDTO = new UserDTO();
		
		uDTO.setSearch("%"+search+"%");
		
		List<UserDTO> uList = userService.getUserSearch(uDTO);
		
		log.info(getClass() + "userSearch end!!!");
		return uList;
	}
	
	// 회원 검색 결과 수
	@RequestMapping(value="/userSearchNum")
	public @ResponseBody int userSearchNum(@RequestParam(value="search") String search, Model model, HttpSession session) throws Exception {
		log.info(getClass()  + "userSearchNum start!!!");
		log.info("search : " + search);
		
		UserDTO sDTO = new UserDTO();
		sDTO.setSearch("%"+search+"%");
		sDTO = userService.getUserSearchNum(sDTO);
		
		int num = Integer.parseInt(sDTO.getData());
		
		log.info(getClass() + "userSearchNum end!!!");
		return num;
	}
	
	// 회원 검색 페이징
	@RequestMapping(value="/userSearchPaging")
	public @ResponseBody List<UserDTO> userSearchPaging(@RequestParam(value="search") String search, @RequestParam(value="num") int num, Model model, HttpSession session) throws Exception {
		log.info(getClass()  + "userSearchPaging start!!!");
		log.info("search : " + search);
		log.info("num : " + num);
		
		UserDTO uDTO = new UserDTO();
		uDTO.setSearch("%"+search+"%");
		num = (num * 10) - 10;
		uDTO.setNum(num);
		
		List<UserDTO> uList = userService.getUserSearchPage(uDTO);
		
		log.info(getClass() + "userSearchPaging end!!!");
		return uList;
	}
	
	// 미래 날씨 페이지
	@RequestMapping(value="/futureWeather")
	public String fetureWeather() {
		
		log.info(getClass()  + "futureWeather start!!!");
		
		return "/futureWeather";
	}
	
}
