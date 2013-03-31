package c_gh.maxymania.gaecms.fileservice;

import java.util.Date;

import com.google.appengine.api.blobstore.BlobKey;

public class FilesFile {
	public String name;
	public BlobKey key;
	public Date created;
	public String mimeType;
	public String md5hash;
	public long size;
}
