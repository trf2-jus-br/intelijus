package br.jus.trf2.intelijus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.jus.trf2.intelijus.IIntelijus.IOrgaosGet;
import br.jus.trf2.intelijus.IIntelijus.Orgao;
import br.jus.trf2.intelijus.IIntelijus.OrgaosGetRequest;
import br.jus.trf2.intelijus.IIntelijus.OrgaosGetResponse;

public class OrgaosGet implements IOrgaosGet {
	private static final Logger log = LoggerFactory.getLogger(OrgaosGet.class);

	@Override
	public void run(OrgaosGetRequest req, OrgaosGetResponse resp)
			throws Exception {
		resp.list = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		try {
			conn = Utils.getConnection();
			pstmt = conn.prepareStatement(Utils.getSQL("orgaos"));
			rset = pstmt.executeQuery();

			while (rset.next()) {
				Orgao o = new Orgao();
				o.codigo = rset.getString("CODIGO");
				o.nome = rset.getString("NOME");
				o.descricao = rset.getString("DESCRICAO");
				resp.list.add(o);
			}
		} finally {
			if (rset != null)
				rset.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}

	}

	@Override
	public String getContext() {
		return "listar órgãos";
	}

}
