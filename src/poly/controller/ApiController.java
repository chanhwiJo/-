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

import poly.dto.FavoriteDTO;
import poly.service.IFavoriteService;
import poly.util.CmmUtil;

@Controller
public class ApiController {
	
	private Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="FavoriteService")
	private IFavoriteService favoriteService;
	
	@RequestMapping(value="apiMain", method=RequestMethod.GET)
	public String apiMain(HttpServletRequest request, HttpServletResponse response, HttpSession session,
					Model model) throws Exception {
		log.info(getClass() + "apiMain start!!!");
		
		String no = CmmUtil.nvl(request.getParameter("no"));
		
		if(no.equals("")){
			no = "1";
		}
		log.info("no : " + no);
		
		model.addAttribute("no", no);
		
		log.info(getClass() + "apiMain end!!!");
		return "/apiMain";
	}
	
	@RequestMapping(value="api", method=RequestMethod.GET)
	public String api(HttpServletRequest request, HttpServletResponse response, HttpSession session,
					Model model) throws Exception {
		log.info(getClass() + "api start!!!");
		
		request.setCharacterEncoding("UTF-8");
		String course_name = CmmUtil.nvl(request.getParameter("COURSE_NAME"));
		course_name = course_name.replaceAll("& #40;", "(");
		course_name = course_name.replaceAll("& #41;", ")");
		String cpi_name = CmmUtil.nvl(request.getParameter("CPI_NAME"));
		cpi_name = cpi_name.replaceAll("& #40;", "(");
		cpi_name = cpi_name.replaceAll("& #41;", ")");
		log.info("course_name : " + course_name);
		log.info("cpi_name : " + cpi_name);
		model.addAttribute("course_name", course_name);
		model.addAttribute("cpi_name", cpi_name);
		
		log.info(getClass() + "api end!!!");
		return "/api";
	}
	
	@RequestMapping(value="apiSearch", method=RequestMethod.GET)
	public String apiSearch(HttpServletRequest request, HttpServletResponse response, HttpSession session,
					Model model) throws Exception {
		log.info(getClass() + "apiSearch start!!!");
		String course_name = CmmUtil.nvl(request.getParameter("COURSE_NAME"));
		String no = CmmUtil.nvl(request.getParameter("no"));

		if(no.equals("")){
			no = "1";
		}
		
		log.info("course_name : " + course_name);
		log.info("no : " + no);
		
		model.addAttribute("course_name", course_name);
		model.addAttribute("no", no);
		
		log.info(getClass() + "apiSearch end!!!");
		return "/apiSearch";
	}
	
	// 즐겨찾기 리스트
	@RequestMapping(value="/favorite", method=RequestMethod.GET)
	public String favorite(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			Model model) throws Exception {
		
		log.info(getClass()  + "favorite start!!!");
		
		String user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
		log.info("user_no : "+ user_no);
		
		List<FavoriteDTO> fList = favoriteService.getFavoriteList(user_no);
		
		if (fList == null) {
			fList = new ArrayList<FavoriteDTO>();
		}
		
		model.addAttribute("fList", fList);
		
		fList = null;
		
		log.info(getClass()  + "favorite end!!!");
		
		return "/favorite";
	}
	
	// 즐겨찾기 추가
	@RequestMapping(value="/favorite_Insert", method=RequestMethod.GET)
	public String favorite_Insert(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			Model model) throws Exception {
		
		log.info(getClass()  + "favorite_Insert start!!!");
		
		String user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
		log.info("user_no : " + user_no);
		
		request.setCharacterEncoding("UTF-8");
		String course_name = CmmUtil.nvl(request.getParameter("course_name"));
		course_name = course_name.replaceAll("& #40;", "(");
		course_name = course_name.replaceAll("& #41;", ")");
		
		String cpi_name = CmmUtil.nvl(request.getParameter("cpi_name"));
		cpi_name = cpi_name.replaceAll("& #40;", "(");
		cpi_name = cpi_name.replaceAll("& #41;", ")");
		
		String cpi_idx = CmmUtil.nvl(request.getParameter("cpi_idx"));
		String area_gu = CmmUtil.nvl(request.getParameter("area_gu"));
		
		log.info("COURSE_NAME : " + course_name);
		log.info("CPI_NAME : " + cpi_name);
		log.info("CPI_IDX : " + cpi_idx);
		log.info("AREA_GU : " + area_gu);
		FavoriteDTO fDTO = new FavoriteDTO();
		fDTO.setUser_no(user_no);
		fDTO.setCourse_name(course_name);
		fDTO.setCpi_name(cpi_name);
		fDTO.setCpi_idx(cpi_idx);
		fDTO.setArea_gu(area_gu);
		
		int same = favoriteService.sameFavorite(fDTO);
		if(same >= 1) {
			model.addAttribute("msg", "즐겨찾기 중복입니다.");
			model.addAttribute("url", "/favorite.do");
		} else {
			// 즐겨찾기 추가
			int res = favoriteService.insertFavorite(fDTO);
			if(res != 0) {
				model.addAttribute("msg", "즐겨찾기에 추가했습니다.");
				model.addAttribute("url", "/favorite.do");
			} else {
				model.addAttribute("msg", "즐겨찾기 실패했습니다.");
				model.addAttribute("url", "/apiMain.do");
			}
		}
		
		log.info(getClass()  + "favorite_Insert end!!!");
		
		return "/alert";
	}
	
	// 즐겨찾기 삭제
	@RequestMapping(value="/favorite_Delete", method=RequestMethod.GET)
	public String favorite_Delete(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			Model model) throws Exception {
		
		log.info(getClass()  + "favorite_Delete start!!!");
		
		String user_no = CmmUtil.nvl((String) session.getAttribute("session_user_no"));
		log.info("user_no : " + user_no);
		
		request.setCharacterEncoding("UTF-8");
		String course_name = CmmUtil.nvl(request.getParameter("course_name"));
		course_name = course_name.replaceAll("& #40;", "(");
		course_name = course_name.replaceAll("& #41;", ")");
		
		String cpi_name = CmmUtil.nvl(request.getParameter("cpi_name"));
		cpi_name = cpi_name.replaceAll("& #40;", "(");
		cpi_name = cpi_name.replaceAll("& #41;", ")");
		
		log.info("COURSE_NAME : " + course_name);
		log.info("CPI_NAME : " + cpi_name);
		
		FavoriteDTO fDTO = new FavoriteDTO();
		
		fDTO.setUser_no(user_no);
		fDTO.setCourse_name(course_name);
		fDTO.setCpi_name(cpi_name);
		
		// 즐겨찾기 삭제
		favoriteService.deleteFavorite(fDTO);
		
		model.addAttribute("msg", "즐겨찾기 삭제되었습니다.");
		model.addAttribute("url", "/favorite.do");
		
		log.info(getClass()  + "favorite_Delete end!!!");
		
		return "/alert";
	}
}
