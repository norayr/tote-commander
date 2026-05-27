{
   File name: FindEx.pas
   Date:      2004/05/xx
   Author:    Radek Cervinka  <radek.cervinka@centrum.cz>

   very fast file utils for 64 bit access
   
   fpStat64, fplStat64, Find*64
   

   Copyright (C) 2004

   Licence: GNU LGPL or later
   
   Warning Libc version is not much tested
   
}


unit FindEx;

{$mode objfpc}{$H+}

interface

uses
  BaseUnix, Unix, SysUtils, SysCall;

Type
  TGlobSearchRecEx = record
    FindHandle: TSearchRec;
    Path: String;
  end;
  PGlobSearchRecEx = ^TGlobSearchRecEx;
   TFindStatus = (fsOK, fsStatFailed, fsBadAttr);



Procedure FindCloseEx (Var F : TSearchrec);
Function FindFirstEx (Const Path : String; Attr : Longint; Var Rslt : TSearchRec) : Longint;
Function FindNextEx (Var Rslt : TSearchRec) : Longint;
function FindStat (Var Rslt : TSearchRec) :TFindStatus;

implementation

function FindFirstEx(const Path: String; Attr: Longint; var Rslt: TSearchRec): Longint;
var
  GlobSearchRec: PGlobSearchRecEx;
begin
  New(GlobSearchRec);
  Rslt.FindHandle := Pointer(GlobSearchRec);
  GlobSearchRec^.Path := ExpandFileName(Path);
  Result := FindFirst(Path, Attr, GlobSearchRec^.FindHandle);
  Rslt := GlobSearchRec^.FindHandle; // Copy the record to the user's variable
end;

function FindNextEx(var Rslt: TSearchRec): Longint;
begin
  Result := FindNext(Rslt);
end;

procedure FindCloseEx(var F: TSearchRec);
var
  GlobSearchRec: PGlobSearchRecEx;
begin
  if Assigned(F.FindHandle) then
  begin
    GlobSearchRec := PGlobSearchRecEx(F.FindHandle);
    Dispose(GlobSearchRec);
    F.FindHandle := nil;
  end;
end;

function FindStat(var Rslt: TSearchRec): TFindStatus;
begin
  // Assume Rslt already filled by FindFirstEx or FindNextEx
  if Rslt.Attr <> faAnyFile then
    Result := fsOK
  else
    Result := fsStatFailed; // If Rslt.Attr is faAnyFile, it means no file was found.

  // Additional checks or processing can be added here as needed.
  // For example, you might want to filter out files based on specific attributes
  // or perform additional checks on the file.
end;

end.

