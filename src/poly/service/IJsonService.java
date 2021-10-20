package poly.service;

import java.util.List;

import poly.dto.AirDTO;
import poly.dto.WeatherDTO;

public interface IJsonService {

	// 날씨 정보 수집하기
	public int weatherInformation() throws Exception;

	// 대기 정보 수집하기
	public int airInformation() throws Exception;

	// 날씨 데이터 조회
	public List<WeatherDTO> getWeather() throws Exception;

	// 대기 데이터 조회
	public List<AirDTO> getAir() throws Exception;

}
