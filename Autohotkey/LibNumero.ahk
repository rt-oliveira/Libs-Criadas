#Include, <biga>
#Include, <LibStr>

FormatarNumero(numero, qtdCasasDecimais :=  6) {
    maxCasasDecimais    :=  6
    ;
    if (EstaVazio(numero))
        return numero
    else {
        numeroFormatado     :=  RegExReplace(numero, "(\G|[^\d.])\d{1,3}(?=(\d{3})+(\D|$))", "$0,")
        posicaoPonto        :=  InStr(numeroFormatado, ".")
        ;
        if (posicaoPonto){
			if (qtdCasasDecimais < 0)
				posicaoPonto	:=	StrLen(Biga.trimEnd(Biga.trimEnd(numeroFormatado, "0"), "."))
			else if (qtdCasasDecimais = 0)
				posicaoPonto--
			else
            	posicaoPonto    +=  qtdCasasDecimais
			;
            return StrInicio(numeroFormatado, posicaoPonto)
        } else {
			if (Biga.isNumber(qtdCasasDecimais) and qtdCasasDecimais > 0)
            	numeroFormatado .=  "." . Biga.repeat("0", qtdCasasDecimais)
            return numeroFormatado
        }
    }
}

TemNumerosValidos(ByRef numeros*){
	;
	copyNum	:=	[]
    for indice, valor in numeros
    {
		copyNum[indice] :=  TrataNumero(valor)
		;
        if (copyNum[indice] == "#ERRO")
            return False
    }
    ;
    return copyNum
}

TrataNumero(numero){
	;
	tmpNumero			:=	""
	;
	if (RegExMatch(numero, "^(-|\+)?\d+$"))
		tmpNumero		:=	numero
	else if (RegExMatch(numero, "^(\-|\+)?\d*\.\d*$"))
		tmpNumero		:=	numero
	else if (RegExMatch(numero, "^(\-|\+)?\d*,\d+$"))
		tmpNumero		:=	StrReplace(numero, ",", ".")
	else if (RegExMatch(numero, "^(-|\+)?\d+(,\d+)*(\.\d*)?$"))
		tmpNumero		:=	StrReplace(numero, ",", "")
	else if (RegExMatch(numero, "^(-|\+)?\d+(\.\d+)*(,\d*)?$"))
		tmpNumero		:=	StrReplace(StrReplace(numero, ".", ""), ",", ".")
	else
		return "#ERRO"
	;
	posicaoPonto	:=	InStr(tmpNumero, ".")
	if (posicaoPonto = 0)
		return Format("{:d}", tmpNumero)
	else {
		qtdCasasDecimais	:=	StrLen(SubStr(tmpNumero, posicaoPonto)) - 1
		return Format("{:." . qtdCasasDecimais . "f}", tmpNumero)
	}
}
