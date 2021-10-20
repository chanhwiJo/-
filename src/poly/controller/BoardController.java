package poly.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import poly.dto.BoardDTO;
import poly.dto.FileDTO;
import poly.dto.JoinDTO;
import poly.dto.LikeDTO;
import poly.dto.ManageDTO;
import poly.dto.UserDTO;
import poly.service.IBoardService;
import poly.util.CmmUtil;
import poly.util.SHA256;
import poly.util.TextUtil;

@Controller
public class BoardController {

	private Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "BoardService")
	private IBoardService boardService;

	// 게시글 리스트
	@RequestMapping(value = "/boardL", method = RequestMethod.GET)
	public String boardL(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "boardL start!!!");

		String check = "F";

		log.info("check : " + check);

		String team_no = "0";

		List<BoardDTO> bList = boardService.getBoardList(team_no);

		if (bList == null) {
			bList = new ArrayList<BoardDTO>();
		}

		BoardDTO cDTO = boardService.getBoardNum(team_no);

		session.setAttribute("check", check);
		model.addAttribute("bList", bList);
		model.addAttribute("cDTO", cDTO);

		bList = null;

		log.info(getClass() + "boardL end!!!");
		return "board/boardL";
	}

	// 게시글 쓰기 화면
	@RequestMapping(value = "/boardC", method = RequestMethod.GET)
	public String boardC(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "boardC start!!!");
		log.info(getClass() + "boardC end!!!");
		return "board/boardC";
	}

	// 게시글 쓰기
	@RequestMapping(value = "/boardC_proc", method = RequestMethod.POST)
	public String boardCproc(HttpServletRequest req, HttpServletResponse res, @RequestParam("file") MultipartFile f,
			Model model, HttpSession session) throws Exception {
		log.info(getClass() + "boardCproc start!!!");

		String user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
		String reg_name = CmmUtil.nvl((String) session.getAttribute("session_user_name"));
		String bcheck = CmmUtil.nvl((String) session.getAttribute("check"));
		String team_no = "";
		if (bcheck.equals("F")) {
			team_no = "0"; // 자유게시판 팀번호는 0
		} else if (bcheck.equals("T")) {
			team_no = CmmUtil.nvl((String) session.getAttribute("session_team_no"));
		}
		String title = CmmUtil.nvl(req.getParameter("title"));
		String content = CmmUtil.nvl(req.getParameter("content"));
		String notice = CmmUtil.nvl(req.getParameter("notice")); // 공지글 여부
		String check = CmmUtil.nvl(req.getParameter("check")); // 1이면 파일 없음 2이면 파일있음
		if (notice == "") {
			notice = "N";
		}
		String file = "";
		if (check.equals("1")) {
			file = "N";
		} else {
			if (!f.isEmpty()) { // isEmpty = 공백 -> false
				file = "Y";
			} else {
				file = "N";
			}
		}

		log.info("f : " + f); // MultipartFile
		log.info("user_no : " + user_no);
		log.info("reg_name : " + reg_name);
		log.info("team_no : " + team_no);
		log.info("title : " + title);
		log.info("content : " + content);
		log.info("notice : " + notice);
		log.info("file : " + file);
		log.info("check : " + check);

		BoardDTO bDTO = new BoardDTO();

		bDTO.setReg_no(user_no);
		bDTO.setReg_name(reg_name);
		bDTO.setTeam_no(team_no);
		bDTO.setTitle(title);
		bDTO.setContent(content);
		bDTO.setNotice_check(notice);
		bDTO.setFile_check(file);

		int re = boardService.insertBoard(bDTO);
		BoardDTO fDTO = boardService.getBoardNo(bDTO);

		String board_no = fDTO.getBoard_no();
		log.info("board_no : " + board_no);

		// 좋아요 기능
		LikeDTO lDTO = new LikeDTO();
		
		lDTO.setLike_no(board_no);
		lDTO.setUser_no(user_no);
		lDTO.setBoard_no(board_no);
		
		log.info("좋아요 번호 : " + lDTO.getLike_no());
		log.info("좋아요 유저 번호 : " + lDTO.getUser_no());
		
		boardService.insertLike(lDTO);
		
		if (re != 0) {
			if (file.equals("Y")) { // 파일이 있다면
				fileProc(f, req, model, board_no, team_no, user_no, "c"); // fileProc 함수 실행, MultipartFile, 
			} else {
				model.addAttribute("msg", "글이 등록되었습니다.");
				model.addAttribute("url", "/boardR.do?board_no=" + board_no);
			}
		} else {
			model.addAttribute("msg", "글 등록에 실패하였습니다.");
			model.addAttribute("url", "/boardC.do");
		}

		log.info(getClass() + "boardCproc end!!!");
		return "/alert";
	}

	// 파일 추가
	public String fileProc(@RequestParam(value = "f") MultipartFile file, HttpServletRequest req, Model model,
			String board_no, String team_no, String user_no, String check) throws Exception {
		log.info(getClass() + "file start!!!");

		log.info("file : " + file);
		log.info("board_no : " + board_no);
		log.info("user_no : " + user_no);
		log.info("team_no : " + team_no);
		log.info("check : " + check);

		// 현재 날짜 불러오기
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMdd-HH-mm-ss", Locale.KOREA);
		String strDate = dayTime.format(new Date(time));

		// 파일 저장 경로
		String savePath = "C:\\Users\\data19\\Desktop\\JCH\\file";
		
		String originalFileName = file.getOriginalFilename(); // 원래 파일
		String onlyFileName = originalFileName.substring(0, originalFileName.indexOf(".")); // 확장자 뺀 파일 이름
		String extention = originalFileName.substring(originalFileName.indexOf(".")); // 확장자

		String rename = SHA256.SHA256_encode(onlyFileName) + "_" + strDate + extention; // 파일 이름 변경
		String fullPath = savePath + "\\" + rename;

		log.info("저장 경로 : " + savePath);
		log.info("파일명+타입 : " + originalFileName);
		log.info("파일명: " + onlyFileName);
		log.info("타입: " + extention);
		log.info("바뀐 이름 : " + rename);
		log.info("전체 경로 : " + fullPath);

		byte[] bytes = file.getBytes(); // 파일의 용량
		BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(new File(fullPath)));
		String fileSize = String.valueOf(bytes.length); // 파일 크기
		log.info(fileSize);
		stream.write(bytes);
		stream.close();

		FileDTO f = new FileDTO();
		f.setFile_name(onlyFileName);
		f.setFile_path(fullPath);
		f.setFile_rename(rename);
		f.setFile_size(fileSize);
		f.setFile_type(extention);
		f.setOri_name(originalFileName);
		f.setSave_path(savePath);
		f.setReg_no(user_no);
		f.setBoard_no(board_no);
		f.setTeam_no(team_no);
		int r = boardService.insertFile(f);

		if (r != 0) {
			if (check.equals("c")) {
				model.addAttribute("msg", "글 등록에 성공하였습니다!");
				model.addAttribute("url", "/boardR.do?board_no=" + board_no);
			} else {
				model.addAttribute("msg", "글 수정에 성공하였습니다!");
				model.addAttribute("url", "/boardR.do?board_no=" + board_no);
			}
		} else {
			model.addAttribute("msg", "글 등록에 실패하였습니다.");
			model.addAttribute("url", "/boardC.do");
		}

		log.info(getClass() + "file end!!!");
		return "/alert";
	}

	// 글 상세
	@RequestMapping(value = "/boardR", method = RequestMethod.GET)
	public String boardR(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "boardR start!!!");

		String board_no = CmmUtil.nvl(req.getParameter("board_no"));
		String team_no = CmmUtil.nvl(req.getParameter("team_no"));
		String check = "";
		log.info("board_no : " + board_no);
		log.info("team_no : " + team_no);

		if (team_no.equals("")) {
			check = CmmUtil.nvl((String) session.getAttribute("check")); // team_no 값이 없으면 자유 게시판
		} else if (team_no.equals("0")) {
			check = "F";
		} else {
			check = "T";
		}

		log.info("check : " + check); // check = F -> 자유 게시판 check = Y -> 동호회 게시판

		BoardDTO bDTO = new BoardDTO(); // 상세 가져오기용
		BoardDTO cDTO = new BoardDTO(); // 조회수 올리기용
		FileDTO fDTO = new FileDTO(); // 파일 가져오기용

		cDTO.setBoard_no(board_no);
		boardService.updateCnt(cDTO);
		log.info("조회수 증가!!!");

		bDTO.setBoard_no(board_no);
		bDTO = boardService.getBoard(bDTO);
		if (bDTO == null) {
			bDTO = new BoardDTO();
		}
		fDTO.setBoard_no(board_no);
		fDTO = boardService.getFile(fDTO);
		if (fDTO == null) {
			fDTO = new FileDTO();
		}
		
		LikeDTO lDTO = new LikeDTO();
		
		lDTO.setLike_no(board_no);
		
		int like_count = boardService.countLike(lDTO);
		
		log.info("like_count : " + like_count);
		
		lDTO.setLike_count(like_count);
		
		
		model.addAttribute("bDTO", bDTO);
		model.addAttribute("fDTO", fDTO);
		model.addAttribute("lDTO", lDTO);

		log.info(getClass() + "boardR end!!!");
		return "board/boardR";
	}

	// 좋아요 증가
	@RequestMapping(value = "/like_Up", method = RequestMethod.GET)
	public String like_Up(HttpServletRequest req, HttpServletResponse response, Model model, HttpSession session) 
			throws Exception {
		
		log.info(this.getClass().getName() + ".like_Up start!!");
		
		String user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
		String board_no = CmmUtil.nvl(req.getParameter("board_no"));
		log.info("user_no : " + user_no); 
		log.info("board_no : " + board_no); 

		LikeDTO lDTO = new LikeDTO();
		
		lDTO.setLike_no(board_no);
		lDTO.setBoard_no(board_no);
		lDTO.setUser_no(user_no);

		int res = boardService.sameLike(lDTO);
		
		log.info("res : " + res);
		
		if (res > 0) {
			model.addAttribute("msg", "이미 좋아요를 눌렀습니다.");
			model.addAttribute("url", "/boardR.do?board_no=" + board_no);
		} else {
			// 좋아요 추가
			boardService.insertLike(lDTO);
			model.addAttribute("msg", "좋아요 증가!");
			model.addAttribute("url", "/boardR.do?board_no=" + board_no);
		}
		log.info(getClass() + "like_Up end!!!");
		
		return "/alert";
	}
	
	// 파일 다운
	@RequestMapping(value = "/down")
	public void file_down(HttpSession session, HttpServletRequest req, HttpServletResponse response, Model model)
			throws Exception {
		log.info(this.getClass() + ".file_down start!!!!");

		String file_no = CmmUtil.nvl(req.getParameter("file_no"));
		String ori_name = CmmUtil.nvl(req.getParameter("ori_name"));
		String file_path = CmmUtil.nvl(req.getParameter("file_path"));

		log.info("file_no : " + file_no);
		log.info("ori_name : " + ori_name);
		log.info("file_path : " + file_path);

		byte fileByte[] = FileUtils.readFileToByteArray(new File(file_path));

		response.setContentType("application/octet-stream");
		response.setContentLength(fileByte.length);
		response.setHeader("Content-Disposition",
				"attachment; fileName=\"" + URLEncoder.encode(ori_name, "UTF-8") + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.getOutputStream().write(fileByte);

		response.getOutputStream().flush();
		response.getOutputStream().close();

		log.info(this.getClass() + ".file_down end!!!!");
	}

	// 글 수정 화면
	@RequestMapping(value = "/boardU", method = RequestMethod.GET)
	public String boardU(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "boardU start!!!");

		String board_no = CmmUtil.nvl(req.getParameter("board_no"));
		log.info("board_no : " + board_no);

		BoardDTO bDTO = new BoardDTO(); // 상세 가져오기용
		FileDTO fDTO = new FileDTO(); // 파일 가져오기용

		bDTO.setBoard_no(board_no);
		bDTO = boardService.getBoard(bDTO);
		if (bDTO == null) {
			bDTO = new BoardDTO();
		}
		fDTO.setBoard_no(board_no);
		fDTO = boardService.getFile(fDTO);
		if (fDTO == null) {
			fDTO = new FileDTO();
		}
		model.addAttribute("bDTO", bDTO);
		model.addAttribute("fDTO", fDTO);

		log.info(getClass() + "boardU end!!!");
		return "board/boardU";
	}

	// 글 수정
	@RequestMapping(value = "/boardU_proc", method = RequestMethod.POST)
	public String boardUproc(HttpServletRequest req, HttpServletResponse res, @RequestParam("file") MultipartFile f,
			Model model, HttpSession session) throws Exception {
		log.info(getClass() + "boardUproc start!!!");

		String board_no = CmmUtil.nvl(req.getParameter("board_no"));
		String team_no = CmmUtil.nvl(req.getParameter("team_no"));
		String user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
		String title = CmmUtil.nvl(req.getParameter("title"));
		String content = CmmUtil.nvl(req.getParameter("content"));
		String notice = CmmUtil.nvl(req.getParameter("notice"));
		String check = CmmUtil.nvl(req.getParameter("check")); // 1이면 파일 없음 2이면 파일있음
		if (notice == "") {
			notice = "N";
		}
		String file = "";
		if (check.equals("1")) {
			file = "N";
		} else {
			if (!f.isEmpty()) {
				file = "Y";
			} else {
				file = "N";
			}
		}

		log.info("f : " + f);
		log.info("team_no : " + team_no);
		log.info("board_no : " + board_no);
		log.info("user_no : " + user_no);
		log.info("title : " + title);
		log.info("content : " + content);
		log.info("notice : " + notice);
		log.info("file : " + file);
		log.info("check : " + check);

		BoardDTO bDTO = new BoardDTO();
		FileDTO fDTO = new FileDTO();

		bDTO.setBoard_no(board_no);
		bDTO.setChg_no(user_no);
		bDTO.setTitle(title);
		bDTO.setContent(content);
		bDTO.setNotice_check(notice);
		bDTO.setFile_check(file);

		fDTO.setBoard_no(board_no);

		if (check.equals("1")) {
			boardService.deleteFile(fDTO);
			log.info("파일 삭제 성공이닷!");
		}

		int re = boardService.updateBoard(bDTO);

		if (re != 0) {
			if (file.equals("Y")) {
				boardService.deleteFile(fDTO);
				log.info("파일 삭제 성공");
				fileProc(f, req, model, board_no, team_no, user_no, "u");
			} else {
				model.addAttribute("msg", "글이 수정되었습니다.");
				model.addAttribute("url", "/boardR.do?board_no=" + board_no);
			}
		} else {
			model.addAttribute("msg", "글 수정에 실패하였습니다.");
			model.addAttribute("url", "/boardU.do?board_no=" + board_no);
		}

		log.info(getClass() + "boardUproc end!!!");
		return "/alert";
	}

	// 게시글 삭제
	@RequestMapping(value = "/boardD", method = RequestMethod.GET)
	public String boardD(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "boardD start!!!");

		String board_no = CmmUtil.nvl(req.getParameter("board_no"));
		String check = CmmUtil.nvl((String) session.getAttribute("check"));
		String user_id = CmmUtil.nvl((String) session.getAttribute("session_user_id"));

		log.info("board_no : " + board_no);
		log.info("check : " + check);
		log.info("user_id : " + user_id);

		BoardDTO bDTO = new BoardDTO();
		FileDTO fDTO = new FileDTO();
		LikeDTO lDTO = new LikeDTO();

		bDTO.setBoard_no(board_no);
		int re = boardService.deleteBoard(bDTO);
		
		lDTO.setBoard_no(board_no);
		boardService.deleteLike(lDTO); // 좋아요 삭제

		if (re != 0) {
			if (session.getAttribute("session_user_id").equals("admin")) {
					
			fDTO.setBoard_no(board_no);
			boardService.deleteFile(fDTO); // 파일 삭제
			log.info("파일 삭제 성공");
			lDTO.setBoard_no(board_no);
			boardService.deleteLike(lDTO); // 좋아요 삭제
			log.info("좋아요 삭제 성공");
			model.addAttribute("msg", "게시글을 삭제했습니다.");
			if (check.equals("T")) {
				model.addAttribute("url", "/teamL.do");
			} else {
				model.addAttribute("url", "/boardL.do");
			}

			} else {
				fDTO.setBoard_no(board_no);
				boardService.deleteFile(fDTO); // 파일 삭제
				log.info("파일 삭제 성공");
				lDTO.setBoard_no(board_no);
				boardService.deleteLike(lDTO); // 좋아요 삭제
				log.info("좋아요 삭제 성공");
				model.addAttribute("msg", "게시글이 삭제되었습니다.");
				if (check.equals("T")) {
					model.addAttribute("url", "/teamL.do");
				} else {
					model.addAttribute("url", "/boardL.do");
				}
			}
		} else {
			model.addAttribute("msg", "게시글 삭제에 실패하였습니다.");
			model.addAttribute("url", "/boardR.do?board_no=" + board_no);
		}

		log.info(getClass() + "boardD end!!!");
		return "/alert";
	}

	// 게시글 페이징
	@RequestMapping(value = "/boardPaging")
	public @ResponseBody List<BoardDTO> boardPaging(@RequestParam(value = "num") int num, Model model,
			HttpSession session) throws Exception {
		log.info(getClass() + "boardPaging start!!!");

		String check = (String) session.getAttribute("check");
		String team_no = "";

		if (check.equals("F")) {
			team_no = "0";
		} else {
			team_no = (String) session.getAttribute("session_team_no");
		}

		log.info("check : " + check);
		log.info("team_no : " + team_no);
		log.info("num : " + num);

		BoardDTO bDTO = new BoardDTO();

		bDTO.setTeam_no(team_no);
		num = (num * 10) - 10;
		bDTO.setNum(num);

		List<BoardDTO> bList = boardService.getboardPaging(bDTO);

		log.info(getClass() + "boardPaging end!!!");
		return bList;
	}

	// 게시글 검색
	@RequestMapping(value = "/boardSearch")
	public @ResponseBody List<BoardDTO> boardSearch(@RequestParam(value = "search") String search, HttpSession session)
			throws Exception {
		log.info(getClass() + "boardSearch start!!!");

		String check = (String) session.getAttribute("check");
		String team_no = "";

		if (check.equals("F")) {
			team_no = "0";
		} else {
			team_no = (String) session.getAttribute("session_team_no");
		}

		log.info("check : " + check);
		log.info("team_no : " + team_no);
		log.info("search : " + search);

		BoardDTO bDTO = new BoardDTO();

		bDTO.setTeam_no(team_no);
		bDTO.setSearch("%" + search + "%");

		List<BoardDTO> bList = boardService.getboardSearch(bDTO);

		log.info(getClass() + "boardSearch end!!!");
		return bList;
	}

	// 게시글 검색 결과 수
	@RequestMapping(value = "/boardSearchNum")
	public @ResponseBody int boardSearchNum(@RequestParam(value = "search") String search, Model model,
			HttpSession session) throws Exception {
		log.info(getClass() + "boardSearchNum start!!!");

		String check = (String) session.getAttribute("check");
		String team_no = "";

		if (check.equals("F")) {
			team_no = "0";
		} else {
			team_no = (String) session.getAttribute("session_team_no");
		}

		log.info("check : " + check);
		log.info("team_no : " + team_no);
		log.info("search : " + search);

		BoardDTO bDTO = new BoardDTO();

		bDTO.setTeam_no(team_no);
		bDTO.setSearch("%" + search + "%");

		bDTO = boardService.getboardSearchNum(bDTO);

		int num = Integer.parseInt(bDTO.getData());

		log.info(getClass() + "boardSearchNum end!!!");
		return num;
	}

	// 게시글 검색 결과 페이징
	@RequestMapping(value = "/boardSearchPaging")
	public @ResponseBody List<BoardDTO> boardSearchPaging(@RequestParam(value = "search") String search,
			@RequestParam(value = "num") int num, Model model, HttpSession session) throws Exception {
		log.info(getClass() + "boardSearchPaging start!!!");

		String check = (String) session.getAttribute("check");
		String team_no = "";

		if (check.equals("F")) {
			team_no = "0";
		} else {
			team_no = (String) session.getAttribute("session_team_no");
		}

		log.info("check : " + check);
		log.info("team_no : " + team_no);
		log.info("search : " + search);
		log.info("num : " + num);

		BoardDTO bDTO = new BoardDTO();

		bDTO.setTeam_no(team_no);
		bDTO.setSearch("%" + search + "%");
		num = (num * 10) - 10;
		bDTO.setNum(num);

		List<BoardDTO> bList = boardService.getboardSearchPage(bDTO);

		log.info(getClass() + "boardSearchPaging end!!!");
		return bList;
	}

	// 동호회 리스트 auth 값에 따라 변환
	@RequestMapping(value = "/teamL", method = RequestMethod.GET)
	public String teamL(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamL start!!!");

		String user_id = CmmUtil.nvl((String) session.getAttribute("session_user_id"));
		String auth = CmmUtil.nvl((String) session.getAttribute("session_auth"));

		log.info("user_id : " + user_id);
		log.info("auth : " + auth);

		ManageDTO cDTO = boardService.getTeamNum();

		if (user_id.equals("admin")) {

			List<ManageDTO> mList = boardService.getTeamList();

			if (mList == null) {
				mList = new ArrayList<ManageDTO>();
			}

			model.addAttribute("mList", mList);
			model.addAttribute("cDTO", cDTO);

			return "board/ateamL";
		} else {
			if (auth.equals("U") || auth.equals("UD")) {

				List<ManageDTO> mList = boardService.getTeamList();

				if (mList == null) {
					mList = new ArrayList<ManageDTO>();
				}

				model.addAttribute("mList", mList);
				model.addAttribute("cDTO", cDTO);

				return "board/uteamL";
			} else {
				session.setAttribute("check", "T");
				model.addAttribute("url", "/teamBoardL.do");
				return "/url";
			}
		}
	}

	// 동호회 게시판 화면
	@RequestMapping(value = "/teamBoardL", method = RequestMethod.GET)
	public String teamboardL(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamboardL start!!!");

		String check = CmmUtil.nvl((String) session.getAttribute("check"));
		String team_no = CmmUtil.nvl((String) session.getAttribute("session_team_no"));

		log.info("check : " + check);
		log.info("team_no : " + team_no);

		List<BoardDTO> bList = boardService.getBoardList(team_no);

		ManageDTO mDTO = new ManageDTO();
		mDTO.setTeam_no(team_no);
		mDTO = boardService.getTeam(mDTO);

		String tName = mDTO.getTeam_name();

		log.info("team_name = " + tName);

		if (bList == null) {
			bList = new ArrayList<BoardDTO>();
		}

		BoardDTO cDTO = boardService.getBoardNum(team_no);

		model.addAttribute("bList", bList);
		model.addAttribute("tName", tName);
		model.addAttribute("cDTO", cDTO);
		bList = null;

		log.info(getClass() + "teamboardL end!!!");
		return "board/boardL";
	}

	// 동호회 개설 화면
	@RequestMapping(value = "/teamC", method = RequestMethod.GET)
	public String teamC(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamC start!!!");

		log.info(getClass() + "teamC end!!!");
		return "board/teamC";
	}

	// 동호회명 중복 체크
	@RequestMapping(value = "/nameCheck", method = RequestMethod.POST)
	public String nameCheck(@RequestParam(value = "team_name") String team_name, HttpServletResponse res)
			throws Exception {
		log.info(getClass() + "nameCheck start!!!");

		team_name = CmmUtil.nvl(team_name);
		log.info("team_name : " + team_name);

		ManageDTO mDTO = new ManageDTO();
		mDTO.setTeam_name(team_name);

		int check = boardService.getTeamName(mDTO);
		System.out.println("check : " + check);

		res.getWriter().print(check);
		res.getWriter().flush();
		res.getWriter().close();

		log.info(getClass() + "nameCheck end!!!");
		return "board/teamC";
	}

	// 동호회 개설
	@RequestMapping(value = "/teamC_proc", method = RequestMethod.POST)
	public String teamC_proc(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamC_proc start!!!");

		String user_no = (String) session.getAttribute("session_user_no");
		String user_name = (String) session.getAttribute("session_user_name");
		String name = CmmUtil.nvl(req.getParameter("team_name"));
		String team_name = TextUtil.exchangeEscapeNvl(name);
		String join = CmmUtil.nvl(req.getParameter("join_form"));
		String join_form = "";
		String memo = CmmUtil.nvl(req.getParameter("team_memo"));
		String team_memo = "";
		if (memo.equals("")) {
			team_memo = team_name + "에 환영합니다.";
		} else {
			team_memo = TextUtil.exchangeEscapeNvl(memo);
		}

		if (join.equals("A")) {
			join_form = "자동 승인";
		} else {
			join_form = "리더 승인";
		}

		log.info("user_no : " + user_no);
		log.info("user_name : " + user_name);
		log.info("team_name : " + team_name);
		log.info("join_form : " + join_form); // A 자동승인, S 리더승인
		log.info("team_memo : " + team_memo);

		ManageDTO mDTO = new ManageDTO();

		mDTO.setLeader_no(user_no);
		mDTO.setLeader_name(user_name);
		mDTO.setTeam_name(team_name);
		mDTO.setJoin_form(join_form);
		mDTO.setTeam_memo(team_memo);
		mDTO.setReg_no(user_no);

		// 동호회 개설
		int re = boardService.insertTeam(mDTO);

		if (re != 0) {
			// 변경된 정보 세션 올리기
			mDTO = boardService.getTeamNo(mDTO);
			String team_no = mDTO.getTeam_no();
			log.info("team_no : " + team_no);
			session.setAttribute("session_team_no", team_no);
			session.setAttribute("session_auth", "UA");
			// 회원 권한, 팀번호 수정
			UserDTO uDTO = new UserDTO();
			uDTO.setAuth("UA");
			uDTO.setUser_no(user_no);
			uDTO.setTeam_no(team_no);
			boardService.updateUserTeam(uDTO);
			model.addAttribute("msg", "동호회가 개설되었습니다.");
			model.addAttribute("url", "/teamL.do");
		} else {
			model.addAttribute("msg", "동호회 개설에 실패하였습니다.");
			model.addAttribute("url", "/teamC.do");
		}

		log.info(getClass() + "teamC_proc end!!!");
		return "/alert";
	}

	// 동호회 가입 화면
	@RequestMapping(value = "/teamI", method = RequestMethod.GET)
	public String teamI(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamI start!!!");

		String team_no = CmmUtil.nvl(req.getParameter("team_no"));

		log.info("team_no : " + team_no);

		ManageDTO mDTO = new ManageDTO();
		mDTO.setTeam_no(team_no);

		mDTO = boardService.getTeam(mDTO);

		model.addAttribute("mDTO", mDTO);

		log.info(getClass() + "teamI end!!!");
		return "board/teamI";
	}

	// 동호회 가입
	@RequestMapping(value = "/teamI_proc", method = RequestMethod.POST)
	public String teamI_proc(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamI_proc start!!!");

		String team_no = CmmUtil.nvl(req.getParameter("team_no"));
		String memo = CmmUtil.nvl(req.getParameter("join_memo"));
		String join_memo = "";
		String join_form = CmmUtil.nvl(req.getParameter("join_form"));
		String user_no = (String) session.getAttribute("session_user_no");
		String join_check = "";

		if (memo.equals("")) {
			join_memo = "잘 부탁드립니다.";
		} else {
			join_memo = TextUtil.exchangeEscapeNvl(memo);
		}

		if (join_form.equals("자동 승인")) {
			join_check = "O";
			boardService.updateTeamUp(team_no);
		} else {
			join_check = "X";
		}

		log.info("team_no : " + team_no);
		log.info("join_memo : " + join_memo);
		log.info("join_check : " + join_check);
		log.info("user_no : " + user_no);

		JoinDTO jDTO = new JoinDTO();

		jDTO.setTeam_no(team_no);
		jDTO.setJoin_check(join_check);
		jDTO.setJoin_memo(join_memo);
		jDTO.setUser_no(user_no);

		int re = boardService.insertJoin(jDTO);

		if (re != 0) {
			session.setAttribute("session_team_no", team_no);
			String auth = "";
			// 가입 방식에 따라 권한 다르게 주어서 팀번호와 권한 수정하고 세션올리기
			if (join_check.equals("O")) {
				// 승인 UU
				session.setAttribute("session_auth", "UU");
				auth = "UU";
			} else {
				// 승인대기 UD
				session.setAttribute("session_auth", "UD");
				auth = "UD";
			}
			// 회원 권한, 팀번호 수정
			UserDTO uDTO = new UserDTO();
			uDTO.setUser_no(user_no);
			uDTO.setTeam_no(team_no);
			uDTO.setAuth(auth);
			boardService.updateUserTeam(uDTO);
			model.addAttribute("msg", "동호회 가입이 완료되었습니다.");
			model.addAttribute("url", "/teamL.do");
		} else {
			model.addAttribute("msg", "동호회 가입에 실패하였습니다.");
			model.addAttribute("url", "/teamI.do?team_no=" + team_no);
		}

		log.info(getClass() + "teamI_proc end!!!");
		return "/alert";
	}

	// 동호회 가입 취소 화면
	@RequestMapping(value = "/joinD", method = RequestMethod.GET)
	public String joinD(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "joinD start!!!");

		String team_no = (String) session.getAttribute("session_team_no");
		String user_no = CmmUtil.nvl(req.getParameter("user_no"));
		String no = (String) session.getAttribute("session_user_no");
		if (user_no.equals("")) {
			user_no = no;
		}
		log.info("user_no : " + user_no);

		UserDTO uDTO = new UserDTO();
		uDTO.setUser_no(user_no);
		uDTO.setTeam_no("0");
		uDTO.setAuth("U");
		boardService.updateUserTeam(uDTO);

		if (user_no.equals(no)) {
			session.setAttribute("session_auth", "U");
			session.setAttribute("session_team_no", "0");
		}
		JoinDTO jDTO = new JoinDTO();
		jDTO.setUser_no(user_no);

		boardService.deleteJoin(jDTO);
		boardService.updateTeamDwon(team_no);

		model.addAttribute("url", "/teamL.do");

		log.info(getClass() + "joinD end!!!");
		return "/url";
	}

	// 동호회 가입 취소
	@RequestMapping(value = "/joinDD", method = RequestMethod.GET)
	public String joinDD(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "joinDD start!!!");

		String user_no = (String) session.getAttribute("session_user_no");
		log.info("user_no : " + user_no);

		UserDTO uDTO = new UserDTO();
		uDTO.setUser_no(user_no);
		uDTO.setTeam_no("0");
		uDTO.setAuth("U");
		boardService.updateUserTeam(uDTO);

		session.setAttribute("session_auth", "U");
		session.setAttribute("session_team_no", "0");
		JoinDTO jDTO = new JoinDTO();
		jDTO.setUser_no(user_no);

		boardService.deleteJoin(jDTO);

		model.addAttribute("url", "/teamL.do");

		log.info(getClass() + "joinDD end!!!");
		return "/url";
	}

	// 동호회 상세
	@RequestMapping(value = "/teamR", method = RequestMethod.GET)
	public String teamR(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamR start!!!");

		String team_no = CmmUtil.nvl(req.getParameter("team_no"));

		log.info("team_no : " + team_no);

		ManageDTO mDTO = new ManageDTO();
		mDTO.setTeam_no(team_no);
		mDTO = boardService.getTeam(mDTO);

		if (mDTO == null) {
			mDTO = new ManageDTO();
		}

		model.addAttribute("mDTO", mDTO);

		log.info("team_name : " + mDTO.getTeam_name());

		log.info(getClass() + "teamR end!!!");
		return "board/teamR";
	}

	// 동호회 수정 화면
	@RequestMapping(value = "/teamU", method = RequestMethod.GET)
	public String teamU(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamU start!!!");

		String team_no = CmmUtil.nvl(req.getParameter("team_no"));

		log.info("team_no : " + team_no);

		ManageDTO mDTO = new ManageDTO();
		mDTO.setTeam_no(team_no);

		mDTO = boardService.getTeam(mDTO);

		model.addAttribute("mDTO", mDTO);

		log.info(getClass() + "teamU end!!!");
		return "board/teamU";
	}

	// 동호회 수정
	@RequestMapping(value = "/teamU_proc", method = RequestMethod.POST)
	public String teamU_proc(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamU_proc start!!!");

		String user_no = (String) session.getAttribute("session_user_no");
		String team_no = (String) session.getAttribute("session_team_no");
		String team_name = CmmUtil.nvl(req.getParameter("team_name"));
		String join = CmmUtil.nvl(req.getParameter("join_form"));
		String join_form = "";
		String memo = CmmUtil.nvl(req.getParameter("team_memo"));
		String team_memo = "";
		if (memo.equals("")) {
			team_memo = team_name + "에 환영합니다.";
		} else {
			team_memo = TextUtil.exchangeEscapeNvl(memo);
		}
		if (join.equals("A")) {
			join_form = "자동 승인";
		} else {
			join_form = "리더 승인";
		}

		log.info("user_no : " + user_no);
		log.info("team_no : " + team_no);
		log.info("team_name : " + team_name);
		log.info("join_form : " + join_form);
		log.info("team_memo : " + team_memo);

		ManageDTO mDTO = new ManageDTO();

		mDTO.setTeam_no(team_no);
		mDTO.setJoin_form(join_form);
		mDTO.setTeam_memo(team_memo);
		mDTO.setChg_no(user_no);

		int re = boardService.updateTeam(mDTO);

		if (re != 0) {
			model.addAttribute("msg", "동호회 정보가 수정되었습니다.");
			model.addAttribute("url", "/teamR.do?team_no=" + team_no);
		} else {
			model.addAttribute("msg", "동호회 수정에 실패하였습니다.");
			model.addAttribute("url", "/teamU.do?team_no=" + team_no);
		}

		log.info(getClass() + "teamU_proc end!!!");
		return "/alert";
	}

	// 동호회 삭제
	@RequestMapping(value = "/teamD", method = RequestMethod.GET)
	public String teamD(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamD start!!!");

		String auth = (String) session.getAttribute("session_auth");
		String team_no = CmmUtil.nvl(req.getParameter("team_no"));

		log.info("auth : " + auth);
		log.info("team_no : " + team_no);

		UserDTO uDTO = new UserDTO();
		uDTO.setTeam_no(team_no);
		uDTO.setAuth("U");
		boardService.deleteTeamDrop(team_no); // 팀 삭제(manageDTO)
		boardService.updateTeamDrop(uDTO); // 해당 팀에 등록되어있는 사람 정보 변경(UserDTO)
		boardService.deleteTeamBoard(team_no); // 글 삭제(boardDTO)
		boardService.deleteTeamFile(team_no); // 파일 삭제(fileDTO)
		
		if (session.getAttribute("session_user_id").equals("admin")) {
			boardService.deleteTeamDrop(team_no); // 팀 삭제(manageDTO)
			boardService.updateTeamDrop(uDTO); // 해당 팀에 등록되어있는 사람 정보 변경(UserDTO)
			boardService.deleteTeamBoard(team_no); // 글 삭제(boardDTO)
			boardService.deleteTeamFile(team_no); // 파일 삭제(fileDTO)
			model.addAttribute("url", "/teamL.do");
			model.addAttribute("msg", "동호회를 삭제했습니다.");
		} else {		
			if (auth.equals("UA")) {
				session.setAttribute("session_auth", "U");
				session.setAttribute("session_team_no", "0");
			}
		}
		model.addAttribute("url", "/teamL.do");
		model.addAttribute("msg", "동호회를 삭제했습니다.");
		log.info(getClass() + "teamD end!!!");
		return "/alert";
	}

	// 가입 신청 회원 보기
	@RequestMapping(value = "/teamUR", method = RequestMethod.GET)
	public String teamUR(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamUR start!!!");

		String user_no = CmmUtil.nvl(req.getParameter("user_no"));
		log.info("user_no : " + user_no);

		UserDTO uDTO = new UserDTO();
		uDTO = boardService.getJoinUser(user_no);
		if (uDTO == null) {
			uDTO = new UserDTO();
		}

		JoinDTO jDTO = new JoinDTO();
		jDTO = boardService.getJoin(user_no);
		if (jDTO == null) {
			jDTO = new JoinDTO();
		}

		model.addAttribute("uDTO", uDTO);
		model.addAttribute("jDTO", jDTO);

		log.info(getClass() + "teamUR end!!!");
		return "board/teamUR";
	}

	// 동호회 회원 관리 화면
	@RequestMapping(value = "/teamUL", method = RequestMethod.GET)
	public String teamUL(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamUL start!!!");

		String team_no = (String) session.getAttribute("session_team_no");
		log.info("team_no : " + team_no);

		ManageDTO mDTO = new ManageDTO();
		mDTO.setTeam_no(team_no);
		mDTO = boardService.getTeam(mDTO);
		if (mDTO == null) {
			mDTO = new ManageDTO();
		}
		String team_name = mDTO.getTeam_name();

		UserDTO uDTO = new UserDTO();
		uDTO = boardService.getUser(team_no);
		if (uDTO == null) {
			uDTO = new UserDTO();
		}

		List<UserDTO> uList = boardService.getUserList(team_no);
		if (uList == null) {
			uList = new ArrayList<UserDTO>();
		}

		UserDTO cDTO = boardService.getUserNum(team_no);

		model.addAttribute("uList", uList);
		model.addAttribute("uDTO", uDTO);
		model.addAttribute("cDTO", cDTO);
		model.addAttribute("team_name", team_name);

		log.info(getClass() + "teamUL end!!!");
		return "board/teamUL";
	}

	// 팀원 추가
	@RequestMapping(value = "/teamAdd", method = RequestMethod.GET)
	public String teamAdd(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamAdd start!!!");

		String user_no = CmmUtil.nvl(req.getParameter("user_no"));
		log.info("user_no : " + user_no);

		boardService.updateAuth(user_no);
		boardService.updateJoinCheck(user_no);

		model.addAttribute("url", "/teamUL.do");

		log.info(getClass() + "teamAdd end!!!");
		return "/url";
	}

	// 팀원 검색
	@RequestMapping(value="/teamUserSearch")
	public @ResponseBody List<UserDTO> teamUserSearch(@RequestParam(value="search") String search, HttpSession session) throws Exception {
		log.info(getClass()  + "teamUserSearch start!!!");
		
		String team_no = (String) session.getAttribute("session_team_no");
		
		log.info("team_no : " + team_no);
		log.info("search : " + search);
		
		UserDTO uDTO = new UserDTO();
		
		uDTO.setTeam_no(team_no);
		uDTO.setSearch("%"+search+"%");
		
		List<UserDTO> uList = boardService.getTeamUserSearch(uDTO);
		
		log.info(getClass() + "teamUserSearch end!!!");
		return uList;
	}
	
	// 팀원 검색 결과 수
	@RequestMapping(value = "/userTeamSearchNum")
	@ResponseBody 
	public int userSearchNum(@RequestParam(value = "search") String search, Model model,
			HttpSession session) throws Exception {
		log.info(getClass() + "userTeamSearchNum start!!!");
		String team_no = (String) session.getAttribute("session_team_no");

		log.info("team_no : " + team_no);
		log.info("search : " + search);

		UserDTO uDTO = new UserDTO();

		uDTO.setTeam_no(team_no);
		uDTO.setSearch("%" + search + "%");

		uDTO = boardService.getUserTeamSearchNum(uDTO);

		int num = Integer.parseInt(uDTO.getData());
		log.info("num : " + num);
		log.info(getClass() + "userTeamSearchNum end!!!");
		return num;
	}
	
	// 팀원 검색 페이징
	@RequestMapping(value = "/userTeamSearchPaging")
	public @ResponseBody List<UserDTO> userSearchPaging(@RequestParam(value = "search") String search,
			@RequestParam(value = "num") int num, Model model, HttpSession session) throws Exception {
		log.info(getClass() + "userTeamSearchPaging start!!!");
		String team_no = (String) session.getAttribute("session_team_no");

		log.info("team_no : " + team_no);
		log.info("search : " + search);
		log.info("num : " + num);

		UserDTO uDTO = new UserDTO();
		uDTO.setTeam_no(team_no);
		uDTO.setSearch("%" + search + "%");
		num = (num * 10) - 10;
		uDTO.setNum(num);

		List<UserDTO> uList = boardService.getUserTeamSearchPage(uDTO);

		log.info(getClass() + "userTeamSearchPaging end!!!");
		return uList;
	}

	// 팀원 리스트 페이징
	@RequestMapping(value = "/userTeamPagin")
	public @ResponseBody List<UserDTO> userPaging(@RequestParam(value = "num") int num, HttpSession session)
			throws Exception {
		log.info(getClass() + "userTeamPagin start!!!");
		String team_no = (String) session.getAttribute("session_team_no");

		log.info("team_no : " + team_no);
		log.info("num : " + num);

		UserDTO uDTO = new UserDTO();

		num = (num * 10) - 10;

		uDTO.setTeam_no(team_no);
		uDTO.setNum(num);

		List<UserDTO> uList = boardService.getUserTeamPaging(uDTO);

		log.info(getClass() + "userTeamPagin end!!!");
		return uList;
	}
	
	// 동호회 페이징
	@RequestMapping(value="/teamPaging")
	public @ResponseBody List<ManageDTO> teamPaging(@RequestParam(value="num") int num, Model model, HttpSession session) throws Exception {
		log.info(getClass()  + "teamPaging start!!!");
		
		log.info("num : " + num);
		
		ManageDTO mDTO = new ManageDTO();
		
		num = (num * 10) - 10;
		mDTO.setData(num);
		
		List<ManageDTO> mList = boardService.getTeamPaging(mDTO);
		
		log.info(getClass() + "teamPaging end!!!");
		return mList;
	}
	
	// 동호회 검색
	@RequestMapping(value = "/teamSearch")
	public @ResponseBody List<ManageDTO> teamSearch(@RequestParam(value = "search") String search, HttpSession session)
			throws Exception {
		log.info(getClass() + "teamSearch start!!!");
		log.info("search : " + search);
		ManageDTO mDTO = new ManageDTO();
		
		mDTO.setSearch("%" + search + "%");
			
		List<ManageDTO> mList = boardService.getTeamSearch(mDTO);
			
		log.info(getClass() + "teamSearch end!!!");
		
		return mList;
		
	}
	
	// 동호회 검색 결과 수
	@RequestMapping(value="/teamSearchNum")
	public @ResponseBody int teamSearchNum(@RequestParam(value="search") String search, Model model, HttpSession session) throws Exception {
		log.info(getClass()  + "teamSearchNum start!!!");
		
		log.info("search : " + search);
		
		ManageDTO mDTO = new ManageDTO();
		
		mDTO.setSearch("%"+search+"%");
		
		mDTO = boardService.getTeamSearchNum(mDTO);
		
		int num = Integer.parseInt(mDTO.getData1());
		
		log.info(getClass() + "teamSearchNum end!!!");
		return num;
	}
	
	// 동호회 검색 결과 페이징
	@RequestMapping(value = "/teamSearchPaging")
	public @ResponseBody List<ManageDTO> teamSearchPaging(@RequestParam(value = "search") String search,
			@RequestParam(value = "num") int num, Model model, HttpSession session) throws Exception {
		log.info(getClass() + "teamSearchPaging start!!!");

		log.info("search : " + search);
		log.info("num : " + num);

		ManageDTO mDTO = new ManageDTO();

		mDTO.setSearch("%" + search + "%");
		num = (num * 10) - 10;
		mDTO.setData(num);

		List<ManageDTO> mList = boardService.getTeamSearchPage(mDTO);

		log.info(getClass() + "teamSearchPaging end!!!");
		return mList;
	}
}
