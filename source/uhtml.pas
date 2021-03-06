unit uhtml;

{$mode objfpc}{$H+}

interface
uses
  Classes, udmcontratos,  FileUtil, DbCtrls, Printers, IpHtml,
  Ipfilebroker, ExtCtrls,Dialogs, LCLType, ufiltragem, SysUtils, Controls, LCLIntf;




type
  Thtml = class
  private
    procedure testContrato(var textofinal, textoref : TStringlist; y : integer);
  public
    procedure editahtml;
  end;

const
  local = 'c:\temp\';//local de salvamento do contrato

var
  html: Thtml;

implementation

//prenche contrato em html
procedure Thtml.editahtml;
var
  textoref, textofinal : TStringList;
  y{, x} : integer;
  varlocal, varhorario, vardistribui: string;
  savedlg : TSaveDialog;
begin
    //inicializa variaveis
  varlocal:= '';
  varhorario:= '';
  vardistribui := '';

  //faz as filtragens necessarias
  filtragem.filtrads('codigo_cargo = '''+DMcontratos.dsContratos.DataSet.FieldByName('codigo_cargo').AsString +'''', 'dscargos');

  filtragem.filtrads('codigo_pessoa = '''+DMcontratos.dsContratos.DataSet.FieldByName('codigo_pessoa').AsString +'''', 'dspessoa');

  filtragem.filtrads('codigo_cidade = '''+DMcontratos.dspessoa.DataSet.FieldByName('codigo_cidade').AsString +'''', 'dscidades');

  filtragem.filtrads('codigo_contrato = '+ DMcontratos.dscontratos.DataSet.FieldByName('codigo_contrato').AsString, 'dscontratoslocais');
  //

  with DMcontratos.dscontratoslocais.DataSet do
  begin
    filtragem.filtrads('codigo_local_trabalho = '+ FieldByName('codigo_local_trabalho').AsString, 'dslocaltrabalho');

    varlocal := DMcontratos.dslocaltrabalho.DataSet.FieldByName('nome_local_trabalho').AsString;
    //^ saiu do loop

    {for x := 1 to RecordCount do
    begin  desabilitado para apenas um local
    }
      //adiciona horarios
      //* true = 0; false = 1
      if FieldByName('matutino').Value = true then
        varhorario := varhorario
        + DMcontratos.dslocaltrabalho.DataSet.FieldByName('horario_matutino_trabalho').AsString + ', ';
      if FieldByName('vespertino').Value = true then
        varhorario := varhorario
        + DMcontratos.dslocaltrabalho.DataSet.FieldByName('horario_vespertino_trabalho').AsString + ', ';
      if FieldByName('noturno').Value = true then
        varhorario := varhorario
        + DMcontratos.dslocaltrabalho.DataSet.FieldByName('horario_noturno_trabalho').AsString + ', ';

      vardistribui := varlocal+' '+varhorario;

      {vardistribui := vardistribui
        +DMcontratos.dslocaltrabalho.DataSet.FieldByName('nome_local_trabalho').AsString + varhorario;
        //desabilitado varios locais
        }

       //  ----

     { Next;
    end;   desabilitado}
   end;
  //----

  //substitui variaveis do html
  try
    textoref := TStringList.Create;
    textoref.LoadFromFile('contrato.html');

    textofinal := TStringList.Create;

    for y := 0 to textoref.Count -1 do
    begin
      if Pos('varnome',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varnome',DMcontratos.dspessoa.DataSet.FieldByName('nome_pessoa').AsString,[rfIgnoreCase]))
      else if Pos('varcargo',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varcargo',DMcontratos.dscargos.DataSet.FieldByName('nome_cargo').AsString,[rfIgnoreCase]))
      else if Pos('varperiodoinicial',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varperiodoinicial',DMcontratos.dsContratos.DataSet.FieldByName('periodo_inicial_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varperiodofinal',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varperiodofinal',DMcontratos.dsContratos.DataSet.FieldByName('periodo_final_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varlocal',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varlocal',varlocal,[rfIgnoreCase]))
      else if Pos('varjornada',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varjornada',DMcontratos.dsContratos.DataSet.FieldByName('jornada_trabalho_contrato').AsString,[rfIgnoreCase]))
      else if Pos('vardata',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'vardata',DMcontratos.dsContratos.DataSet.FieldByName('data_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varano',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varano',FormatDateTime('yyyy',now),[rfIgnoreCase]))
      else if Pos('varcodigocontrato',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varcodigocontrato',DMcontratos.dsContratos.DataSet.FieldByName('codigo_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varnacionalidade',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varnacionalidade',DMcontratos.dspessoa.DataSet.FieldByName('nacionalidade_pessoa').AsString,[rfIgnoreCase]))
      else if Pos('varestadocivil',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varestadocivil',DMcontratos.dspessoa.DataSet.FieldByName('estado_civil_pessoa').AsString,[rfIgnoreCase]))
      else if Pos('varrg',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varrg',DMcontratos.dspessoa.DataSet.FieldByName('rg_pessoa').AsString,[rfIgnoreCase]))
      else if Pos('varcpf',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varcpf',DMcontratos.dspessoa.DataSet.FieldByName('cpf_pessoa').AsString,[rfIgnoreCase]))
      else if Pos('varendereco',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varendereco',DMcontratos.dspessoa.DataSet.FieldByName('endereco_pessoa').AsString,[rfIgnoreCase]))
      else if Pos('varbairro',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varbairro',DMcontratos.dspessoa.DataSet.FieldByName('bairro_pessoa').AsString,[rfIgnoreCase]))
      else if Pos('varsalario',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varsalario',DMcontratos.dscargos.DataSet.FieldByName('salario_hora_cargo').AsString,[rfIgnoreCase]))
      else if Pos('varcidade',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varcidade',DMcontratos.dscidades.DataSet.FieldByName('nome_cidade').AsString,[rfIgnoreCase]))
      else if Pos('varjustificativa',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varjustificativa',DMcontratos.dsContratos.DataSet.FieldByName('justificativa_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varcargahoraria',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varcargahoraria',DMcontratos.dsContratos.DataSet.FieldByName('jornada_trabalho_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varteste1cpf',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varteste1cpf',DMcontratos.dsContratos.DataSet.FieldByName('cpf_teste_1_contrato').AsString,[rfIgnoreCase]))
      else if Pos('vartestemunha1',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'vartestemunha1',DMcontratos.dsContratos.DataSet.FieldByName('testemunha_1_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varteste2cpf',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varteste2cpf',DMcontratos.dsContratos.DataSet.FieldByName('cpf_teste_2_contrato').AsString,[rfIgnoreCase]))
      else if Pos('vartestemunha2',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'vartestemunha2',DMcontratos.dsContratos.DataSet.FieldByName('testemunha_2_contrato').AsString,[rfIgnoreCase]))
      else if Pos('varclausula',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varclausula',DMcontratos.dscargos.DataSet.FieldByName('clausula_primeira_cargo').AsString,[rfIgnoreCase]))
      else if Pos('vargrupo',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'vargrupo',DMcontratos.dscargos.DataSet.FieldByName('grupo_ocupacional_cargo').AsString,[rfIgnoreCase]))
      else if Pos('varhorario',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varhorario',varhorario,[rfIgnoreCase]))
      else if Pos('vardistribui',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'vardistribui',vardistribui,[rfIgnoreCase]))
      else if Pos('varseletivo',textoref.Strings[y]) <> 0 then
        textofinal.Add(StringReplace(textoref.Strings[y],'varseletivo',DMcontratos.dsContratos.DataSet.FieldByName('ano_seletivo_contrato').AsString,[rfIgnoreCase]))

      //observaçao contrato
      else if Pos('varobs',textoref.Strings[y]) <> 0 then
      begin
        if DMcontratos.dsContratos.DataSet.FieldByName('obs_contrato').AsString = '' then
          textofinal.Add(StringReplace(textoref.Strings[y],'varobs',
          '________________________________________________________________________________'+ '<br>'+
          '_____________________________________________________________________________________'+ '<br>'+
          '_____________________________________________________________________________________',[rfIgnoreCase]))
        else
          textofinal.Add(StringReplace(textoref.Strings[y],'varobs',DMcontratos.dsContratos.DataSet.FieldByName('obs_contrato').AsString,[rfIgnoreCase]));
      end

      //tipo de contrataçao
      else if Pos('var1',textoref.Strings[y]) <> 0 then
        testContrato(textofinal,textoref, y)
      else if Pos('var2',textoref.Strings[y]) <> 0 then
        testContrato(textofinal,textoref, y)
      else if Pos('var3',textoref.Strings[y]) <> 0 then
        testContrato(textofinal,textoref, y)

      else
        textofinal.Add(textoref.Strings[y]);

    end;
    textofinal.SaveToFile(local+'contratoatual.html');//salva arquivo

    //salva se o usuario desejar em local especifico
    if MessageDlg('Salvar o contrato no computador? O mesmo já está salvo no banco de dados.', mtCustom, mbYesNo, 1) = IDYES then
    begin
      savedlg := TSaveDialog.Create(nil);
      savedlg.FileName:= 'contrato_'+DMcontratos.dsContratos.DataSet.Fields[0].AsString +'.html';

      if savedlg.Execute then
      begin
        textofinal.SaveToFile(savedlg.FileName);
      end;

      OpenURL(expandLocalHtmlFileName(savedlg.FileName+'.html'));// abre o contrato html no navegador
    end
    else
      //abre contrato no navegador
      OpenURL(expandLocalHtmlFileName(local+'contratoatual.html'));
  finally
    textoref.Free;
    textofinal.free;

    //Desativa filtros de DMcontratos.DS
    DMcontratos.dsContratos.DataSet.Filtered:=false;
    DMcontratos.dspessoa.DataSet.Filtered:=false;
    DMcontratos.dscargos.DataSet.Filtered:=false;
    DMcontratos.dscidades.DataSet.Filtered:=false;
    DMcontratos.dscontratoslocais.DataSet.Filtered:=false;
    DMcontratos.dslocaltrabalho.DataSet.Filtered:=false;
  end;
end;
// FIM -------------------------------------------------------------------------

procedure Thtml.testContrato(var textofinal, textoref : Tstringlist; y : integer);
var
  texto : string;
begin
  if DMcontratos.dsContratos.DataSet.FieldByName('tipo_contratacao_contrato').AsString = 'Seletivo' then
    texto := StringReplace(textoref.Strings[y],'var1','X',[rfIgnoreCase])
  else  if DMcontratos.dsContratos.DataSet.FieldByName('tipo_contratacao_contrato').AsString = 'Contratação Direta' then
    texto := StringReplace(textoref.Strings[y],'var3','X',[rfIgnoreCase])
  else if DMcontratos.dsContratos.DataSet.FieldByName('tipo_contratacao_contrato').AsString = 'Cadastro no RH' then
    texto := StringReplace(textoref.Strings[y],'var2','X',[rfIgnoreCase]);

  texto := StringReplace(texto,'var1','&nbsp;&nbsp;',[rfIgnoreCase]);
  texto := StringReplace(texto,'var2','&nbsp;&nbsp;',[rfIgnoreCase]);
  texto := StringReplace(texto,'var3','&nbsp;&nbsp;',[rfIgnoreCase]);

  textofinal.Add(texto);
end;

end.

