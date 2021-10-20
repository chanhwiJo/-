package poly.persistance.mongo.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;

import org.apache.log4j.Logger;

import poly.dto.AirDTO;
import poly.dto.WeatherDTO;
import poly.persistance.mongo.IJsonMapper;
import poly.util.CmmUtil;

@Component("JsonMapper")
public class JsonMapper implements IJsonMapper {

	@Autowired
	private MongoTemplate mongodb;

	private Logger log = Logger.getLogger(this.getClass());

	@Override
	public boolean createCollection(String colNm) throws Exception {
		log.info(this.getClass().getName() + ".createCollection Start!");

		boolean res = false;

		// 기존에 등록된 컬렉션 이름이 존재하는지 체크하고, 존재하면 기존 컬렉션 삭제함
		if (mongodb.collectionExists(colNm)) {
			mongodb.dropCollection(colNm); // 기존 컬렉션 삭제
		}

		// 컬렉션 생성 및 인덱스 생성, MongoDB에서 데이터 가져오는 방식에 맞게 인덱스는 반드시 생성하자!
		// 데이터 양이 많지 않으면 문제되지 않으나, 최소 10만건 이상 데이터 저장 시 속도가 약 10배 이상 발생함
		mongodb.createCollection(colNm).createIndex(new BasicDBObject("collect_time", 1));

		res = true;

		log.info(this.getClass().getName() + ".createCollection End!");

		return res;
	}

	// MongoDB 날씨 데이터 저장하기
	@Override
	public int insertWeatherInformation(List<WeatherDTO> pList, String colNm) throws Exception {
		log.info(this.getClass().getName() + ".insertInformation Start!");

		int res = 0;

		if (pList == null) {
			pList = new ArrayList<WeatherDTO>();
		}

		Iterator<WeatherDTO> it = pList.iterator();

		while (it.hasNext()) {
			WeatherDTO pDTO = (WeatherDTO) it.next();

			if (pDTO == null) {
				pDTO = new WeatherDTO();
			}

			mongodb.insert(pDTO, colNm);

		}

		res = 1;

		log.info(this.getClass().getName() + ".insertInformation End!");

		return res;
	}

	@Override
	public int insertAirInformation(List<AirDTO> pList, String colNm) throws Exception {
		int res = 0;

		if (pList == null) {
			pList = new ArrayList<AirDTO>();
		}

		Iterator<AirDTO> it = pList.iterator();

		while (it.hasNext()) {
			AirDTO pDTO = (AirDTO) it.next();

			if (pDTO == null) {
				pDTO = new AirDTO();
			}

			mongodb.insert(pDTO, colNm);

		}

		res = 1;

		log.info(this.getClass().getName() + ".insertInformation End!");

		return res;
	}

	// 날씨 데이터 조회
	@Override
	public List<WeatherDTO> getWeather(String colNm) throws Exception {

		log.info(this.getClass().getName() + ".getWeatehr start!");

		// 데이터를 가져올 컬렉션 선택
		DBCollection rCol = (DBCollection) mongodb.getCollection(colNm);

		// 컬렉션으로부터 전체 데이터 가져오기
		Iterator<DBObject> cursor = rCol.find();

		// 컬렉션으로부터 전체 데이터 가져온 것을 List 형태로 저장하기 위한 변수 선언
		List<WeatherDTO> rList = new ArrayList<WeatherDTO>();

		// 날씨 데이터 저장하기
		WeatherDTO rDTO = null;

		while (cursor.hasNext()) {

			rDTO = new WeatherDTO();

			final DBObject current = cursor.next();

			String collect_time = CmmUtil.nvl((String) current.get("collect_time")); // 수집시간
			log.info("collect_time : " + collect_time);
			String main = CmmUtil.nvl((String) current.get("main")); // 날씨
			log.info("main : " + main);
			double temp = (double) current.get("temp"); // 온도
			log.info("temp : " + temp);
			Long humidity = (Long) current.get("humidity"); // 습도
			log.info("humidity : " + humidity);
			double wind = (double) current.get("wind"); // 바람
			log.info("wind : " + wind);
			long clouds = (long) current.get("clouds"); // 구름
			log.info("clouds : " + clouds);
			String description = CmmUtil.nvl((String) current.get("description")); // 날씨 상세
			log.info("description : " + description);
			String icon = CmmUtil.nvl((String) current.get("icon")); // 이미지
			log.info("icon : " + icon);

			rDTO.setCollect_time(collect_time);
			rDTO.setMain(main);
			rDTO.setTemp(temp);
			rDTO.setHumidity(humidity);
			rDTO.setWind(wind);
			rDTO.setClouds(humidity);
			rDTO.setDescription(description);
			rDTO.setIcon(icon);

			rList.add(rDTO); // List에 데이터 저장

			rDTO = null;
		}

		log.info(this.getClass().getName() + ".getWeatehr end!");

		return rList;
	}

	// 대기 데이터 조회
	@Override
	public List<AirDTO> getAir(String colNm) throws Exception {

		log.info(this.getClass().getName() + ".getAir start!");

		// 데이터를 가져올 컬렉션 선택
		DBCollection rCol = (DBCollection) mongodb.getCollection(colNm);

		// 컬렉션으로부터 전체 데이터 가져오기
		Iterator<DBObject> cursor = rCol.find();

		// 컬렉션으로부터 전체 데이터 가져온 것을 List 형태로 저장하기 위한 변수 선언
		List<AirDTO> rList = new ArrayList<AirDTO>();

		// 날씨 데이터 저장하기
		AirDTO rDTO = null;

		while (cursor.hasNext()) {

			rDTO = new AirDTO();

			final DBObject current = cursor.next();

			String collect_time = CmmUtil.nvl((String) current.get("collect_time")); // 수집시간
			log.info("collect_time : " + collect_time);
			double pm10 = (double) current.get("pm10"); // 미세먼지
			log.info("pm10 : " + pm10);
			double pm25 = (double) current.get("pm25"); // 초미세먼지
			log.info("pm25 : " + pm25);
			double o3 = (double) current.get("o3"); // 오존층
			log.info("o3 : " + o3);
			double no2 = (double) current.get("no2"); // 이산화 질소
			log.info("no2 : " + no2);
			double co = (double) current.get("co"); // 이산화 탄소
			log.info("co : " + co);
			double so2 = (double) current.get("so2"); // 이산호 황
			log.info("so2 : " + so2);
			String air = (String) current.get("air"); // 대기
			log.info("air : " + air);

			rDTO.setCollect_time(collect_time);
			rDTO.setPm10(pm10);
			rDTO.setPm25(pm25);
			rDTO.setO3(o3);
			rDTO.setNo2(no2);
			rDTO.setCo(co);
			rDTO.setSo2(so2);
			rDTO.setAir(air);

			rList.add(rDTO); // List에 데이터 저장

			rDTO = null;
		}

		log.info(this.getClass().getName() + ".getAir end!");

		return rList;
	}

}
