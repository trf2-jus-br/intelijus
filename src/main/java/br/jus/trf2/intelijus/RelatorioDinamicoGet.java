package br.jus.trf2.intelijus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.jus.trf2.intelijus.IIntelijus.IRelatorioDinamicoGet;
import br.jus.trf2.intelijus.IIntelijus.LinhaRelatorioDinamico;
import br.jus.trf2.intelijus.IIntelijus.RelatorioDinamicoGetRequest;
import br.jus.trf2.intelijus.IIntelijus.RelatorioDinamicoGetResponse;
import br.jus.trf2.intelijus.IIntelijus.Unidade;

public class RelatorioDinamicoGet implements IRelatorioDinamicoGet {
	private static final Logger log = LoggerFactory.getLogger(RelatorioDinamicoGet.class);

	@Override
	public void run(RelatorioDinamicoGetRequest req, RelatorioDinamicoGetResponse resp) throws Exception {
		resp.list = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		try {
			conn = Utils.getConnection();
			pstmt = conn.prepareStatement(Utils.getSQL("estatistica_processual"));
			rset = pstmt.executeQuery();

			while (rset.next()) {
				LinhaRelatorioDinamico o = new LinhaRelatorioDinamico();
				o.orgao = rset.getString("espr_sg_orgao");
				o.unidade = rset.getString("espr_sg_unidade");
				o.ano = rset.getDouble("espr_nr_ano");
				o.tipoMovimentacao = rset.getString("espr_tp_movimentacao");
				o.quantidade = rset.getDouble("espr_qt_processo");
				o.coletivo = rset.getString("espr_tp_coletivo");
				// o.classe = rset.getString("espr_sg_classe");
				o.natureza = rset.getString("espr_sg_natureza");
				// String assunto = rset.getString("espr_sg_assunto_principal");
				// if (assunto != null && !assunto.equals("9-OUTROS"))
				// o.assuntoPrincipal = assunto.substring(2);
				o.instancia = rset.getString("espr_tp_instancia");
				o.tipoUnidade = rset.getString("espr_tp_unidade");
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
		return "listar estatísticas processuais";
	}

}
