{
Seksi Commander
----------------------------
Licence  : GNU GPL v 2.0
Author   : radek.cervinka@centrum.cz

some file rutines (obsolete)

contributors:

  Mattias Gaertner (from Lazarus code)

}
{$mode objfpc}{$H+}

unit uFileProcs;

interface
uses
  ComCtrls;

function ForceDirectory(DirectoryName: string): boolean;


function FileStampToDateTime(TimeStamp:Longint):TDateTime; // not portable

Function CopyFile(const sSrc, sDst:String; bAppend:Boolean):Boolean;
Function MoveFile(const sSrc, sDst:String; pb:TProgressBar; iSrcRights:Integer):Boolean;
Function DelFile(const sSrc:String):Boolean;
Function RenFile(const sSrc, sDst:String):Boolean;

implementation
uses
  SysUtils, FileUtil, DateUtils, Classes, FindEx, ushowMsg, ulng;

const
  cBlockSize=16384; // size of block if copyfile
// if pb is assigned > use, else work without pb :-)

function ForceDirectory(DirectoryName: string): boolean;
begin
  // SysUtils.ForceDirectories returns True if the directory was successfully created or already exists.
  Result := SysUtils.ForceDirectories(DirectoryName);
end;

function FileStampToDateTime(TimeStamp: Longint): TDateTime;
begin
  Result := UnixToDateTime(TimeStamp);
end;

function CopyFile(const sSrc, sDst: String; bAppend: Boolean): Boolean;
var
  src, dst: TFileStream;
begin
  Result := False;
  if bAppend and FileExists(sDst) then
  begin
    try
      src := TFileStream.Create(sSrc, fmOpenRead);
      dst := TFileStream.Create(sDst, fmOpenReadWrite or fmShareDenyWrite);
      dst.Seek(0, soEnd); // Move to the end for appending
      dst.CopyFrom(src, 0); // Copy the entire source file
      Result := True;
    finally
      src.Free;
      dst.Free;
    end;
  end
  else
    Result := FileUtil.CopyFile(sSrc, sDst, True); // True for overwrite existing files
end;

function MoveFile(const sSrc, sDst: String; pb: TProgressBar; iSrcRights: Integer): Boolean;
begin
  // Simple file move operation. Consider additional logic for permissions or progress bar update.
  Result := SysUtils.RenameFile(sSrc, sDst);
end;

// only wrapper for SysUtils.DeleteFile (raise Exception)
Function DelFile(const sSrc:String):Boolean;
begin
  Result:=SysUtils.DeleteFile(sSrc);
  if not Result then
    msgError(Format(lngGetString(clngMsgNotDelete),[sSrc]));
end;

Function RenFile(const sSrc, sDst:String):Boolean;
begin
  Result:=False;
  if FileExists(sDst) and not MsgYesNo(lngGetString(clngMsgFileExistsRwrt)) then
    Exit;
  Result:=SysUtils.RenameFile(sSrc, sDst);
end;

end.
