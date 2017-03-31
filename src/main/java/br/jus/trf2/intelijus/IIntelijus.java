package br.jus.trf2.intelijus;

import java.util.List;

import com.crivano.swaggerservlet.ISwaggerMethod;
import com.crivano.swaggerservlet.ISwaggerModel;
import com.crivano.swaggerservlet.ISwaggerRequest;
import com.crivano.swaggerservlet.ISwaggerResponse;

public interface IIntelijus {
	public class Orgao implements ISwaggerModel {
		public String nome;
		public String descricao;
		public String codigo;
	}

	public class Unidade implements ISwaggerModel {
		public String nome;
		public String descricao;
		public String codigo;
		public String localidade;
	}

	public class Indicador implements ISwaggerModel {
		public String nome;
		public String descricao;
		public Double valor;
		public String memoriaDeCalculo;
	}

	public class LinhaRelatorioDinamico implements ISwaggerModel {
		public String orgao;
		public String instancia;
		public String tipoUnidade;
		public String unidade;
		public String natureza;
		public String tipoMovimentacao;
		public String classe;
		public String assuntoPrincipal;
		public String coletivo;
		public Double ano;
		public Double quantidade;
	}

	public class Error implements ISwaggerModel {
		public String error;
	}

	public class OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetRequest implements ISwaggerRequest {
		public String orgao;
		public String unidade;
	}

	public class OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetResponse implements ISwaggerResponse {
		public List<Indicador> list;
	}

	public interface IOrgaoOrgaoUnidadeUnidadeMetasNacionaisGet extends ISwaggerMethod {
		public void run(OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetRequest req,
				OrgaoOrgaoUnidadeUnidadeMetasNacionaisGetResponse resp) throws Exception;
	}

	public class OrgaoOrgaoUnidadeUnidadeMetasEspecificasGetRequest implements ISwaggerRequest {
		public String orgao;
		public String unidade;
	}

	public class OrgaoOrgaoUnidadeUnidadeMetasEspecificasGetResponse implements ISwaggerResponse {
		public List<Indicador> list;
	}

	public interface IOrgaoOrgaoUnidadeUnidadeMetasEspecificasGet extends ISwaggerMethod {
		public void run(OrgaoOrgaoUnidadeUnidadeMetasEspecificasGetRequest req,
				OrgaoOrgaoUnidadeUnidadeMetasEspecificasGetResponse resp) throws Exception;
	}

	public class OrgaoOrgaoUnidadeUnidadePendenciasGetRequest implements ISwaggerRequest {
		public String orgao;
		public String unidade;
	}

	public class OrgaoOrgaoUnidadeUnidadePendenciasGetResponse implements ISwaggerResponse {
		public List<Indicador> list;
	}

	public interface IOrgaoOrgaoUnidadeUnidadePendenciasGet extends ISwaggerMethod {
		public void run(OrgaoOrgaoUnidadeUnidadePendenciasGetRequest req,
				OrgaoOrgaoUnidadeUnidadePendenciasGetResponse resp) throws Exception;
	}

	public class OrgaoOrgaoUnidadeUnidadeProducaoGetRequest implements ISwaggerRequest {
		public String orgao;
		public String unidade;
	}

	public class OrgaoOrgaoUnidadeUnidadeProducaoGetResponse implements ISwaggerResponse {
		public List<Indicador> list;
	}

	public interface IOrgaoOrgaoUnidadeUnidadeProducaoGet extends ISwaggerMethod {
		public void run(OrgaoOrgaoUnidadeUnidadeProducaoGetRequest req,
				OrgaoOrgaoUnidadeUnidadeProducaoGetResponse resp) throws Exception;
	}

	public class OrgaoOrgaoUnidadeUnidadeAcervoGetRequest implements ISwaggerRequest {
		public String orgao;
		public String unidade;
	}

	public class OrgaoOrgaoUnidadeUnidadeAcervoGetResponse implements ISwaggerResponse {
		public List<Indicador> list;
	}

	public interface IOrgaoOrgaoUnidadeUnidadeAcervoGet extends ISwaggerMethod {
		public void run(OrgaoOrgaoUnidadeUnidadeAcervoGetRequest req, OrgaoOrgaoUnidadeUnidadeAcervoGetResponse resp)
				throws Exception;
	}

	public class OrgaoOrgaoUnidadesGetRequest implements ISwaggerRequest {
		public String orgao;
	}

	public class OrgaoOrgaoUnidadesGetResponse implements ISwaggerResponse {
		public List<Unidade> list;
	}

	public interface IOrgaoOrgaoUnidadesGet extends ISwaggerMethod {
		public void run(OrgaoOrgaoUnidadesGetRequest req, OrgaoOrgaoUnidadesGetResponse resp) throws Exception;
	}

	public class OrgaosGetRequest implements ISwaggerRequest {
	}

	public class OrgaosGetResponse implements ISwaggerResponse {
		public List<Orgao> list;
	}

	public interface IOrgaosGet extends ISwaggerMethod {
		public void run(OrgaosGetRequest req, OrgaosGetResponse resp) throws Exception;
	}

	public class RelatorioDinamicoGetRequest implements ISwaggerRequest {
	}

	public class RelatorioDinamicoGetResponse implements ISwaggerResponse {
		public List<LinhaRelatorioDinamico> list;
	}

	public interface IRelatorioDinamicoGet extends ISwaggerMethod {
		public void run(RelatorioDinamicoGetRequest req, RelatorioDinamicoGetResponse resp) throws Exception;
	}

	public class SugestaoPostRequest implements ISwaggerRequest {
		public String nome;
		public String email;
		public String mensagem;
	}

	public class SugestaoPostResponse implements ISwaggerResponse {
		public String status;
	}

	public interface ISugestaoPost extends ISwaggerMethod {
		public void run(SugestaoPostRequest req, SugestaoPostResponse resp) throws Exception;
	}

}