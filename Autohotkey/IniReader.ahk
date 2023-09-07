#Include, <LibArquivos>

class IniReader {
    ; Constantes sobre ler mais de uma vez a mesma chave na mesma seção
    static LerSomenteAPrimeiraVez              :=  1
    static FicarSomenteComAUltimaOcorrencia    :=  2
    static LerTodasAsOcorrencias               :=  3
    ;
    ; Variáveis
    caminhoCompleto                     :=  ""
    conteudo                            :=  {}
	existeArquivo						:=	""
	criarArquivoSeNaoExiste				:=	False
	houveramMudancas					:=	False
	flagRepeticaoChaveValor				:=	0

    __New(caminhoArqIni
        , retiraEspacosEmBrancoDoValor      :=  True
        , retiraAspasNoInicioENoFimDoValor  :=  False
        , criarArquivoSeNaoExiste           :=  False
        , permitirMaisDeUmValorNaMesmaChave :=  1){
        ;
        caminhoCompleto         		:=  RecuperarCaminhoAbsoluto(caminhoArqIni)
		;
		this.caminhoArqIni  			:=  caminhoCompleto
		this.criarArquivoSeNaoExiste	:=	criarArquivoSeNaoExiste
		this.existeArquivo				:=	FileExist(caminhoCompleto)
		this.flagRepeticaoChaveValor	:=	permitirMaisDeUmValorNaMesmaChave
		if (!this.existeArquivo and !this.criarArquivoSeNaoExiste)
			throw Exception("O arquivo """ . this.caminhoArqIni . """ não existe!")
        ;
        if (    permitirMaisDeUmValorNaMesmaChave != IniReader.LerSomenteAPrimeiraVez
            and permitirMaisDeUmValorNaMesmaChave != IniReader.FicarSomenteComAUltimaOcorrencia
            and permitirMaisDeUmValorNaMesmaChave != IniReader.LerTodasAsOcorrencias)
            throw Exception("Parâmetro de leitura de mais de um valor na mesma seção/chave inválido: " . permitirMaisDeUmValorNaMesmaChave)
        ;
		if (this.existeArquivo)
        	this._CarregarIni(retiraEspacosEmBrancoDoValor
							, retiraAspasNoInicioENoFimDoValor
							, permitirMaisDeUmValorNaMesmaChave)
    }

    _CarregarIni(flagRetirarEspacosValor, flagRetirarAspasValor, flagRepeticaoChaveValor){
		secaoAtual			:=	""
		chaveAtual			:=	""
		valorAtual			:=	""
		;
        FileRead, conteudoArquivo, % this.caminhoArqIni
		if (ErrorLevel)
			return False
		;
        Loop, Parse, conteudoArquivo, `n, `r
        {
            linha           :=  A_LoopField
			if (!this._EhLinhaValida(linha))
				Continue
			;
			if (this._EhLinhaDeSecao(linha, secaoAtual))
				Continue
			;
			this._ExtrairChaveValor(linha, chaveAtual, valorAtual, flagRetirarEspacosValor, flagRetirarAspasValor)
			this._GuardarParChaveValor(secaoAtual, chaveAtual, valorAtual, flagRepeticaoChaveValor)
        }
		;
		return True
    }

	EscreverChaveValor(secao, chave, valor){
		this._GuardarParChaveValor(secao, chave, valor, this.flagRepeticaoChaveValor)
		this.houveramMudancas			:=	True
	}

	ExisteSecao(secao){
		return this.conteudo.HasKey(secao)
	}

	RecuperarSecao(secao){
		conteudoSecao		:=	""
		;
		for chave, valor in this.conteudo[secao]
		{
			conteudoSecao	.=	chave . "=" . valor . "`n"
		}
		return conteudoSecao
	}

	RecuperarSecoes(){
		secoes		:=	""
		;
		for secao in this.conteudo
		{
			secoes	.=	secao . "`n"
		}
		return secoes
	}

	RecuperarChaveValor(secao, chave, padrao := "ERROR"){
		if (this.conteudo[secao].HasKey(chave))
			return this.conteudo[secao][chave]
		else
			return padrao
	}

	_GuardarParChaveValor(secao, chave, valor, flagRepeticao){
		if (this.conteudo[secao].HasKey(chave)){
			;
			switch (flagRepeticao)
			{
				case IniReader.LerSomenteAPrimeiraVez:
					return
					;
				case IniReader.FicarSomenteComAUltimaOcorrencia:
					this.conteudo[secao][chave]		:=	valor
					;
				case IniReader.LerTodasAsOcorrencias:
					if (!IsObject(this.conteudo[secao][chave]))
						this.conteudo[secao][chave]	:=	[this.conteudo[secao][chave], valor]
					else
						this.conteudo[secao][chave].Push(valor)
			}
			;
		} else {
			;
			if (!this.conteudo.HasKey(secao))
				this.conteudo[secao]			:=	{}
			this.conteudo[secao][chave]			:=	valor
			;
		}
	}

	_ExtrairChaveValor(linha, byref chaveAtual, byref valorAtual, flagRetirarEspacosValor, flagRetirarAspasValor){
		posicaoDelimitadorLinha		:=	InStr(linha, "=")
		chaveAtual					:=	Trim(SubStr(linha, 1, posicaoDelimitadorLinha-1))
		valorAtual					:=	SubStr(linha, posicaoDelimitadorLinha+1)
		;
		if (flagRetirarEspacosValor)
			this._LimparEspacosValor(valorAtual)
		;
		if (flagRetirarAspasValor)
			this._RemoverAspasDoValor(valorAtual)
	}

	_RemoverAspasDoValor(byref valor){
		primeiroEUltimoCaractereValor	:=	SubStr(valor, 1, 1) . SubStr(valor, 0)
		if (primeiroEUltimoCaractereValor == """""" or primeiroEUltimoCaractereValor == "''")
			valor						:=	SubStr(valor, 2, -1)
	}

	_LimparEspacosValor(byref valor){
		valor			:=	Trim(valor)
	}

	_EhLinhaDeSecao(linha, byref novaSecao){
		regexSecao		:=	"^\s*\[.*\]\s*$"
		;
		if (RegexMatch(linha, regexSecao, secao)){
			novaSecao	:=	SubStr(secao, 2, -1)
			return True
		} else
			return False
	}

	_EhLinhaValida(linha){
		; Se é linha vazia, nem faz nada
		if (Trim(linha) == "")
			return False
		;
		; Se é linha de comentário, nem faz nada
		if (SubStr(Trim(linha), 1, 1) == ";")
			return False
		;
		return True
	}

	__Delete(){
		this.SalvarIni()
	}

	SalvarIni(){
		if (!this.houveramMudancas)
			return
		;
		if (this.existeArquivo) {
			FileDelete, % this.caminhoArqIni
			if (ErrorLevel)
				throw Exception("Erro ao salvar o arquivo ini: " . this.caminhoArqIni)
		}
		;
		this._EscreverLinha("", this.caminhoArqIni, "UTF-8-RAW")
		;
		for indice, valor in this.conteudo
		{
			this._EscreverLinha("[" . indice . "]`n", this.caminhoArqIni)
			for extensao, acao in valor
			{
				if (IsObject(acao))
					for indiceAcao, comando in acao
						this._EscreverLinha(extensao . "=" . comando . "`n", this.caminhoArqIni)
				else
					this._EscreverLinha(extensao . "=" . acao . "`n", this.caminhoArqIni)
			}
			this._EscreverLinha("`n", this.caminhoArqIni)
		}
		;
		this.houveramMudancas		:=	False
	}

	_EscreverLinha(conteudo, caminho, encoding := ""){
		if (encoding != "")
			FileAppend, %conteudo%, %caminho%, %encoding%
		else
			FileAppend, %conteudo%, %caminho%
		;
		if (ErrorLevel)
			throw Exception("Erro ao escrever no arquivo: " . caminho)
	}
}