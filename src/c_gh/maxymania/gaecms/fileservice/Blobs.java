package c_gh.maxymania.gaecms.fileservice;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobInfo;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

public class Blobs {
	//SimpleDateFormat DATEPREFIX = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat DATEPREFIX = new SimpleDateFormat("yyyy-MM-dd-hhmmss");
	private BlobstoreService service;
	public Blobs(){
		service = BlobstoreServiceFactory.getBlobstoreService();
	}
	public String url(String successPath){
		return service.createUploadUrl(successPath);
	}
	public void storeFileInfos(Files files,HttpServletRequest request,boolean dateprefix){
		Map<String, List<BlobInfo>> map = service.getBlobInfos(request);
		for(List<BlobInfo> infos:map.values())
		for(BlobInfo info:infos)
		{
			FilesFile res = new FilesFile();
			String pre="";
			if(dateprefix){
				Date c = info.getCreation();
				pre = ""+DATEPREFIX.format(c)+"-";
			}
			res.name = pre+info.getFilename();
			res.created = info.getCreation();
			res.key = info.getBlobKey();
			res.mimeType = info.getContentType();
			res.md5hash = info.getMd5Hash();
			res.size = info.getSize();
			if(!files.storeFileHeader(res)) // if somethings goes wrong, delete the new one.
				service.delete(res.key);
		}
	}
	public void deliverFile(Files files,String name, HttpServletResponse response) throws IOException{
		FilesFile file = files.getFileHeader(name);
		if(file==null){
			response.sendError(404);
		}else{
			service.serve(file.key, response);
		}
	}
	public void delete(Files files,String name){
		FilesFile file = files.getFileHeader(name);
		if(file!=null){
			service.delete(file.key);
			files.delete(file);
		}
	}
}
