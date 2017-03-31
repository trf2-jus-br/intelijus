package br.jus.trf2.intelijus;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.crivano.swaggerservlet.SwaggerUtils;

import br.jus.trf2.intelijus.IIntelijus.ISugestaoPost;
import br.jus.trf2.intelijus.IIntelijus.SugestaoPostRequest;
import br.jus.trf2.intelijus.IIntelijus.SugestaoPostResponse;

public class SugestaoPost implements ISugestaoPost {
	private static final Logger log = LoggerFactory.getLogger(SugestaoPost.class);

	@Override
	public void run(SugestaoPostRequest req, SugestaoPostResponse resp) throws Exception {
		StringBuilder sb = new StringBuilder();
		sb.append("Nome: ");
		sb.append(req.nome);
		sb.append("\nEmail: ");
		sb.append(req.email);
		sb.append("\n\nMensagem: ");
		sb.append(req.mensagem);
		Correio.enviar(
				SwaggerUtils.getRequiredProperty("intelijus.smtp.destinatario",
						"Não foi especificado o destinatário do email de sugestões.", false),
				SwaggerUtils.getProperty("intelijus.smtp.assunto", "Intelijus: Sugestão"), sb.toString());
	}

	@Override
	public String getContext() {
		return "enviar sugestao";
	}

}
