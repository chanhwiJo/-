package poly.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import poly.dto.StopWatchDTO;
import poly.persistance.mapper.IStopWatchMapper;
import poly.service.IStopWatchService;

@Service("StopWatchService")
public class StopWatchService implements IStopWatchService{
	
	@Resource(name="StopWatchMapper")
	private IStopWatchMapper stopWatchMapper;

	// 시간 저장
	@Override
	public int saveTime(StopWatchDTO pDTO) {
		return stopWatchMapper.saveTime(pDTO);
	}

	// 시간 데이터 분석
	@Override
	public List<StopWatchDTO> getTimeData(String user_no) throws Exception {
		return stopWatchMapper.getTimeData(user_no);
	}


	
}
