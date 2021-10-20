package poly.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import poly.dto.AirDTO;
import poly.dto.WeatherDTO;
import poly.service.IJsonService;

@Controller
public class JsonController {

	private Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "JsonService")
	private IJsonService JsonService;

	// 날씨 데이터 가져오기
	@RequestMapping(value = "weather")
	@ResponseBody
	public List<WeatherDTO> getWeather(HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.info(this.getClass().getName() + ".weather start!");

		// 날씨 정보 저장
		JsonService.weatherInformation();

		List<WeatherDTO> rList = JsonService.getWeather();

		if (rList == null) {
			rList = new ArrayList<WeatherDTO>();
		}

		log.info(this.getClass().getName() + ".weather end!");

		return rList;
	}

	// 날씨 데이터 가져오기
	@RequestMapping(value = "air")
	@ResponseBody
	public List<AirDTO> getAir(HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.info(this.getClass().getName() + ".air start!");

		// 대기 정보 저장
		JsonService.airInformation();

		List<AirDTO> rList = JsonService.getAir();

		if (rList == null) {
			rList = new ArrayList<AirDTO>();
		}

		log.info(this.getClass().getName() + ".air end!");

		return rList;
	}

}
