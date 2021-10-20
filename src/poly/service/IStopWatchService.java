package poly.service;

import java.util.List;

import poly.dto.StopWatchDTO;

public interface IStopWatchService {

	// 시간 저장
	int saveTime(StopWatchDTO pDTO);
		
	// 시간 분석
	List<StopWatchDTO> getTimeData(String user_no) throws Exception;
	
}
