package br.jus.trf2.intelijus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.jus.trf2.intelijus.IIntelijus.IOrgaoOrgaoUnidadesGet;
import br.jus.trf2.intelijus.IIntelijus.OrgaoOrgaoUnidadesGetRequest;
import br.jus.trf2.intelijus.IIntelijus.OrgaoOrgaoUnidadesGetResponse;
import br.jus.trf2.intelijus.IIntelijus.Unidade;

public class OrgaoOrgaoUnidadesGet implements IOrgaoOrgaoUnidadesGet {
	private static final Logger log = LoggerFactory
			.getLogger(OrgaoOrgaoUnidadesGet.class);

	@Override
	public void run(OrgaoOrgaoUnidadesGetRequest req,
			OrgaoOrgaoUnidadesGetResponse resp) throws Exception {
		resp.list = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		try {
			conn = Utils.getConnection();
			pstmt = conn.prepareStatement(Utils.getSQL("unidades"));
			pstmt.setInt(1, Integer.valueOf(req.orgao));
			rset = pstmt.executeQuery();

			while (rset.next()) {
				Unidade o = new Unidade();
				o.codigo = rset.getString("CODIGO");
				o.descricao = rset.getString("DESCRICAO");
				o.nome = rset.getString("NOME");
				// o.localidade = rset.getString("LOCALIDADE");
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
		return "listar unidades";
	}

}
