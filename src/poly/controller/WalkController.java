package poly.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import poly.dto.StopWatchDTO;
import poly.service.IStopWatchService;
import poly.util.DateUtil;

@Controller
public class WalkController {

	private Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "StopWatchService")
	private IStopWatchService stopWatchService;

	@RequestMapping(value = "/walk")
	public String walk(HttpServletRequest request, HttpServletResponse response, HttpSession session) {

		log.info(this.getClass().getName() + ".walk start!");
		
		String user_no = (String) session.getAttribute("session_user_no");
		log.info("user_no : " + user_no);

		return "/walk";
	}

	// 스톱워치 멈추면 데이터 저장
	@RequestMapping(value = "stopwatch2")
	@ResponseBody
	public int stopwatch2(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			HttpSession session) {

		String user_no = (String) session.getAttribute("session_user_no");
		log.info("session_user_no" + user_no);
		String start_time = "000000";
		String id = (String) request.getParameter("id");
		String time = id.replaceAll(":", "");
		log.info("time : " + time);

		StopWatchDTO pDTO = new StopWatchDTO();

		pDTO.setUser_no(user_no);
		pDTO.setStarttime(start_time);
		pDTO.setLasttime(time);
		pDTO.setWalk_day(DateUtil.getDateTime("yyyyMMdd"));
		int res = stopWatchService.saveTime(pDTO);

		log.info(this.getClass());

		return res;
	}

	// 시간 분석
	@RequestMapping(value = "getTimeData")
	@ResponseBody
	public List<StopWatchDTO> getTimeData(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			HttpSession session) throws Exception {

		log.info(this.getClass().getName() + ".getTimeData Start!");

		String user_no = (String) session.getAttribute("session_user_no");
		log.info("session_user_no" + user_no);
		
		List<StopWatchDTO> rList = stopWatchService.getTimeData(user_no);

		log.info("rList : " + rList);

		log.info(this.getClass().getName() + ".getTimeData end!");

		return rList;
	}

}
