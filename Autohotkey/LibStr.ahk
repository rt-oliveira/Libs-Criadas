Minusculo(str){
    StringLower, strOutLower, str
    return strOutLower
}

EstaVazio(parStr){
    return (Trim(parStr) == "")
}

StrInicio(parStr, qtde){
    return SubStr(parStr, 1, qtde)
}

SanitizarTexto(formato, texto){
	switch (formato){
		case ",.":				
			texto	:=	StrReplace(texto, ",", ".")
		case "ListNumbers":
			texto		:=	RegExReplace(texto, "[^-+0-9.,\n]")
			texto		:=	StrReplace(texto, "`n`n", "`n")
			texto		:=	Trim(texto, " ")
		case "RealSemMilhar":	
			texto	:=	RegExReplace(texto, "[^-+0-9.]")
		case "Real":			
			texto	:=	RegexReplace(texto, "[^-+0-9.,\n]")
		case "UInteiro":		
			texto	:=	RegexReplace(texto, "[^\d]", "")
        case "UReal":			
			texto	:=	RegExReplace(texto, "[^\d.]")
		default:				
			throw "Tipo não suportado: " . formato
	}
	;
	return texto
}

EstaTudoPreenchido(dados*){
	for indice, valor in dados
	{
		if (valor.__Class == "CEditControl"){
			if (EstaVazio(valor.Text))
				return False
		} else {
			if (EstaVazio(valor))
				return False
		}
	}
	;
	return True
}

HaAlgoPreenchido(dados*){
	for indice, valor in dados
	{
		if (valor.__Class == "CEditControl"){
			if (!EstaVazio(valor.Text))
				return True
		} else {
			if (!EstaVazio(valor))
				return True
		}
	}
	return False
}

EstaPreenchido(parStr){
	return !EstaVazio(parStr)
}

InputDadosCLI(){
	FileReadLine, digitado, *, 1
	return digitado
}