package c_gh.maxymania.gaecms;

import com.google.appengine.api.datastore.Link;

public class Hlink {
	public String text;
	public String cat;
	public Link href;
	public String __id;
	public void set_href(String url){ href=new Link(url); }
}
