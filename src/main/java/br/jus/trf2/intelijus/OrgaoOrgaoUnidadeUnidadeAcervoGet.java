package br.jus.trf2.intelijus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.jus.trf2.intelijus.IIntelijus.IOrgaoOrgaoUnidadeUnidadeAcervoGet;
import br.jus.trf2.intelijus.IIntelijus.Indicador;
import br.jus.trf2.intelijus.IIntelijus.OrgaoOrgaoUnidadeUnidadeAcervoGetRequest;
import br.jus.trf2.intelijus.IIntelijus.OrgaoOrgaoUnidadeUnidadeAcervoGetResponse;

public class OrgaoOrgaoUnidadeUnidadeAcervoGet implements
		IOrgaoOrgaoUnidadeUnidadeAcervoGet {
	private static final Logger log = LoggerFactory
			.getLogger(OrgaoOrgaoUnidadeUnidadeAcervoGet.class);

	@Override
	public void run(OrgaoOrgaoUnidadeUnidadeAcervoGetRequest req,
			OrgaoOrgaoUnidadeUnidadeAcervoGetResponse resp) throws Exception {
		resp.list = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		try {
			conn = Utils.getConnection();
			pstmt = conn.prepareStatement(Utils.getSQL("acervo"));
			pstmt.setInt(1, Integer.valueOf(req.orgao));
			pstmt.setInt(2, Integer.valueOf(req.unidade));
			rset = pstmt.executeQuery();

			while (rset.next()) {
				Indicador o = new Indicador();
				o.nome = rset.getString("NOME");
				o.descricao = rset.getString("DESCRICAO");
				o.valor = rset.getDouble("VALOR");
				o.memoriaDeCalculo = rset.getString("MEMORIA_DE_CALCULO");
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
		return "listar acervo";
	}

}
