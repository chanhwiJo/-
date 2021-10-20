package poly.persistance.mongo;

import java.util.List;

import poly.dto.AirDTO;
import poly.dto.WeatherDTO;

public interface IJsonMapper {

	/**
	 * MongoDB 컬렉션 생성하기
	 * 
	 * @param colNm 생성하는 컬렉션 이름
	 */
	public boolean createCollection(String colNm) throws Exception;

	/**
	 * MongoDB 날씨 데이터 저장하기
	 * 
	 * @param pDTO 저장될 정보
	 */
	public int insertWeatherInformation(List<WeatherDTO> pList, String colNm) throws Exception;

	/**
	 * MongoDB 대기 데이터 저장하기
	 * 
	 * @param pDTO 저장될 정보
	 */
	public int insertAirInformation(List<AirDTO> pList, String colNm) throws Exception;

	// MongoDB 날씨 데이터 조회
	public List<WeatherDTO> getWeather(String colNm) throws Exception;

	// MongoDB 대기 데이터 조회
	public List<AirDTO> getAir(String colNm) throws Exception;
	
}
