ConcatenarCaminho(comBarraEntrePartes, partesCaminho*){
	tmpCaminho		:=	""
	;
	for indice, valor in partesCaminho
	{
		if ( (indice != 1) and comBarraEntrePartes)
			tmpCaminho	.=	"\"
		tmpCaminho	.=	valor
	}
	;
	tmpCaminho	:=	StrReplace(tmpCaminho, "\\", "\")
	return tmpCaminho
}

NomeArquivo(caminhoArquivo, comExtensao){
    if (comExtensao)
        SplitPath, caminhoArquivo, nomeArquivo
    else
        SplitPath, caminhoArquivo, , , , nomeArquivo
    ;
    return nomeArquivo
}

ExtensaoArquivo(caminhoArquivo){
    SplitPath, caminhoArquivo, , , extensao
    return extensao
}

CriarArquivo(caminhoArquivo, encoding := "UTF-8-RAW"){
    if (!FileExist(caminhoArquivo))
		FileAppend, , %caminhoArquivo%, %encoding%
}

RecuperarCaminhoAbsoluto(caminho){
	cc	:=	DllCall("GetFullPathName", "str", caminho, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", caminho, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}

LerIni(arquivo, secao, chave := False, padrao := " "){
    if (chave = False) {
        IniRead, tmpOut, % arquivo, % secao
        tmpOut  :=  StrSplit(tmpOut, "`n")
        ;
        for indice in tmpOut
            tmpOut[indice]  :=  StrSplit(tmpOut[indice], "=", , 2)
        ;
        return tmpOut
    }
    else { 
        IniRead, tmpOut, % arquivo, % secao, % chave, % padrao
        return tmpOut
    }
}

EscreverIni(valor, arquivo, secao, chave){
	IniWrite, % valor, % arquivo, % secao, % chave
	Return ErrorLevel
}

DiretorioArquivo(arquivo){
    SplitPath, arquivo, , diretorio
    return diretorio
}

MoverArquivo(origem, destino, ehParaSobrescrever := False){
	FileMove, %origem%, %destino%, %ehParaSobrescrever%
	return !ErrorLevel
}

CriarDiretorio(diretorio){
    FileCreateDir, % diretorio
    ;
    if (ErrorLevel = 1)
        return False
    else
        return True
}

EhDiretorio(caminho){
	return InStr(FileExist(caminho), "D")
}