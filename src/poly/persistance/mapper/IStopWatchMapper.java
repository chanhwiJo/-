package poly.persistance.mapper;

import java.util.List;

import config.Mapper;
import poly.dto.StopWatchDTO;

@Mapper("StopWatchMapper")
public interface IStopWatchMapper {

	// 시간 저장
	int saveTime(StopWatchDTO pDTO);
	
	// 시간 분석
	List<StopWatchDTO> getTimeData(String user_no) throws Exception;
	
}
