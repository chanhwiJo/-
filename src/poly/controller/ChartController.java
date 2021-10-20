package poly.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import poly.dto.UserDTO;
import poly.service.IUserService;

@Controller
public class ChartController {

	private Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "UserService")
	private IUserService userService;

	// 분석 화면
	@RequestMapping(value = "/chart", method = RequestMethod.GET)
	public String chart(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info(getClass() + "chart start!!!");
		log.info(getClass() + "chart end!!!");
		return "/chart";
	}

	// 성별 분석
	@RequestMapping(value = "genderData", method = RequestMethod.POST)
	@ResponseBody
	public List<UserDTO> genderData() throws Exception {
		log.info(getClass() + "genderData start!!!");

		List<UserDTO> gList = userService.getGenderData();

		log.info(getClass() + "genderData end!!!");
		return gList;
	}

	// 동호회 가입 여부 분석
	@RequestMapping(value = "teamData", method = RequestMethod.POST)
	@ResponseBody
	public List<UserDTO> teamData() throws Exception {
		log.info(getClass() + "teamData start!!!");

		List<UserDTO> tList = userService.getTeamData();

		log.info(getClass() + "teamData end!!!");
		return tList;
	}

	// 나이 분석
	@RequestMapping(value = "ageData", method = RequestMethod.POST)
	@ResponseBody
	public List<UserDTO> ageData() throws Exception {
		log.info(getClass() + "ageData start!!!");

		List<UserDTO> aList = userService.getAgeData();

		log.info(getClass() + "ageData end!!!");
		return aList;
	}

	// 지역 분석
	@RequestMapping(value = "addrData", method = RequestMethod.POST)
	@ResponseBody
	public List<UserDTO> addrData() throws Exception {
		log.info(getClass() + "addrData start!!!");

		List<UserDTO> aList = userService.getAddrData();

		log.info(getClass() + "addrData end!!!");
		return aList;
	}

	// 월별 회원 가입 비율 분석
	@RequestMapping(value = "regData", method = RequestMethod.POST)
	@ResponseBody
	public List<UserDTO> regData() throws Exception {
		log.info(getClass() + "regData start!!!");

		List<UserDTO> rList = userService.getRegData();
		
		log.info(getClass() + "regData end!!!");
		return rList;
	}

}
