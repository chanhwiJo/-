package poly.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import poly.persistance.mongo.ICalMapper;
import poly.service.ICalService;

@Service("CalService")
public class CalService implements ICalService {
	
	@Resource(name = "CalMapper")
	private ICalMapper calMapper;
	
	/*
	 * <Dday>
	*/
	@Override
	public int DdaySet(Map<String, String> rMap) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.DdaySet(rMap);
	}

	@Override
	public List<Map<String, String>> DdayGet(String user_id) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.DdayGet(user_id);
	}

	@Override
	public int deldday(String user_id, String id) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.deldday(user_id, id);
	}
	
	/*
	 * <Memo>
	*/
	
	@Override
	public int memoSet(Map<String, String> rMap) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.memoSet(rMap);
	}

	@Override
	public List<Map<String, String>> memoGet(String user_id) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.memoGet(user_id);
	}

	@Override
	public int delmemo(String user_id, String id) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.delmemo(user_id, id);
	}
	
	
	/*
	 * <Schedule>
	*/

	@Override
	public List<Map<String, Object>> getSchedule(String user_id) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.getSchedule(user_id);
	}

	@Override
	public int delSchedule(String user_id, String _id) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.delSchedule(user_id, _id);
	}

	@Override
	public int updateSchedule(String user_id, Map<String, Object> rMap) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.updateSchedule(user_id, rMap);
	}

	@Override
	public int addSchedule(String user_id, Map<String, Object> rMap) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.addSchedule(user_id, rMap);
	}

	@Override
	public int DropSchedule(String user_id, Map<String, Object> rMap) throws Exception {
		// TODO Auto-generated method stub
		return calMapper.DropSchedule(user_id, rMap);
	}

}
