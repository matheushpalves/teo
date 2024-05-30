program teo;

uses
  SysUtils,
  IniFiles,
  Classes;

procedure CreateApp(const AppName: string; const DBType: string);
var
  BaseDir, ModelDir, ControllerDir, ViewDir, ConfigFile: string;
  Config: TIniFile;
begin
  // Definindo diretórios
  BaseDir := GetCurrentDir + PathDelim + AppName;
  ModelDir := BaseDir + PathDelim + 'model';
  ControllerDir := BaseDir + PathDelim + 'controller';
  ViewDir := BaseDir + PathDelim + 'view';
  ConfigFile := BaseDir + PathDelim + 'database.ini';

  // Criando diretórios
  if not DirectoryExists(BaseDir) then
    CreateDir(BaseDir);
  if not DirectoryExists(ModelDir) then
    CreateDir(ModelDir);
  if not DirectoryExists(ControllerDir) then
    CreateDir(ControllerDir);
  if not DirectoryExists(ViewDir) then
    CreateDir(ViewDir);

  // Criando arquivo de configuração
  Config := TIniFile.Create(ConfigFile);
  try
    Config.WriteString('Database', 'Type', DBType);
    Config.WriteString('Database', 'Host', 'localhost');
    Config.WriteString('Database', 'Port', '5432');
    Config.WriteString('Database', 'Username', 'user');
    Config.WriteString('Database', 'Password', 'password');
    Config.WriteString('Database', 'Database', 'database_name');
  finally
    Config.Free;
  end;

  Writeln('Application ', AppName, ' created successfully.');
end;

procedure HandleCommand;
var
  Command, AppName, DBType: string;
begin
  if ParamCount = 0 then
  begin
    Writeln('Usage: teo new app "app-name" [-pgsql]');
    Exit;
  end;

  Command := ParamStr(1);
  if Command = 'new' then
  begin
    if ParamCount < 3 then
    begin
      Writeln('Usage: teo new app "app-name" [-pgsql]');
      Exit;
    end;

    AppName := ParamStr(3);
    DBType := 'sqlite';  // Default database type
    if ParamCount = 4 then
    begin
      if ParamStr(4) = '-pgsql' then
        DBType := 'postgresql';
    end;

    CreateApp(AppName, DBType);
  end
  else
  begin
    Writeln('Unknown command: ', Command);
  end;
end;

begin
  try
    HandleCommand;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
