package br.jus.trf2.intelijus;

import com.crivano.swaggerservlet.SwaggerTestSupport;

public class IntelijusServiceTest extends SwaggerTestSupport {

	@Override
	protected Class getAPI() {
		return IntelijusServlet.class;
	}

	@Override
	protected String getPackage() {
		// TODO Auto-generated method stub
		return "br.jus.trf2.intelijus";
	}

	public void testNothing_Simple_Success() {
		assertEquals("1", "1");
	}

}
