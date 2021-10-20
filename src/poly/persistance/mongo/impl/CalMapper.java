package poly.persistance.mongo.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import org.apache.log4j.Logger;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;

import poly.persistance.mongo.ICalMapper;
import poly.persistance.mongo.comm.AbstractMongoDBComon;
import poly.util.CmmUtil;

@Component("CalMapper")
public class CalMapper extends AbstractMongoDBComon implements ICalMapper {

	@Autowired
	private MongoTemplate mongodb;

	private Logger log = Logger.getLogger(this.getClass());

	/*
	 * <D-day>
	*/
	
	@Override
	public int DdaySet(Map<String, String> rMap) throws Exception {
		log.info(this.getClass().getName()+ ".DdaySet Start");
		
		if(rMap == null) {
			rMap = new HashMap<String, String>();
		}
		
		//컬렉션 명 제작
		String colNm = rMap.get("User_id")+"_Dday";
		
		// 데이터를 저장할 컬렉션 생성
		super.createCollection(colNm);
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		Document insertDoc = new Document();

		insertDoc.append("title", rMap.get("title"));
		insertDoc.append("date", rMap.get("date"));
		
		col.insertOne(insertDoc);
		
		rMap = null;
		col = null;
		
		log.info(this.getClass().getName()+ ".DdaySet End");
		return 1;
	}

	@Override
	public List<Map<String, String>> DdayGet(String user_id) throws Exception {
		log.info(this.getClass().getName()+ ".DdayGet Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_Dday";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		//데이터 저장 리스트
		List<Map<String, String>> rList = new LinkedList<Map<String, String>>();
		
		Document query = new Document();
		
		Document projection = new Document();
		projection.append("title", "$title");
		projection.append("date", "$date");
        projection.append("_id", "$_id");

        Consumer<Document> processBlock = document -> {

            String title = CmmUtil.nvl(document.getString("title"));
            String date = CmmUtil.nvl(document.getString("date"));
            String id = CmmUtil.nvl(document.get("_id").toString());

            Map<String, String> rMap = new LinkedHashMap<>();

            rMap.put("title", title);
            rMap.put("date", date);
            rMap.put("id", id);

            // 레코드 결과를 List에 저장하기
            rList.add(rMap);

        };

        col.find(query).projection(projection).forEach(processBlock);
        
		
		log.info(this.getClass().getName()+ ".DdayGet End");
		return rList;
	}
	
	@Override
	public int deldday(String user_id, String id) {
		
    log.info(this.getClass().getName()+ ".Deldday Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_Dday";
		
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		DeleteResult deleteResult =  col.deleteMany(new Document("_id", new ObjectId(id)));
		int res = (int) deleteResult.getDeletedCount();
		log.info("지워진 개수 :: " +res);
		
		log.info(this.getClass().getName()+ ".deldday End");
		
		return res;
	}

	/*
	 * <Memo>
	*/
	
	@Override
	public int memoSet(Map<String, String> rMap) throws Exception {
		log.info(this.getClass().getName()+ ".memoSet Start");
		
		if(rMap == null) {
			rMap = new HashMap<String, String>();
		}
		
		//컬렉션 명 제작
		String colNm = rMap.get("User_id")+"_memo";
		
		// 데이터를 저장할 컬렉션 생성
		super.createCollection(colNm);
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		Document insertDoc = new Document();

		insertDoc.append("title", rMap.get("title"));
		insertDoc.append("desc", rMap.get("desc"));
		
		col.insertOne(insertDoc);
		
		rMap = null;
		col = null;
		
		log.info(this.getClass().getName()+ ".memoSet End");
		return 1;
	}

	
	@Override
	public List<Map<String, String>> memoGet(String user_id) throws Exception {
		log.info(this.getClass().getName()+ ".memoGet Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_memo";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		//데이터 저장 리스트
		List<Map<String, String>> rList = new LinkedList<Map<String, String>>();
		
		Document query = new Document();
		
		Document projection = new Document();
		projection.append("title", "$title");
		projection.append("desc", "$desc");
        projection.append("_id", "$_id");

        Consumer<Document> processBlock = document -> {

            String title = CmmUtil.nvl(document.getString("title"));
            String desc = CmmUtil.nvl(document.getString("desc"));
            String _id = CmmUtil.nvl(document.get("_id").toString());

            Map<String, String> rMap = new LinkedHashMap<>();

            rMap.put("title", title);
            rMap.put("desc", desc);
            rMap.put("id", _id);

            // 레코드 결과를 List에 저장하기
            rList.add(rMap);

        };

        col.find(query).projection(projection).forEach(processBlock);
        
		
		log.info(this.getClass().getName()+ ".memoGet End");
		return rList;
	}
	

	@Override
	public int delmemo(String user_id, String id) throws Exception {
		log.info(this.getClass().getName()+ ".delmemo Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_memo";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		DeleteResult deleteResult =  col.deleteMany(new Document("_id", new ObjectId(id)));
		int res = (int) deleteResult.getDeletedCount();
		
		log.info("지워진 개수 :: " +res);
		
		log.info(this.getClass().getName()+ ".delmemo End");
		
		return res;
	}

	
	
	
	
	
	
	

	
	/*
	 * <Schedule>
	*/
	
	@Override
	public List<Map<String, Object>> getSchedule(String user_id) throws Exception {
		
		log.info(this.getClass().getName()+ ".getSchedule Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_sch";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		//데이터 저장 리스트
		List<Map<String, Object>> rList = new LinkedList<Map<String, Object>>();
		
		Document query = new Document();
		
		Document projection = new Document();
		projection.append("title", "$title");
		projection.append("description", "$description");
		projection.append("start", "$start");
		projection.append("end", "$end");
		projection.append("type", "$type");
		projection.append("backgroundColor", "$backgroundColor");
		projection.append("allDay", "$allDay");
        projection.append("_id", "$_id");

        Consumer<Document> processBlock = document -> {

            String title = CmmUtil.nvl(document.getString("title"));
            String description = CmmUtil.nvl(document.getString("description"));
            String start = CmmUtil.nvl(document.getString("start"));
            String end = CmmUtil.nvl(document.getString("end"));
            String type = CmmUtil.nvl(document.getString("type"));
            String backgroundColor = CmmUtil.nvl(document.getString("backgroundColor"));
            boolean allDay = (boolean) document.get("allDay");
            String _id = CmmUtil.nvl(document.get("_id").toString());

            Map<String, Object> rMap = new LinkedHashMap<>();

            rMap.put("user_id", user_id);
            rMap.put("title", title);
            rMap.put("description", description);
            rMap.put("start", start);
            rMap.put("end", end);
            rMap.put("type", type);
            rMap.put("backgroundColor", backgroundColor);
            rMap.put("allDay", allDay);
            rMap.put("_id", _id);

            // 레코드 결과를 List에 저장하기
            rList.add(rMap);
        };

        col.find(query).projection(projection).forEach(processBlock);
		
		log.info(this.getClass().getName()+ ".getSchedule End");
		
		return rList;
	}

	/*
	 * <Schedule Delete> 
	*/
	@Override
	public int delSchedule(String user_id, String id) throws Exception {
		
		log.info(this.getClass().getName()+ ".delSchedule Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_sch";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		DeleteResult deleteResult =  col.deleteMany(new Document("_id", new ObjectId(id)));
		int res = (int) deleteResult.getDeletedCount();
		
		log.info("지워진 개수 :: " +res);
		
		log.info(this.getClass().getName()+ ".delSchedule End");
		
		return res;
	}

	/*
	 * <Schedule UpDate> 
	*/
	
	@Override
	public int updateSchedule(String user_id, Map<String, Object> rMap) throws Exception {
		log.info(this.getClass().getName()+ ".updateSchedule Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_sch";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		Document findQuery = new Document();
        findQuery.append("_id", new ObjectId(rMap.get("_id").toString()));
        
        Document updateQuery = new Document();
        updateQuery.append("user_id", rMap.get("user_id"));
        updateQuery.append("allDay", Boolean.valueOf(rMap.get("allDay").toString()));
        updateQuery.append("title", rMap.get("title"));
        updateQuery.append("start", rMap.get("start"));
        updateQuery.append("end", rMap.get("end"));
        updateQuery.append("type", rMap.get("type"));
        updateQuery.append("backgroundColor", rMap.get("backgroundColor"));
        updateQuery.append("description", rMap.get("description"));

        UpdateResult updateResults = col.updateOne(findQuery, new Document("$set", updateQuery));
        int res = (int) updateResults.getMatchedCount();
        log.info("res : " + res);
        
        
		log.info(this.getClass().getName()+ ".updateSchedule End");
		
		return res;
	}
	
	/*
	 * <Schedule Drop> 
	*/
	
	@Override
	public int DropSchedule(String user_id, Map<String, Object> rMap) throws Exception {
		log.info(this.getClass().getName()+ ".DropSchedule Start");

		//컬렉션 명 제작
		String colNm = user_id+"_sch";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		Document findQuery = new Document();
        findQuery.append("_id", new ObjectId(rMap.get("_id").toString()));
        
        Document updateQuery = new Document();
        updateQuery.append("start", rMap.get("start"));
        updateQuery.append("end", rMap.get("end"));

        UpdateResult updateResults = col.updateOne(findQuery, new Document("$set", updateQuery));
        int res = (int) updateResults.getMatchedCount();
        log.info("res : " + res);
        
		log.info(this.getClass().getName()+ ".DropSchedule End");
		
		return res;
	}
	
	
	/*
	 * <Schedule ADD> 
	*/
	
	@Override
	public int addSchedule(String user_id, Map<String, Object> rMap) throws Exception {
		log.info(this.getClass().getName()+ ".addSchedule Start");
		
		//컬렉션 명 제작
		String colNm = user_id+"_sch";
		
		// 저장할 컬렉션 객체 생성
		MongoCollection<Document> col = mongodb.getCollection(colNm);
		
		rMap.put("allDay", Boolean.valueOf(rMap.get("allDay").toString()));
		
		col.insertOne(new Document(rMap));
        
		log.info(this.getClass().getName()+ ".addSchedule End");
		
		return 1;
	}


}
