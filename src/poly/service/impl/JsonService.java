package poly.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import poly.dto.AirDTO;
import poly.dto.WeatherDTO;
import poly.persistance.mongo.IJsonMapper;
import poly.service.IJsonService;
import poly.util.CmmUtil;
import poly.util.DateUtil;

@Service("JsonService")
public class JsonService implements IJsonService {

	@Resource(name = "JsonMapper")
	private IJsonMapper JsonMapper;

	private Logger log = Logger.getLogger(this.getClass());

	// JSON 형식을 파싱한다.
	private String getUrlForJSON(String callUrl) {
		log.info(this.getClass().getName() + ".getUrlForJSON start!");

		log.info("Requeted URL : " + callUrl);

		StringBuilder sb = new StringBuilder();
		URLConnection urlConn = null;
		InputStreamReader in = null;

		// json 결과값이 저장되는 변수
		String json = "";

		// SSL 적용된 사이트일 경우, 데이터 증명을 위해 사용
		HostnameVerifier allHostsValid = new HostnameVerifier() {
			@Override
			public boolean verify(String hostname, SSLSession session) {
				return true;
			}
		};
		HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

		try {
			// 웹 사이트 접속을 위한 URL 파싱
			URL url = new URL(callUrl);

			// 접속
			urlConn = url.openConnection();

			// 접속하면, 응답을 60초(60 * 1000ms) 동안 기다림
			if (urlConn != null) {
				urlConn.setReadTimeout(60 * 1000);
			}

			if (urlConn != null && urlConn.getInputStream() != null) {
				in = new InputStreamReader(urlConn.getInputStream(), Charset.forName("UTF-8"));

				BufferedReader bufferedReader = new BufferedReader(in);

				// 주어진 문자 입력 스트림 inputStream에 대해 기본 크기의 버퍼를 갖는 객체를 생성.
				if (bufferedReader != null) {
					int cp;
					while ((cp = bufferedReader.read()) != -1) {
						sb.append((char) cp);
					}
					bufferedReader.close();
				}
			}
			in.close();
		} catch (Exception e) {
			throw new RuntimeException("Exception URL : " + callUrl, e);
		}
		json = sb.toString(); // json 결과 저장
		log.info("JSON result : " + json);
		log.info(this.getClass().getName() + ".getUrlForJSON End!");

		return json;
	}

	// 날씨 정보
	@Override
	public int weatherInformation() throws Exception {
		log.info(this.getClass().getName() + ".WeatherInformation Start!");

		int res = 0;

		List<WeatherDTO> pList = new ArrayList<WeatherDTO>();
		WeatherDTO pDTO = new WeatherDTO();

		String url = "http://api.openweathermap.org/data/2.5/weather?q=seoul&appid=ddee8cc2c5200bcd83e14e7967de3af3";

		log.info("url : " + url);
		// OpenAPI 호출을 위한 파라미터 저장하기
		pDTO.setUrl(url);

		// JSON 결과 받아오기
		String json = getUrlForJSON(CmmUtil.nvl(pDTO.getUrl()));

		// String 변수의 문자열을 json 형태의 데이터 구조로 변경하기 위한 객체를 메모리에 올림
		JSONParser parser = new JSONParser();

		// String 변수의 문자열을 json 형태의 데이터 구조로 변경하기 위해 자바 최상위 Object 변환
		Object obj = parser.parse(json);

		// 변환된 Object 객체를 json 데이터 구조로 변경
		JSONObject jsonObject = (JSONObject) obj;

		// jsonArray 값을 가져오기 위해 형 변환
		jsonObject = (JSONObject) parser.parse(json);

		// weather 배열 값 가져오기
		JSONArray weatherJson = (JSONArray) jsonObject.get("weather");
		log.info("weatherJson : " + weatherJson);
		for (int i = 0; i < weatherJson.size(); i++) {
			JSONObject weatherArray = (JSONObject) weatherJson.get(i);
			log.info("main : " + weatherArray.get("main")); // 날씨
			String main = CmmUtil.nvl((String) weatherArray.get("main"));
			pDTO.setMain(main);
			log.info("description : " + weatherArray.get("description")); // 날씨 상세
			String description = CmmUtil.nvl((String) weatherArray.get("description"));
			pDTO.setDescription(description);
			String icon = CmmUtil.nvl((String) weatherArray.get("icon"));
			icon = "http://openweathermap.org/img/w/" + icon + ".png";
			icon = icon.replaceAll("///", ""); // 따옴표 제거
			pDTO.setIcon(icon);
			log.info("icon : " + icon);
		}

		// main의 키, 값 가져오기
		JSONObject mainJson = ((JSONObject) jsonObject.get("main"));
		log.info("mainJson : " + mainJson);
		Double temp = (Double) mainJson.get("temp"); // 온도
		temp = temp - 273.15; // 현재 온도를 구하기 위한 계산
		temp = (double) Math.round(temp * 10) / 10;
		pDTO.setTemp(temp);
		log.info("temp : " + temp);
		Long humidity = ((Long) mainJson.get("humidity"));
		pDTO.setHumidity(humidity);
		log.info("humidity : " + humidity);

		// wind의 키, 값 가져오기
		JSONObject windJson = ((JSONObject) jsonObject.get("wind"));
		log.info("windJson : " + windJson);
		Double speed = (Double) windJson.get("speed"); // 풍속
		pDTO.setWind(speed);
		log.info("speed : " + speed);

		// clouds의 키, 값 가져오기
		JSONObject cloudsJson = ((JSONObject) jsonObject.get("clouds"));
		log.info("cloudsJson : " + cloudsJson);
		long all = (long) cloudsJson.get("all"); // 구름
		pDTO.setClouds(all);
		log.info("all : " + all);

		pDTO.setCollect_time(DateUtil.getDateTime("yyyyMMddhhmmss"));

		// 한꺼번에 여러개의 데이터를 MongoDB에 저장할 List 형태의 데이터 저장하기
		pList.add(pDTO);

		String colNm = "weatherInfomation " + DateUtil.getDateTime("yyyyMMdd"); // 생성할 컬렉션명

		// MongoDB Collection 생성하기
		JsonMapper.createCollection(colNm);

		// MongoDB에 데이터저장하기
		JsonMapper.insertWeatherInformation(pList, colNm);

		log.info(this.getClass().getName() + ".WeatherInformation End!");
		return res;
	}

	// 대기 정보
	@Override
	public int airInformation() throws Exception {
		log.info(this.getClass().getName() + ".airInformation Start!");

		int res = 0;

		List<AirDTO> pList = new ArrayList<AirDTO>();
		AirDTO pDTO = new AirDTO();

		String url = "http://openapi.seoul.go.kr:8088/6d4d776b466c656533356a4b4b5872/json/RealtimeCityAir/1/1";

		log.info("url : " + url);
		// OpenAPI 호출을 위한 파라미터 저장하기
		pDTO.setUrl(url);

		// JSON 결과 받아오기
		String json = getUrlForJSON(CmmUtil.nvl(pDTO.getUrl()));

		// String 변수의 문자열을 json 형태의 데이터 구조로 변경하기 위한 객체를 메모리에 올림
		JSONParser parser = new JSONParser();

		// String 변수의 문자열을 json 형태의 데이터 구조로 변경하기 위해 자바 최상위 Object 변환
		Object obj = parser.parse(json);

		// 변환된 Object 객체를 json 데이터 구조로 변경
		JSONObject jsonObject = (JSONObject) obj;

		JSONObject airObject = (JSONObject) jsonObject.get("RealtimeCityAir");
		log.info("airObject " + airObject);

		// jsonArray 값을 가져오기 위해 형 변환
		jsonObject = (JSONObject) parser.parse(json);

		// row 배열 값 가져오기
		JSONArray airJson = (JSONArray) airObject.get("row");
		log.info("airJson : " + airJson);
		for (int i = 0; i < airJson.size(); i++) {
			JSONObject airArray = (JSONObject) airJson.get(i);
			log.info("PM10 : " + airArray.get("PM10")); // 미세먼지
			double pm10 = (double) airArray.get("PM10");
			pDTO.setPm10(pm10);
			log.info("PM25 : " + airArray.get("PM25")); // 초미세먼지
			double pm25 = (double) airArray.get("PM25");
			pDTO.setPm25(pm25);
			log.info("O3 : " + airArray.get("O3")); // 오존층
			double o3 = (double) airArray.get("O3");
			pDTO.setO3(o3);
			log.info("NO2 : " + airArray.get("NO2")); // 이산화 질소
			double no2 = (double) airArray.get("NO2");
			pDTO.setNo2(no2);
			log.info("CO : " + airArray.get("CO")); // 이산화 탄소
			double co = (double) airArray.get("CO");
			pDTO.setCo(co);
			log.info("SO2 : " + airArray.get("SO2")); // 이산화 황
			double so2 = (double) airArray.get("SO2");
			pDTO.setSo2(so2);
			log.info("IDEX_NM : " + airArray.get("IDEX_NM")); // 대기
			String air = (String) airArray.get("IDEX_NM");
			pDTO.setAir(air);
		}

		pDTO.setCollect_time(DateUtil.getDateTime("yyyyMMddhhmmss"));

		// 한꺼번에 여러개의 데이터를 MongoDB에 저장할 List 형태의 데이터 저장하기
		pList.add(pDTO);

		String colNm = "airInfomation " + DateUtil.getDateTime("yyyyMMdd"); // 생성할 컬렉션명

		// MongoDB Collection 생성하기
		JsonMapper.createCollection(colNm);

		// MongoDB에 데이터저장하기
		JsonMapper.insertAirInformation(pList, colNm);

		log.info(this.getClass().getName() + ".airInformation End!");
		return res;
	}

	// 날씨 데이터 조회
	@Override
	public List<WeatherDTO> getWeather() throws Exception {

		log.info(this.getClass().getName() + ".getWeather start!");

		// 조회할 컬렉션 이름
		String colNm = "weatherInfomation " + DateUtil.getDateTime("yyyyMMdd");

		List<WeatherDTO> rList = JsonMapper.getWeather(colNm);

		if (rList == null) {
			rList = new ArrayList<WeatherDTO>();
		}

		log.info(this.getClass().getName() + ".getWeather end!");

		return rList;
	}

	// 대기 데이터 조회
	@Override
	public List<AirDTO> getAir() throws Exception {
		
		log.info(this.getClass().getName() + ".getAir start!");

		// 조회할 컬렉션 이름
		String colNm = "airInfomation " + DateUtil.getDateTime("yyyyMMdd");

		List<AirDTO> rList = JsonMapper.getAir(colNm);

		if (rList == null) {
			rList = new ArrayList<AirDTO>();
		}

		log.info(this.getClass().getName() + ".getAir end!");

		return rList;
		
	}

}
