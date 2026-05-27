{
Seksi Commander
----------------------------
Licence  : GNU GPL v 2.0
Author   : radek.cervinka@centrum.cz

contributors:

Peter Cernoch 2002, pcernoch@volny.cz
Martin Matusu, xmat@volny.cz

}

unit uFileOp;
{$mode objfpc}{$H+}
interface
uses
  uFileList, uTypes;

Function LoadFilesbyDir(const sDir:String; fl:TFileList):Boolean;
Function AttrToStr(iAttr:Cardinal):String;
//Function IsDirByName(const sName:String):Boolean;

const
  __S_IFMT        = $F000;
  __S_IFDIR       = $4000;
  __S_IFCHR       = $2000;
  __S_IFBLK       = $6000;
  __S_IFREG       = $8000;
  __S_IFIFO       = $1000;
  __S_IFLNK       = $A000;
  __S_IFSOCK      = $C000;

  __S_ISUID       = $800;
  __S_ISGID       = $400;
  __S_ISVTX       = $200;
  __S_IREAD       = $100;
  __S_IWRITE      = $80;
  __S_IEXEC       = $40;

    S_ISUID = __S_ISUID;
    S_ISGID = __S_ISGID;
    S_ISVTX = __S_ISVTX;

implementation
uses
  SysUtils, uUsersGroups, uFileProcs, Unix, BaseUnix, FindEx;


Function IsDirByName(const sName:String):Boolean;
var
  stat:BaseUnix.Stat;
begin
  fpStat(PChar(sName),stat);
  Result:=FPS_ISDIR(stat.st_mode);
end;


Function LoadFilesbyDir(const sDir:String; fl:TFileList):Boolean;
var
  fr: TFileRecItem;
  sr: TSearchRec;
  sb: Stat;
  sSearchPath: String;
  sFullName: String;
  n: Integer;
  r: Integer;

  procedure ClearFileRecItem(var ARec: TFileRecItem);
  begin
    { Do not FillChar this record: it contains managed strings. }
    ARec.sName := '';
    ARec.sNameNoExt := '';
    ARec.sExt := '';
    ARec.iDirSize := 0;
    ARec.iMode := 0;
    ARec.bExecutable := False;
    ARec.bIsLink := False;
    ARec.sLinkTo := '';
    ARec.bLinkIsDir := False;
    ARec.bSelected := False;
    ARec.sModeStr := '';
    ARec.iSize := 0;
    ARec.iOwner := 0;
    ARec.iGroup := 0;
    ARec.sOwner := '';
    ARec.sGroup := '';
    ARec.fTimeI := 0;
    ARec.sTime := '';
  end;

  function SafeUIDToStr(AUid: Cardinal): String;
  begin
    try
      Result := UIDToStr(AUid);
    except
      on E: Exception do
      begin
        Writeln('Warning: UIDToStr failed for ', AUid, ': ', E.Message);
        Result := IntToStr(AUid);
      end;
    end;
  end;

  function SafeGIDToStr(AGid: Cardinal): String;
  begin
    try
      Result := GIDToStr(AGid);
    except
      on E: Exception do
      begin
        Writeln('Warning: GIDToStr failed for ', AGid, ': ', E.Message);
        Result := IntToStr(AGid);
      end;
    end;
  end;

  procedure AddParentDirItem;
  begin
    ClearFileRecItem(fr);
    fr.sName := '..';
    fr.sNameNoExt := '..';
    fl.AddItem(@fr);
  end;

  procedure ProcessEntry;
  begin
    if sr.Name = '.' then
      Exit;

    if (sDir = '/') and (sr.Name = '..') then
      Exit;

    Inc(n);
    Writeln('  entry ', n, ': ', sr.Name);

    ClearFileRecItem(fr);

    if (sr.Name <> '') and (sr.Name[1] = '.') then
      fr.sExt := ''
    else
      fr.sExt := ExtractFileExt(sr.Name);

    fr.sNameNoExt := Copy(sr.Name, 1, Length(sr.Name) - Length(fr.sExt));
    fr.sName := sr.Name;

    sFullName := IncludeTrailingPathDelimiter(sDir) + sr.Name;

    { Use lstat semantics so symlinks remain symlinks in the panel. }
    if FpLStat(PChar(sFullName), sb) <> 0 then
    begin
      Writeln('    warning: FpLStat failed for ', sFullName,
        ', errno=', FpGetErrno);
      Exit;
    end;

    fr.iSize := sb.st_size;
    fr.iOwner := sb.st_uid;
    fr.iGroup := sb.st_gid;

    fr.sOwner := SafeUIDToStr(fr.iOwner);
    fr.sGroup := SafeGIDToStr(fr.iGroup);

    fr.iMode := sb.st_mode;
    fr.fTimeI := FileStampToDateTime(sb.st_mtime);
    fr.sTime := DateTimeToStr(Trunc(fr.fTimeI));

    fr.bIsLink := FPS_ISLNK(fr.iMode);
    if fr.bIsLink then
    begin
      try
        fr.sLinkTo := FpReadLink(PChar(sFullName));
      except
        on E: Exception do
        begin
          Writeln('    warning: FpReadLink failed for ', sFullName, ': ', E.Message);
          fr.sLinkTo := '';
        end;
      end;
    end;

    if fr.bIsLink and (fr.sLinkTo <> '') then
    begin
      if ExtractFilePath(fr.sLinkTo) = '' then
        fr.bLinkIsDir := IsDirByName(IncludeTrailingPathDelimiter(sDir) + fr.sLinkTo)
      else
        fr.bLinkIsDir := IsDirByName(fr.sLinkTo);
    end
    else
      fr.bLinkIsDir := False;

    fr.bSelected := False;
    fr.sModeStr := AttrToStr(fr.iMode);
    fr.bExecutable := (not FPS_ISDIR(fr.iMode)) and
      ((fr.iMode and (S_IXUSR or S_IXGRP or S_IXOTH)) <> 0);

    Writeln('    before AddItem: ', fr.sName);
    fl.AddItem(@fr);
    Writeln('    after AddItem: ', fr.sName);
  end;

begin
  Writeln('LoadFilesbyDir begin: ', sDir);
  Result := False;

  if not Assigned(fl) then
  begin
    Writeln('LoadFilesbyDir: file list is nil');
    Exit;
  end;

  fl.Clear;
  ClearFileRecItem(fr);

  sSearchPath := IncludeTrailingPathDelimiter(sDir) + '*';
  Writeln('  FindFirst: ', sSearchPath);

  r := SysUtils.FindFirst(sSearchPath, faAnyFile, sr);
  if r <> 0 then
  begin
    Writeln('LoadFilesbyDir: FindFirst returned no entries/error: ', r);
    AddParentDirItem;
    Result := True;
    Exit;
  end;

  n := 0;
  try
    while r = 0 do
    begin
      ProcessEntry;
      Writeln('    before FindNext');
      r := SysUtils.FindNext(sr);
      Writeln('    after FindNext: ', r);
    end;
  finally
    Writeln('  before FindClose');
    SysUtils.FindClose(sr);
    Writeln('  after FindClose');
  end;

  Writeln('LoadFilesbyDir end, entries=', n);
  Result := True;
end;

Function AttrToStr(iAttr:Cardinal):String;
begin
  Result     := '----------';
  if FPS_ISDIR(iAttr) then Result[1]:='d';
  if FPS_ISLNK(iAttr) then Result[1]:='l';
  if FPS_ISSOCK(iAttr) then Result[1]:='s';
  if FPS_ISFIFO(iAttr) then Result[1]:='f';
  if FPS_ISBLK(iAttr) then Result[1]:='b';
  if FPS_ISCHR(iAttr) then Result[1]:='c';

  if ((iAttr AND S_IRUSR) = S_IRUSR) then Result[2]  := 'r';
  if ((iAttr AND S_IWUSR) = S_IWUSR) then Result[3]  := 'w';
  if ((iAttr AND S_IXUSR) = S_IXUSR) then Result[4]  := 'x';
  if ((iAttr AND S_IRGRP) = S_IRGRP) then Result[5]  := 'r';
  if ((iAttr AND S_IWGRP) = S_IWGRP) then Result[6]  := 'w';
  if ((iAttr AND S_IXGRP) = S_IXGRP) then Result[7]  := 'x';
  if ((iAttr AND S_IROTH) = S_IROTH) then Result[8]  := 'r';
  if ((iAttr AND S_IWOTH) = S_IWOTH) then Result[9]  := 'w';
  if ((iAttr AND S_IXOTH) = S_IXOTH) then Result[10] := 'x';

  if ((iAttr AND S_ISUID) = S_ISUID) then Result[4]  := 's';
  if ((iAttr AND S_ISGID) = S_ISGID) then Result[7]  := 's';
end;

end.
