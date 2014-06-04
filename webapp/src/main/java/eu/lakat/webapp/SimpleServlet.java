package eu.lakat.webapp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by matelakat on 04/06/14.
 */
public class SimpleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getRequestURL().toString();

        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        if(url.endsWith("PING")) {
            out.print("OK");
        }

        if(url.endsWith("BRANCH1")) {
            out.print("BRANCH1");
        }

        if(url.endsWith("BRANCH2")) {
            out.print("BRANCH2");
        }
    }
}
