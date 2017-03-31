package br.jus.trf2.intelijus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.jus.trf2.intelijus.IIntelijus.IOrgaoOrgaoUnidadeUnidadeMetasNacionaisGet;
import br.jus.trf2.intelijus.IIntelijus.Indicador;
import br.jus.trf2.intelijus.IIntelijus.OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetRequest;
import br.jus.trf2.intelijus.IIntelijus.OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetResponse;

public class OrgaoOrgaoUnidadeUnidadeMetasNacionaisGet implements IOrgaoOrgaoUnidadeUnidadeMetasNacionaisGet {
	private static final Logger log = LoggerFactory.getLogger(OrgaoOrgaoUnidadeUnidadeMetasNacionaisGet.class);

	@Override
	public void run(OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetRequest req,
			OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetResponse resp) throws Exception {
		resp.list = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		try {
			conn = Utils.getConnection();
			pstmt = conn.prepareStatement(Utils.getSQL("metas"));
			pstmt.setInt(1, Integer.valueOf(req.orgao));
			pstmt.setInt(2, Integer.valueOf(req.unidade));
			rset = pstmt.executeQuery();

			while (rset.next()) {
				Indicador o = new Indicador();
				o.nome = rset.getString("NOME");
				o.descricao = rset.getString("DESCRICAO");
				o.valor = Double.valueOf(rset.getString("VALOR").replaceAll(",", "."));
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
		return "listar metas";
	}

}
