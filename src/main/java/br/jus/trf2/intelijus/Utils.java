package br.jus.trf2.intelijus;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Scanner;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NameNotFoundException;
import javax.sql.DataSource;

import com.crivano.swaggerservlet.SwaggerUtils;

public class Utils {

	public static Connection getConnection() throws Exception {
		try {
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:");
			DataSource ds = (DataSource) envContext.lookup("java:/jboss/datasources/IntelijusDS");
			Connection connection = ds.getConnection();
			if (connection == null)
				throw new Exception("Can't open connection to Oracle.");
			return connection;
		} catch (NameNotFoundException nnfe) {
			Connection connection = null;

			Class.forName("oracle.jdbc.OracleDriver");

			String dbURL = SwaggerUtils.getProperty("intelijus.datasource.url", null);
			String username = SwaggerUtils.getProperty("intelijus.datasource.username", null);
			String password = SwaggerUtils.getProperty("intelijus.datasource.password", null);
			connection = DriverManager.getConnection(dbURL, username, password);
			if (connection == null)
				throw new Exception("Can't open connection to Oracle.");
			PreparedStatement pstmt = null;
			try {
				pstmt = connection.prepareStatement(getSQL("altersession"));
				pstmt.execute();
			} finally {
				if (pstmt != null)
					pstmt.close();
			}
			return connection;
		}
	}

	public static String getSQL(String filename) {
		String text = new Scanner(IntelijusServlet.class.getResourceAsStream(filename + ".sql"), "UTF-8")
				.useDelimiter("\\A").next();
		return text;
	}
}
