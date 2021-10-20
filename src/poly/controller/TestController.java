package poly.controller;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import poly.service.IBoardService;
import poly.service.IUserService;


@Controller
public class TestController {
	
	private Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="UserService")
	private IUserService userService;
	
	@Resource(name="BoardService")
	private IBoardService boardService;
	
	@RequestMapping(value="test")
	public String test(Model model) {
		log.info(this.getClass());

		return "/test";
	}
	
	@RequestMapping(value="test1")
	public String test1(Model model) {
		log.info(this.getClass());

		model.addAttribute("cpi_name", "cpi_name");
		model.addAttribute("course_name", "course_name");
		return "/test1";
	}
	
	@RequestMapping(value="test2")
	public String test2() {
		log.info(this.getClass());
		
		return "/test2";
	}
	
	@RequestMapping(value="chartTest")
	public String chartTest() {
		log.info(this.getClass());
		
		return "/chartTest";
	}
	
}
