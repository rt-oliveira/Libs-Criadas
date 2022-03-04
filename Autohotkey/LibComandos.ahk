#Include <Constantes>

MsgBox(msg, titulo := "", flags := 0){
	MsgBox % flags, % titulo, % msg
	;
	IfMsgBox, Yes
		return "Yes"
	else IfMsgBox, No
		return "No"
	else IfMsgBox, Cancel
		return "Cancel"
	else IfMsgBox, OK
		return "Ok"
	else IfMsgBox, Abort
		return "Abort"
	else IfMsgBox, Ignore
		return "Ignore"
	else IfMsgBox, Retry
		return "Retry"
}

MsgBoxErro(msg){
	MsgBox, % Constantes.ICONE_ERRO, % "Erro", % msg
}

EntreAspas(str){
	return ("""" . str . """")
}

GerarComando(comAspas, elementos*){
	strComando			:=	""
	for indice, valor in elementos
	{
		strComando		.=	valor
		if (indice != elementos.Length())
			strComando	.=	" "
	}
	;
	if (comAspas)
		strComando		:=	EntreAspas(strComando)
	;
	return strComando
}

CaixaEntradaDados(titulo, mensagem, largura := "", altura := "", comTrim := True){
	InputBox, outDigitado, % titulo, % mensagem, , % largura, % altura
	if (ErrorLevel)
		return False
	else {
		if (comTrim)
			return Trim(outDigitado)
		else
			return outDigitado
	}
}

CriarAtalho(destinoAtalho, localAtalho, argumentos := ""){
	FileCreateShortcut, % destinoAtalho, % localAtalho, , % argumentos
}

MostrarConteudoTelaAuxiliar(titulo, conteudo, largura := 500, altura := 300){
	;
	Gui, TelaAuxiliar:Font, s12, Courier New
	Gui, TelaAuxiliar:Add, Edit, ReadOnly w%largura% h%altura% VScroll, %conteudo%
	Gui, TelaAuxiliar:Show, , %titulo%
	Gui, TelaAuxiliar:+LastFound
	Gui, TelaAuxiliar:+OwnDialogs
	ControlSend, , ^{Home}
	WinWaitClose
	return
	
	TelaAuxiliarGuiEscape:
		Gui, TelaAuxiliar:Destroy
		return
	
	TelaAuxiliarGuiClose:
		Gui, TelaAuxiliar:Destroy
		return
}