package c_gh.maxymania.gaecms.fileservice;

import java.util.Date;
import java.util.LinkedList;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;

public class Files {
	public static final String FILERES = "FileRsrc";
	private DatastoreService service;
	public Files(){
		service = DatastoreServiceFactory.getDatastoreService();
	}
	public static void serialize(Entity dest,FilesFile src){
		dest.setProperty("name", src.name);
		dest.setProperty("key", src.key);
		dest.setProperty("created", src.created);
		dest.setProperty("mimeType", src.mimeType);
		dest.setProperty("md5hash", src.md5hash);
		dest.setProperty("size", src.size);
	}
	public static void deserialize(FilesFile dest,Entity src){
		dest.name = (String)(src.getProperty("name"));
		dest.key = (BlobKey)(src.getProperty("key"));
		dest.created = (Date)(src.getProperty("created"));
		dest.mimeType = (String)(src.getProperty("mimeType"));
		dest.md5hash = (String)(src.getProperty("md5hash"));
		dest.size = (Long)(src.getProperty("size"));
	}
	public boolean storeFileHeader(FilesFile res){
		Key k = KeyFactory.createKey(FILERES, res.name);
		Entity e = new Entity(k);
		serialize(e,res);
		Transaction tr = service.beginTransaction();
		try {
			service.get(tr, k);
			tr.rollback();
			return false;
		} catch (EntityNotFoundException ex) {}
		service.put(tr, e);
		tr.commit();
		return true;
	}
	public FilesFile getFileHeader(String name){
		Key k = KeyFactory.createKey(FILERES, name);
		try {
			Entity e = service.get(k);
			FilesFile res = new FilesFile();
			deserialize(res,e);
			return res;
		} catch (Exception e) {
			return null;
		}
	}
	public Iterable<FilesFile> list(int max,int page){
		Query query = new Query(FILERES);
		query.addSort("created", Query.SortDirection.DESCENDING);
		FetchOptions fo = FetchOptions.Builder.withLimit(max).offset(max*page);
		LinkedList<FilesFile> files = new LinkedList<FilesFile>();
		try{
		for(Entity e:service.prepare(query).asIterable(fo)){
			FilesFile file = new FilesFile();
			deserialize(file,e);
			files.add(file);
		}
		}catch(Exception e){}
		return files;
	}
	public void delete(FilesFile file){
		service.delete(KeyFactory.createKey(FILERES, file.name));
	}
}
