package c_gh.maxymania.gaecms.fileservice;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ServeFiles extends HttpServlet {
	private static final long serialVersionUID = 9051861042905649942L;
	private Files files = new Files();
	private Blobs blobs = new Blobs();
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String s = req.getPathInfo();
		if(s==null){ resp.sendError(404); return; }
		blobs.deliverFile(files, s.substring(1), resp);
	}
}
