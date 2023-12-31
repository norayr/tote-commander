{
Seksi Commander
----------------------------
Implementing of storing Files and main file operation

Licence  : GNU GPL v 2.0
Author   : radek.cervinka@centrum.cz

contributors:


}
unit uFilePanel;

{$mode objfpc}{$H+}

interface
uses
  StdCtrls, Grids, uFileList, uTypes, uPathHistory, Classes;

type
  TFilePanel=Class
  private
    fFileList:TFileList;
    flblPath:TStaticText;
    fPanel:TDrawGrid;
    fSortCol:Integer;
    fSortDirect:Boolean;
    fActiveDir:String;
    fLastActive:String;

    fPanelMode: TPanelMode; // file, archive or FTP?
    fPathHistory: TPathHistory;
    fRefList:TList;  // list of ptr (showed in grid) to FileRecItem

    fFilesInDir:Integer; //must call UpdateCountStatus first
    fFilesSelected:Integer; //must call UpdateCountStatus first
    fSizeInDir:Int64; //must call UpdateCountStatus first
    fSizeSelected:Int64; //must call UpdateCountStatus first
    flblCurPath:TLabel; // label before Command line
    flblFree:TLabel;
    fedtCommand:TComboBox; // only for place correction after Chdir
  public
//    iLastDrawnIndex  :Integer; // fucking dirty hack (OnDrawItem

    constructor Create(APanel:TDrawGrid; AlblPath: TStaticText; AlblCurPath, AlblFree:TLabel; AedtCommand:TComboBox);
    Destructor Destroy; override;
    procedure LoadPanel;
    procedure LoadPanelVFS(frp:PFileRecItem);
    procedure LoadPanelFTP(frp:PFileRecItem);
    procedure SortByCol(iCol:Integer);
    procedure Sort;
    procedure UpdatePanel;
//    procedure ChDir(sDir:String);
    procedure ChooseFile(pfri:PFileRecItem); // main input node
    procedure ExecuteFile(const sName:String; bTerm:Boolean);
    function GetFileItem(iIndex:Integer):TFileRecItem;
    function GetFileItemPtr(iIndex:Integer):PFileRecItem;
    function GetReferenceItemPtr(iIndex:Integer):PFileRecItem;
    function GetActiveItem:PFileRecItem;
    function GetSelectedCount:Integer;
    procedure InvertFileSection(frp:PFileRecItem);
    procedure MarkAllFiles(bMarked:Boolean);
    procedure InvertAllFiles;
    procedure UpdateCountStatus;
    procedure cdUpLevel;
    procedure cdDownLevel(frp:PFileRecItem);
    procedure MarkGroup(const sMask:String; bSelect:Boolean); // second parametr is switch sel/uns
    procedure UpdatePrompt;
    procedure ProcessExtCommand(sCmd:String{; pfr:PFileRecItem});
    procedure ReplaceExtCommand(var sCmd:String; pfr:PFileRecItem);
    procedure SetActiveDir(const AValue:String);
    function GetActiveDir:String;

  published
    property SortDirection:Boolean read fSortDirect write fSortDirect; // maybe write method
    property ActiveDir:String read GetActiveDir write SetActiveDir;
    property LastActive:String read fLastActive write fLastActive;
    property FileList: TFileList read fFileList;
    property SelectedCount:Integer read GetSelectedCount;
    property FilesInDir:Integer read fFilesInDir;
    property FilesSelected:Integer read fFilesSelected;
    property SizeInDir:Int64 read fSizeInDir;
    property SizeSelected:Int64 read fSizeSelected;
  end;

implementation

uses
  SysUtils, uFileOp, uGlobs, uVFS, uExecCmd,
  uShowMsg, Controls, uFilter, uConv, uLng, uShowForm,
  uVFSmodule, uVFStypes, BaseUnix, Unix, UnixType;

constructor TFilePanel.Create(APanel:TDrawGrid; AlblPath: TStaticText; AlblCurPath, AlblFree:TLabel; AedtCommand:TComboBox);
begin
  fPanel:=APanel;
  fRefList:=TList.Create;
  flblPath:=AlblPath;
  flblCurPath:=AlblCurPath;
  flblFree:=AlblFree;
  fedtCommand:=AedtCommand;
  fFileList:=TFileList.Create;
  GetDir(0,fActiveDir);
  fActiveDir:=ExtractFilePath(fActiveDir);
  fPathHistory:=TPathHistory.Create;
  fPanelMode:=pmDirectory;
//  LastActive:='';
//  iLastDrawnIndex:=-1;
end;

Destructor TFilePanel.Destroy;
begin
  if assigned(fFileList) then
    FreeAndNil(fFileList);
  if assigned(fPathHistory) then
    FreeAndNil(fPathHistory);
  if assigned(fRefList) then
    FreeAndNil(fRefList);
end;


procedure TFilePanel.UpdatePanel;
var
  i:Integer;
  pfri:PFileRecItem;
  bAnyRow:Boolean;
begin
  case fPanelMode of
    pmDirectory: flblPath.Caption:=' '+ActiveDir;
    pmArchive: flblPath.Caption:=' '+ExtractFileName(fPathHistory.GetLastPath)+':'+ActiveDir;
    pmFTP: flblPath.Caption:=' fix me: FTP is only prepared';
  else
    Raise Exception.Create('fix me:UpdatePanel:bad panelmode');
  end;
//  writeln('fPanel.Row:',fPanel.Row);
//  writeln('TFilePanel:', fFileList.Count);
  bAnyRow:=fPanel.Row>=0;
  fRefList.Clear;
  for i:=0 to fFileList.Count-1 do
  begin
    pfri:=fFileList.GetItem(i);
    with pfri^ do
    begin
      if not gShowSystemFiles and (sName[1]='.') and (sName<>'..') then Continue;
      fRefList.Add(pfri);
    end;
  end;

  fPanel.RowCount:=fRefList.Count+1; // one is header
  UpdatePrompt;
  if bAnyRow then
  begin
    if (LastActive<>'') then // find correct cursor position in Panel (drawgrid)
    begin
      for i:=0 to fRefList.Count-1 do
      begin
        with GetReferenceItemPtr(i)^ do
          if pos(LastActive, sName)=1 then
          begin
            fPanel.Row:=i+1;
            Break;
          end;
      end;
    end
    else
      fPanel.Row:=0;
    if (fPanel.Row<0)then
      fPanel.Row:=0;
  end;    
//  fPanel.Selected.MakeVisible;}
  UpdateCountStatus;
end;

procedure TFilePanel.LoadPanelVFS(frp:PFileRecItem);
var
  sn, fn:String; // script name
  sDir:String;
  sDummy:String;
  module:TVFSModule;
begin
  with frp^ do
  begin
    if (fPanelMode=pmArchive) then
    begin
      if FPS_ISDIR(iMode) then
      begin
       // browse archive
         sDummy:=ExtractFileName(fPathHistory.GetLastPath);
//         sn:= VFS.VFSGetScriptName(sDummy);
//         VFS.Lis
         sDir:=sName; // after VFSListItems has fFileList other data
         VFS.VFSListItems(fPathHistory.GetLastPath,ActiveDir+sName,fFileList);
         fActiveDir:=fActiveDir+sDir+'/';
         fFileList.UpdateFileInformation;
         Sort;
         Exit;
      end
      else
      begin
       // we are in the archive and not selected DIR
        if bExecutable then
        begin
          module:=VFS.FindModule(fPathHistory.GetLastPath);
          if (module.VFSCaps(sName) and capVFS_Execute)>0 then
            module.VFSRun(ActiveDir+sName)
          else
            MsgOK('This archive module not support execute command.');
          Exit;
        end;
        //wow, we are in the archive, go deeper :)

        sDummy:=ExtractFileName(fPathHistory.GetLastPath+ActiveDir+sName);
        module:=VFS.FindModule(fPathHistory.GetLastPath);

        if not assigned(module) then Exit;
        // yes, it's archive, copy out archive
        fn:='/tmp/'+sName;
//*        module.VFSOpen()
        module.VFSCopyOut(fPathHistory.GetLastPath,ActiveDir+sName);
        fPathHistory.AddAlias(ActiveDir+sName,'');
       //  OK > Call VFS
        VFS.VFSListItems(fn,'',fFileList);
      end;
    end
    else // not in archive
    begin
      fn:=ExtractFileName(sName);
//      sn:= VFS.VFSGetScriptName(fn); // Test if it's archive
      module:=VFS.FindModule(sName);
      if not assigned(module) then Exit;
//      if sn='' then Exit;
      fPathHistory.AddAlias(ActiveDir+sName,'');
     //  OK > Call VFS
      VFS.VFSListItems(ActiveDir+sName,'',fFileList);
    end;

    fPanelMode:=pmArchive;
    fActiveDir:='';
    fFileList.UpdateFileInformation;
    Sort;
  end;
end;


procedure TFilePanel.LoadPanel;
begin
//  writeln('TFilePanel.LoadPanel');
  case fPanelMode of
  pmArchive:
    VFS.VFSListItems(fPathHistory.GetLastPath,ActiveDir,fFileList);
  pmFTP:
    Raise Exception.Create('FTP is only prepared');
  else
    begin
      // classic filesystem
      if fpchdir(PChar(ActiveDir))<>0 then
      begin
        GetDir(0,fActiveDir);
        if fActiveDir<>'/' then
          fActiveDir:=fActiveDir+'/';
        Exit;   // chdir failed
      end;
      LoadFilesbyDir(fActiveDir, fFileList);
    end;
  end; // case
  fFileList.UpdateFileInformation;
  Sort; // and Update panel
  fPanel.Invalidate;
//  writeln('TFilePanel.LoadPanel DONE');
end;


procedure TFilePanel.SortByCol(iCol:Integer);
begin
  fSortCol:=iCol;
  Sort;
end;

procedure TFilePanel.Sort;
begin
  fFileList.Sort(fSortCol, fSortDirect);
  UpDatePanel;
end;

function TFilePanel.GetFileItem(iIndex:Integer):TFileRecItem;
begin
  Result:=fFilelist.GetItem(iIndex)^;
end;

function TFilePanel.GetFileItemPtr(iIndex:Integer):PFileRecItem;
begin
  Result:=fFilelist.GetItem(iIndex);
end;


procedure TFilePanel.InvertFileSection(frp:PFileRecItem);
begin
  if not gShowSystemFiles and (frp^.sName[1]='.') then Exit;
  frp^.bSelected:=not frp^.bSelected;
end;

procedure TFilePanel.InvertAllFiles;
var
  i:Integer;
begin
  for i:=0 to fFileList.Count-1 do
    InvertFileSection(fFileList.GetItem(i));
end;


procedure TFilePanel.ChooseFile(pfri:PFileRecItem);
var
  sOpenCmd:String;
begin
// main file input point for decision
//  writeln(pfri^.sName);

  with pfri^ do
  begin
    if (sName='..') then
    begin
      cdUpLevel;
      Exit;
    end;
    if (fPanelMode=pmFTP) then
    begin
      LoadPanelFTP(pfri);
      Exit;
    end;
    if (fPanelMode=pmArchive) then
    begin
      LoadPanelVFS(pfri);
      Exit;
    end;

    if FPS_ISDIR(iMode) or bLinkIsDir then // deeper and deeper
    begin
      cdDownLevel(pfri);
      Exit;
    end;
    //now test if exists Open command in sc.ext :)
    sOpenCmd:=gExts.GetCommandText(lowercase(ExtractFileExt(sName)),'open');
    if (sOpenCmd<>'') then
    begin
      if Pos('{!VFS}',sOpenCmd)>0 then
      begin
        if assigned(VFS.FindModule(sName)) then
//        if VFS.VFSGetScriptName(ExtractFileName(sName))<>'' then
        begin
          LoadPanelVFS(pfri);
          Exit;
        end;
      end;
      LastActive:=sName;

      ReplaceExtCommand(sOpenCmd, pfri);
      ProcessExtCommand(sOpenCmd{, frp});
      Exit;
    end;
    // and at the end try if it is executable
    if bExecutable then
      begin
        System.ChDir(ActiveDir);
        LastActive:=sName;
        ExecuteFile('./'+sName, True);
//        uExecCmd.ExecCmdFork('./'+sName);
        LoadPanel;
        Exit;
      end;
  end;
end;

procedure TFilePanel.ExecuteFile(const sName:String; bTerm:Boolean);
begin
  if bTerm then
//    uExecCmd.ExecCmdFork(Format(gTerm,[sName+'|less']))
    uExecCmd.ExecCmdFork(Format(gTerm,[sName+';echo ''Press Enter'';read']))
  else
    uExecCmd.ExecCmdFork(sName);
end;

procedure TFilePanel.MarkAllFiles(bMarked:Boolean);
var
  i:Integer;
  fr:PFileRecItem;

begin
  for i:=0 to fFileList.Count-1 do
  begin
    fr:=fFileList.GetItem(i);
    if not gShowSystemFiles and (fr^.sName[1]='.') then
// system files is always not selected if not showed
      fr^.bSelected:=False
    else
      fr^.bSelected:=bMarked;
  end;
end;

function TFilePanel.GetSelectedCount:Integer;
var
  i:Integer;
begin
  Result:=0;
  for i:=0 to fFileList.Count-1 do
    if fFileList.GetItem(i)^.bSelected then
      inc(Result);
end;

procedure TFilePanel.UpdateCountStatus;
var
  i:Integer;
begin
  fFilesInDir:=0;
  fFilesSelected:=0;
  fSizeInDir:=0;
  fSizeSelected:=0;
  for i:=0 to fFileList.Count-1 do
  begin
    with fFileList.GetItem(i)^ do
    begin
//      if S_ISDIR(fMode) then Continue;
      if sName='..' then Continue;
      if bSelected then
      begin
        inc(fFilesSelected);
        if not FPS_ISDIR(iMode) then
          fSizeSelected:=Cardinal(fSizeSelected)+iSize
        else
          if iDirSize<>0 then
            fSizeSelected:=Cardinal(fSizeSelected)+iDirSize;
      end;
      inc(fFilesInDir);
      if not FPS_ISDIR(iMode) then
        fSizeInDir:=Cardinal(fSizeInDir)+iSize
      else
        if iDirSize<>0 then
          fSizeSelected:=Cardinal(fSizeSelected)+iDirSize;
    end;
  end;
end;

procedure TFilePanel.cdUpLevel;
var
  i:Integer;
  bPathFound:Boolean;
begin
// handle ..
  if (fActiveDir='/') or (fActiveDir='') then
  begin
    if fPanelMode=pmArchive then
    begin
      if not fPathHistory.IsEmpty then
      begin
        fPathHistory.GetLastPathRemove(fActiveDir);
        LastActive:=ExtractFileName(fActiveDir);
        fActiveDir:=ExtractFilePath(fActiveDir);   // escape from archive
      end;
      if not fPathHistory.IsEmpty then
        fPanelMode:=pmArchive
      else
        fPanelMode:=pmDirectory;
    end;
    if fPanelMode=pmFTP then
    begin
      Raise Exception.Create('FTP is only prepared');
      fPanelMode:=pmDirectory;
    end;
  end
  else
  begin
    bPathFound:=False;
    fActiveDir:=ExcludeTrailingPathDelimiter(fActiveDir);
    for i:=length(fActiveDir) downto 1 do
    begin
      if fActiveDir[i]='/' then
      begin
       LastActive:=Copy(fActiveDir,i+1,length(fActiveDir)-i+1);
       fActiveDir:=Copy(fActiveDir,1, i);
       bPathFound:=True;
       Break;
      end;
    end;
    if not bPathFound then // this occurs in archive
    begin
      LastActive:=fActiveDir;
      fActiveDir:='';
    end;
    if glsDirHistory.IndexOf(ActiveDir)=-1 then
      glsDirHistory.Insert(0,ActiveDir);
  end;
  LoadPanel;
end;


procedure TFilePanel.cdDownLevel(frp:PFileRecItem);
{var
  i:Integer;}
begin
  with frp^ do
  begin
    ActiveDir:=ActiveDir+sName+'/';
    LastActive:='';
    if glsDirHistory.IndexOf(ActiveDir)=-1 then
      glsDirHistory.Insert(0,ActiveDir);
  end; // with frp^
  LoadPanel;
end;

function TFilePanel.GetActiveItem:PFileRecItem;
begin
  Result:=nil;
  if fPanel.Row<1 then
    SysUtils.Abort;
//  writeln(fPanel.Row, ' ', fRefList.Count);
  if fPanel.Row>fRefList.Count then
    SysUtils.Abort;
  Result:=fRefList.Items[fPanel.Row-1]; // 1 is fixed header
end;

procedure TFilePanel.MarkGroup(const sMask:String; bSelect:Boolean);
var
  flt:TFilter;
  i:Integer;
  frp:PFileRecItem;
begin
  flt:=TFilter.Create;
  try
    flt.FileMask:=sMask;
    for i:=0 to fFileList.Count-1 do
    begin
      frp:=fFileList.GetItem(i);
      if (frp^.sName='..') then Continue;
      if flt.CheckFileMask(frp^.sName) then
        frp^.bSelected := bSelect;
    end;
  finally
    FreeAndNil(flt);
  end;
end;

procedure TFilePanel.UpdatePrompt;
var
  sbfs:Tstatfs;
//  iPathWidth:Integer;
begin
  with flblCurPath do
  begin
    AutoSize:=False;
    Caption:='['+ActiveDir+']$:';
    AutoSize:=True;
    Left:=1;
  end;
  
  fedtCommand.Left:=flblCurPath.Width+5;
  fedtCommand.Width:=TControl(fedtCommand.Parent).Width-fedtCommand.Left;
  if fPanelMode=pmDirectory then
  begin
    statfs(PChar(fActiveDir),sbfs);
//    writeln('Statfs:',sbfs.bavail,' ',sbfs.bsize,' ',sbfs.blocks,' ', sbfs.bfree);
    flblFree.Caption:=Format(lngGetString(clngFreeMsg),
       [cnvFormatFileSize(Int64(sbfs.bavail)*sbfs.bsize),
        cnvFormatFileSize(Int64(sbfs.blocks)*sbfs.bsize)]);
  end
  else
  //TODO
    flblFree.Caption:=Format(lngGetString(clngFreeMsg),[cnvFormatFileSize(0),cnvFormatFileSize(0)]);
end;

procedure TFilePanel.LoadPanelFTP(frp:PFileRecItem);
begin
  Raise Exception.Create('FTP is only prepared');
  fPanelMode:=pmFTP;
end;

procedure TFilePanel.ReplaceExtCommand(var sCmd:String; pfr:PFileRecItem);
begin
  with pfr^ do
  begin
    sCmd:=StringReplace(sCmd,'%f',ExtractFileName(sName),[rfReplaceAll]);
    sCmd:=StringReplace(sCmd,'%d',ActiveDir,[rfReplaceAll]);
    sCmd:=Trim(StringReplace(sCmd,'%p',ActiveDir+ExtractFileName(sName),[rfReplaceAll]));
  end;
end;

procedure TFilePanel.ProcessExtCommand(sCmd:String{; pfr:PFileRecItem});
begin
  if Pos('{!SHELL}', sCmd)>0 then
  begin
    sCmd:=StringReplace(sCmd,'{!SHELL}','',[rfReplaceAll]);
    sCmd:=Format(gTerm,[sCmd]);
  end;
  if Pos('{!EDITOR}',sCmd)>0 then
  begin
    sCmd:=StringReplace(sCmd,'{!EDITOR}','',[rfReplaceAll]);
    uShowForm.ShowEditorByGlob(sCmd);
    Exit;
  end;
  if Pos('{!VIEWER}',sCmd)>0 then
  begin
    sCmd:=StringReplace(sCmd,'{!VIEWER}','',[rfReplaceAll]);
    uShowForm.ShowViewerByGlob(sCmd);
    Exit;
  end;
  System.ChDir(ActiveDir);
//    LastActive:=sName;
  writeln(sCmd);
  uExecCmd.ExecCmdFork(sCmd);
//      LoadPanel;
end;

procedure TFilePanel.SetActiveDir(const AValue:String);
begin
  fActiveDir := IncludeTrailingBackslash(AValue);
end;

function TFilePanel.GetActiveDir:String;
begin
  Result := IncludeTrailingBackslash(fActiveDir);
end;

function TFilePanel.GetReferenceItemPtr(iIndex:Integer):PFileRecItem;
begin
  Result:=nil;
  if iIndex>=fRefList.Count then Exit;
  Result:=PFileRecItem(fRefList.Items[iIndex]);
end;
end.

