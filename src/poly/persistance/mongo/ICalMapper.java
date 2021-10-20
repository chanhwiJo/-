package poly.persistance.mongo;

import java.util.List;
import java.util.Map;

public interface ICalMapper {
	
	/*
	 * <D-day>
	*/
	int DdaySet(Map<String, String> rMap)throws Exception;

	List<Map<String, String>> DdayGet(String user_id)throws Exception;
	
	int deldday(String user_id, String id)throws Exception;;
	
	/*
	 * <Memo>
	*/
	int memoSet(Map<String, String> rMap) throws Exception;
	
	List<Map<String, String>> memoGet(String user_id) throws Exception;
	
	int delmemo(String user_id, String id)throws Exception;
	
	/*
	 * <Schedule>
	*/
	List<Map<String, Object>> getSchedule(String user_id)throws Exception;

	int delSchedule(String user_id, String _id)throws Exception;

	int updateSchedule(String user_id, Map<String, Object> rMap)throws Exception;

	int addSchedule(String user_id, Map<String, Object> rMap)throws Exception;

	int DropSchedule(String user_id, Map<String, Object> rMap)throws Exception;


	
}
