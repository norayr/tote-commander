{
Seksi Commander
----------------------------
Licence  : GNU GPL v 2.0
Author   : radek.cervinka@centrum.cz

Main Dialog window and other stuff

contributors:


based on (heavy rewriten):

main Unit of PFM : Peter's File Manager
---------------------------------------

Copyright : Peter Cernoch 2002
Contact   : pcernoch@volny.cz
Licence   : GNU GPL v 2.0

}

unit fMain;

{$mode objfpc}{$H+}

interface

uses
  LResources,
  Graphics, Forms, Menus, Controls, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls,ActnList,Buttons,
  SysUtils, Classes,  {uFilePanel,} fLngForm, framePanel, FileCtrl, Grids;

const
  cHistoryFile='cmdhistory.txt';

type

  TfrmMain = class(TfrmLng)
    actRemoveTab: TAction;
    actNewTab: TAction;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    mnuMain: TMainMenu;
    nbLeft: TNotebook;
    nbRight: TNotebook;
    pnlNotebooks: TPanel;
    pnlButton: TPanel;
    pnlDisk: TPanel;
    pnlCommand: TPanel;
    lblCommandPath: TLabel;
    mnuHelp: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuShow: TMenuItem;
    mnuShowName: TMenuItem;
    mnuShowExtension: TMenuItem;
    mnuShowTime: TMenuItem;
    mnuShowSize: TMenuItem;
    mnuShowAttrib: TMenuItem;
    miLine7: TMenuItem;
    mnuShowReverse: TMenuItem;
    mnuShowReread: TMenuItem;
    mnuFiles: TMenuItem;
    mnuFilesSplit: TMenuItem;
    mnuFilesCombine: TMenuItem;
    mnuCmd: TMenuItem;
    mnuCmdDirHotlist: TMenuItem;
    miLine2: TMenuItem;
    mnuFilesSpace: TMenuItem;
    mnuFilesAttrib: TMenuItem;
    mnuFilesProperties: TMenuItem;
    miLine6: TMenuItem;
    mnuCmdSwapSourceTarget: TMenuItem;
    mnuCmdTargetIsSource: TMenuItem;
    miLine3: TMenuItem;
    mnuFilesShwSysFiles: TMenuItem;
    miLine1: TMenuItem;
    mnuFilesLink: TMenuItem;
    mnuFilesSymLink: TMenuItem;
    mnuConfig: TMenuItem;
    mnuConfigOptions: TMenuItem;
    mnuMark: TMenuItem;
    mnuMarkSGroup: TMenuItem;
    mnuMarkUGroup: TMenuItem;
    mnuMarkSAll: TMenuItem;
    mnuMarkUAll: TMenuItem;
    mnuMarkInvert: TMenuItem;
    miLine5: TMenuItem;
    mnuMarkCmpDir: TMenuItem;
    mnuCmdSearch: TMenuItem;
    actionLst: TActionList;
    actExit: TAction;
    pnlKeys: TPanel;
    btnF3: TSpeedButton;
    btnF4: TSpeedButton;
    btnF5: TSpeedButton;
    btnF6: TSpeedButton;
    btnF7: TSpeedButton;
    btnF8: TSpeedButton;
    btnF10: TSpeedButton;
    actView: TAction;
    actEdit: TAction;
    actCopy: TAction;
    actRename: TAction;
    actMakeDir: TAction;
    actDelete: TAction;
    actAbout: TAction;
    actShowSysFiles: TAction;
    actOptions: TAction;
    edtCommand: TComboBox;
    mnuFilesCmpCnt: TMenuItem;
    actCompareContents: TAction;
    btnF9: TSpeedButton;
    actShowMenu: TAction;
    actRefresh: TAction;
    actSearch: TAction;
    actDirHotList: TAction;
    actMarkMarkAll: TAction;
    actMarkInvert: TAction;
    actMarkUnmarkAll: TAction;
    pmHotList: TPopupMenu;
    actDelete2: TAction;
    actPathToCmdLine: TAction;
    actMarkPlus: TAction;
    actMarkMinus: TAction;
    actChMod: TAction;
    actSymLink: TAction;
    actHardLink: TAction;
    actReverseOrder: TAction;
    actSortByName: TAction;
    actSortByExt: TAction;
    actSortBySize: TAction;
    actSortByDate: TAction;
    actSortByAttr: TAction;
    miLine4: TMenuItem;
    miExit: TMenuItem;
    actMultiRename: TAction;
    miMultiRename: TMenuItem;
    pmFileList: TPopupMenu;
    file1: TMenuItem;
    actShiftF5: TAction;
    actShiftF6: TAction;
    actShiftF4: TAction;
    actDirHistory: TAction;
    pmDirHistory: TPopupMenu;
    actCtrlF8: TAction;
    actRunTerm: TAction;
    miLine9: TMenuItem;
    miRunTerm: TMenuItem;
    actCalculateSpace: TAction;
    actFileProperties:  TAction;
    actChown: TAction;
    mnuFilesChown: TMenuItem;
    actFileLinker: TAction;
    actFileSpliter: TAction;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actNewTabExecute(Sender: TObject);
    procedure actRemoveTabExecute(Sender: TObject);
    procedure frmMainClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure frmMainKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure frmMainShow(Sender: TObject);
    procedure NotebookCloseTabClicked(Sender: TObject);
    procedure pnlKeysResize(Sender: TObject);
    procedure actViewExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
    procedure actMakeDirExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actShowSysFilesExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure actCompareContentsExecute(Sender: TObject);
    procedure actShowMenuExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actMarkInvertExecute(Sender: TObject);
    procedure actMarkMarkAllExecute(Sender: TObject);
    procedure actMarkUnmarkAllExecute(Sender: TObject);
    procedure actDirHotListExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actDelete2Execute(Sender: TObject);
    procedure edtCommandKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actPathToCmdLineExecute(Sender: TObject);
    procedure actMarkPlusExecute(Sender: TObject);
    procedure actMarkMinusExecute(Sender: TObject);
    procedure actChModExecute(Sender: TObject);
    procedure actSymLinkExecute(Sender: TObject);
    procedure actHardLinkExecute(Sender: TObject);
    procedure actReverseOrderExecute(Sender: TObject);
    procedure actSortByNameExecute(Sender: TObject);
    procedure actSortByExtExecute(Sender: TObject);
    procedure actSortBySizeExecute(Sender: TObject);
    procedure actSortByDateExecute(Sender: TObject);
    procedure actSortByAttrExecute(Sender: TObject);
    procedure actMultiRenameExecute(Sender: TObject);
    procedure pmFileListPopup(Sender: TObject);
    procedure actShiftF5Execute(Sender: TObject);
    procedure actShiftF6Execute(Sender: TObject);
    procedure actShiftF4Execute(Sender: TObject);
    procedure actDirHistoryExecute(Sender: TObject);
    procedure actCtrlF8Execute(Sender: TObject);
    procedure actRunTermExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FrameRightedtRenameExit(Sender: TObject);
    procedure FrameedtSearchExit(Sender: TObject);

    procedure actCalculateSpaceExecute(Sender: TObject);
    procedure actFilePropertiesExecute(Sender: TObject);
    procedure FramedgPanelEnter(Sender: TObject);
    procedure FramelblLPathClick(Sender: TObject);
    procedure edtCommandKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actChownExecute(Sender: TObject);
    procedure actFileLinkerExecute(Sender: TObject);
    procedure actFileSpliterExecute(Sender: TObject);
  private
    { Private declarations }
    PanelSelected:TFilePanelSelect;
    bAltPress:Boolean;
    
    function ExecuteCommandFromEdit(sCmd:String):Boolean;
  public
//    frameLeft, frameRight:TFrameFilePanel;
    
    procedure LoadLng; override;
    
    function HandleActionHotKeys(var Key: Word; Shift: TShiftState):Boolean; // handled
    
    Function ActiveFrame:TFrameFilePanel;  // get Active frame
    Function NotActiveFrame:TFrameFilePanel; // get NotActive frame :)
    function FrameLeft:TFrameFilePanel;
    function FrameRight:TFrameFilePanel;
    Function IsAltPanel:Boolean;
    procedure AppException(Sender: TObject; E: Exception);
    //check selected count and generate correct msg, parameters is lng indexs
    Function GetFileDlgStr(iLngOne, iLngMulti:Integer):String;
    procedure HotDirSelected(Sender:TObject);
    procedure pmFileListSelect(Sender:TObject); // handling user commands from popupmenu
    procedure CreatePopUpHotDir;
    procedure CreatePopUpDirHistory;
    procedure miHotAddClick(Sender: TObject);
    procedure miHotConfClick(Sender: TObject);
    procedure CalculateSpace(bDisplayMessage:Boolean);
    procedure RenameFile(sDestPath:String); // this is for F6 and Shift+F6
    procedure CopyFile(sDestPath:String); //  this is for F5 and Shift+F5
    procedure ShowRenameFileEdit(const sFileName:String);
    procedure SetNotActFrmByActFrm;
    procedure SetActiveFrame(panel: TFilePanelSelect);
    procedure CreatePanel(AOwner:TWinControl; APanel:TFilePanelSelect);
    function AddPage(ANoteBook:TNoteBook):TPage;
    procedure RemovePage(ANoteBook:TNoteBook; iPageIndex:Integer);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uTypes, fAbout, uGlobs, uLng, fOptions,{ fViewer,}
  uCopyThread, uFileList, uDeleteThread, uExecCmd,
  fMkDir, fCopyDlg, fCompareFiles,{ fEditor,} fMoveDlg, uMoveThread, uShowMsg,
  fFindDlg, uSpaceThread, fHotDir, fAttrib, fSymLink,fHardLink,
  fMultiRename, fFileProperties, uShowForm, uVFS, uGlobsPaths,
  fChown, fLinker, fSplitter, uFileProcs, lclType, LCLProc
  ,gtk, BaseUnix ;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;
  
  Application.OnException := @AppException;


  if FileExists(gpIniDir+cHistoryFile) then
    edtCommand.Items.LoadFromFile(gpIniDir+cHistoryFile);
//  writeln('frmMain.FormCreate Done');
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
   CreatePanel(AddPage(nbLeft), fpLeft);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  writeln('frmMain.Destroy');
  edtCommand.Items.SaveToFile(gpIniDir+cHistoryFile);
end;


procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.actNewTabExecute(Sender: TObject);
begin
  case PanelSelected of
  fpLeft:
     CreatePanel(AddPage(nbLeft), fpLeft);
  fpRight:
     CreatePanel(AddPage(nbRight), fpRight);
  end;
end;

procedure TfrmMain.actRemoveTabExecute(Sender: TObject);
begin
  case PanelSelected of
  fpLeft:
     RemovePage(nbLeft, nbLeft.PageIndex);
  fpRight:
     RemovePage(nbRight, nbRight.PageIndex);
  end;
end;

procedure TfrmMain.frmMainClose(Sender: TObject; var CloseAction: TCloseAction);
var
  x:Integer;
begin
  for x:=0 to 4 do
    gColumnSize[x]:=FrameLeft.dgPanel.ColWidths[x];
  gIni.Value['Main.Left']:=IntToStr(Left+cLeftBorder);// border!!
  gIni.Value['Main.Top']:=IntToStr(Top+cTopBorder); // border!!
  gIni.Value['Main.Width']:=IntToStr(Width);
  gIni.Value['Main.Height']:=IntToStr(Height);
end;

procedure TfrmMain.frmMainKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//
end;

procedure TfrmMain.frmMainShow(Sender: TObject);
begin
  CreatePanel(AddPage(nbLeft), fpLeft );
  CreatePanel(AddPage(nbRight), fpRight);

  nbLeft.Options:=[nboShowCloseButtons];
  nbRight.Options:=[nboShowCloseButtons];
  actShowSysFiles.Checked:=uGlobs.gShowSystemFiles;
//  FrameLeft.SetFocus;
  PanelSelected:=fpLeft;


  SetActiveFrame(fpLeft);
  Left:=StrToIntDef(gIni.Value['Main.Left'], Left);
  Top:= StrToIntDef(gIni.Value['Main.Top'], Top);
  Width:= StrToIntDef( gIni.Value['Main.Width'], Width);
  Height:= StrToIntDef( gIni.Value['Main.Height'], Height);
  pnlNotebooks.Width:=Width div 2;
end;

procedure TfrmMain.NoteBookCloseTabClicked(Sender: TObject);
begin
  With (Sender As TPage) do
  begin
    RemovePage(Parent as TNoteBook, PageIndex);
  end;
end;

procedure TfrmMain.pnlKeysResize(Sender: TObject);
var
  iWidth:Integer;
begin
  iWidth:=pnlKeys.Width div 8;
  btnF3.Left:=1;
  btnF3.Width:=iWidth;

  btnF4.Left:=btnF3.Left+btnF3.Width;
  btnF4.Width:=iWidth;

  btnF5.Left:=btnF4.Left+btnF4.Width;
  btnF5.Width:=iWidth;

  btnF6.Left:=btnF5.Left+btnF5.Width;
  btnF6.Width:=iWidth;

  btnF7.Left:=btnF6.Left+btnF6.Width;
  btnF7.Width:=iWidth;

  btnF8.Left:=btnF7.Left+btnF7.Width;
  btnF8.Width:=iWidth;

  btnF9.Left:=btnF8.Left+btnF8.Width;
  btnF9.Width:=iWidth;

  btnF10.Left:=btnF9.Left+btnF9.Width;
  btnF10.Width:=iWidth;

end;

procedure TfrmMain.actViewExecute(Sender: TObject);
var
  sl:TStringList;
  i:Integer;
  fr:PFileRecItem;
begin
  with ActiveFrame do
  begin
    SelectFileIfNoSelected(GetActiveItem);
    sl:=TStringList.Create;
    try
      for i:=0 to pnlFile.FileList.Count-1 do
      begin
        fr:=pnlFile.GetFileItemPtr(i);
        if fr^.bSelected and not (FPS_ISDIR(fr^.iMode)) then
        begin
          sl.Add(ActiveDir+fr^.sName);
          writeln('View.Add:',ActiveDir+fr^.sName);
        end;
      end;
      if sl.Count>0 then
        ShowViewerByGlobList(sl)
      else
        begin
          fr := pnlFile.GetActiveItem;
          if FPS_ISDIR(fr^.iMode) then
            begin
              Screen.Cursor:=crHourGlass;
              try
                pnlFile.ChooseFile(fr);
                UpDatelblInfo;
              finally
                dgPanel.Invalidate;
                Screen.Cursor:=crDefault;
              end;
            end
        end;
    finally
      FreeAndNil(sl);
      ActiveFrame.UnMarkAll;
      ActiveFrame.SetFocus;
    end;
  end;
end;

procedure TfrmMain.actEditExecute(Sender: TObject);
var
//  sl:TStringList;
  i:Integer;
  fr:PFileRecItem;
begin
  with ActiveFrame do
  begin
    SelectFileIfNoSelected(GetActiveItem);
    try
    // in this time we only one file process
      for i:=0 to pnlFile.FileList.Count-1 do
      begin
      fr:=pnlFile.GetFileItemPtr(i);
      if fr^.bSelected and not (FPS_ISDIR(fr^.iMode)) then
        begin
          ShowEditorByGlob(ActiveDir+fr^.sName);
          Break;
        end;
      end;
    finally
      ActiveFrame.UnMarkAll;
      ActiveFrame.SetFocus;
    end;
  end;
end;

procedure TfrmMain.actCopyExecute(Sender: TObject);
begin
  CopyFile(NotActiveFrame.ActiveDir);
end;

procedure TfrmMain.actRenameExecute(Sender: TObject);
begin
  RenameFile(NotActiveFrame.ActiveDir);
end;

procedure TfrmMain.actMakeDirExecute(Sender: TObject);
var
  sPath:String;
begin
  with ActiveFrame do
  begin
    try
      sPath:=ActiveDir;
      if not ShowMkDir(sPath) then Exit;
      if (sPath='') then Exit;

      if (DirectoryExists(ActiveDir+sPath)) then
      begin
        msgError(Format(lngGetString(clngMsgErrDirExists),[ActiveDir+sPath]));
        pnlFile.LastActive:=sPath;
        pnlFile.LoadPanel;
      end
      else
      begin
        if not ForceDirectory(ActiveDir+sPath) then
          msgError(Format(lngGetString(clngMsgErrForceDir),[ActiveDir+sPath]))
        else
        begin
          pnlFile.LastActive:=sPath;
          pnlFile.LoadPanel;
        end;
      end;
    finally
      ActiveFrame.SetFocus;
    end;
  end;
end;

procedure TfrmMain.actDeleteExecute(Sender: TObject);
var
  fl:TFileList;
begin
  with ActiveFrame do
    SelectFileIfNoSelected(GetActiveItem);

  case msgYesNoCancel(GetFileDlgStr(clngMsgDelSel,clngMsgDelFlDr)) of
    mmrNo:
      begin
        ActiveFrame.UnMarkAll;
        Exit;
      end;
    mmrCancel:
      begin
        Exit;
      end;
  end;

  fl:=TFileList.Create; // free at Thread end by thread
  try
    CopyListSelectedExpandNames(ActiveFrame.pnlFile.FileList,fl,ActiveFrame.ActiveDir);
    with TDeleteThread.Create(fl)do
    begin
      sDstPath:=NotActiveFrame.ActiveDir; // mozna zbytecne
      Resume;
      WaitFor;
      Free;
    end;
  finally
    frameLeft.pnlFile.LoadPanel;
    frameRight.pnlFile.LoadPanel;
    ActiveFrame.SetFocus;
  end
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  nbLeft.Width:=frmMain.Width div 2;
End;

procedure TfrmMain.actAboutExecute(Sender: TObject);
begin
  ShowAboutBox;
end;

procedure TfrmMain.actShowSysFilesExecute(Sender: TObject);
begin
  uGlobs.gShowSystemFiles:=not uGlobs.gShowSystemFiles;
  actShowSysFiles.Checked:=uGlobs.gShowSystemFiles;
// we don't want any not visited files selected
  if not uGlobs.gShowSystemFiles then
  begin
    frameLeft.pnlFile.MarkAllFiles(False);
    frameRight.pnlFile.MarkAllFiles(False);
  end;
//repaint both panels
  FrameLeft.pnlFile.UpdatePanel;
  FrameRight.pnlFile.UpdatePanel;
end;

procedure TfrmMain.LoadLng;
begin
//actions
  actExit.Caption:= lngGetString(clngActExit);
  actView.Caption:=  lngGetString(clngActView);
  actEdit.Caption:=  lngGetString(clngActEdit);
  actCopy.Caption:=  lngGetString(clngActCopy);
  actRename.Caption:=  lngGetString(clngActRename);
  actMakeDir.Caption:=  lngGetString(clngActMkDir);
  actDelete.Caption:=  lngGetString(clngActDelte);
  actOptions.Caption:=   lngGetString(clngMnuCnfOpt);
  actCompareContents.Caption:= lngGetString(clngMnuFileCmpCnt);
  actShowMenu.Caption:=  lngGetString(clngActMenu);
  actRefresh.Caption:=  lngGetString(clngMnuShwReRead);
  actSearch.Caption:= lngGetString(clngMnuCmdSearch);
  actDirHotList.Caption:= lngGetString(clngMnuCmdHotDir);
  actMarkMarkAll.Caption:=     lngGetString(clngMnuMarkSelAll);
  actMarkUnmarkAll.Caption :=lngGetString(clngMnuMarkUnSelAll);
  actShowSysFiles.Caption:=     lngGetString(clngMnuFileShowSys);
  actCalculateSpace.Caption:=     lngGetString(clngMnuFileCalc);

  actMarkInvert.Caption:=     lngGetString(clngMnuMarkInvSel);
  actMarkPlus.Caption:=   lngGetString(clngMnuMarkSelGr);
  actMarkMinus.Caption:=  lngGetString(clngMnuMarkUnSelGr);
  actChMod.Caption:=     lngGetString(clngMnuFileChAttr);
  actChown.Caption:=    lngGetString(clngMnuFileChown);

  actHardLink.Caption:=     lngGetString(clngMnuFileLink);
  actSymLink.Caption:=     lngGetString(clngMnuFileSymLink);
  actReverseOrder.Caption:= lngGetString(clngMnuShwRevOrd);
  actMultiRename.Caption:= lngGetString(clngActMultiRename);

  actRunTerm.Caption:= lngGetString(clngActRunTerm);

  actFileProperties.Caption:=     lngGetString(clngMnuFileProp);
  
// Menu
// File
  mnuFiles.Caption:=   lngGetString(clngMnuFile);
  mnuFilesSplit.Caption:=     lngGetString(clngMnuFileSplit);
  mnuFilesCombine.Caption:=     lngGetString(clngMnuFileCombine);


//Mark
  mnuMark.Caption:=   lngGetString(clngMnuMark);
  mnuMarkCmpDir.Caption:=     lngGetString(clngMnuMarkCmpDir);

//Commands
  mnuCmd.Caption:=        lngGetString(clngMnuCmd);

  mnuCmdSwapSourceTarget.Caption:=    lngGetString(clngMnuCmdSrcTrg);
  mnuCmdTargetIsSource.Caption:=   lngGetString(clngMnuCmdSrcEkvTrg);

//Show
  mnuShow.Caption:=      lngGetString(clngMnuShw);
  mnuShowName.Caption:=  lngGetString(clngMnuShwName);
  mnuShowExtension.Caption:=  lngGetString(clngMnuShwExt);
  mnuShowSize.Caption:=  lngGetString(clngMnuShwSize);
  mnuShowTime.Caption:=  lngGetString(clngMnuShwDate);
  mnuShowAttrib.Caption:=  lngGetString(clngMnuShwAttr);

//Configuration
  mnuConfig.Caption:=  lngGetString(clngMnuCnf);

//Help

  mnuHelp.Caption:=lngGetString(clngMnuHlp);
  mnuHelpAbout.Caption:=  lngGetString(clngMnuHlpAbout);
// Other
end;

function TfrmMain.HandleActionHotKeys(var Key: Word; Shift: TShiftState):Boolean; // handled
begin
  Result:=True;
  if Shift=[] then
  begin
    case Key of
     VK_F1:
       begin
         actAbout.Execute;
         Exit;
       end;
     VK_F3:
       begin
         actView.Execute;
         Exit;
       end;
     VK_F4:
       begin
         actEdit.Execute;
         Exit;
       end;

     VK_F5:
       begin
         actCopy.Execute;
         Exit;
       end;
     VK_F6:
       begin
         actRename.Execute;
         Exit;
       end;
     VK_F7:
       begin
         actMakeDir.Execute;
         Exit;
       end;
     VK_F8, VK_DELETE:
       begin
{         Key:=0;
         ActiveFrame.ClearCmdLine; // hack delete key
}
         actDelete.Execute;
         Exit;
       end;
     VK_F9:
       begin
         actShowMenu.Execute;
         Exit;
       end;

     VK_APPS:
       begin
         pmFileList.PopUp(0,0);
         Exit;
       end;
     
   end;
  end;



  if (Key=VK_Return) or (Key=VK_SELECT) then
  begin
    Key:=0;
    with ActiveFrame do
    begin
      if Shift=[] then
      begin
        if (edtCommand.Text='') then
        begin
          Screen.Cursor:=crHourGlass;
          try
            pnlFile.ChooseFile(pnlFile.GetActiveItem);
            UpDatelblInfo;
          finally
            dgPanel.Invalidate;
            Screen.Cursor:=crDefault;
          end;
          Exit;
        end
        else
        begin
          // execute command line
          ChDir(ActiveDir);
          ExecuteCommandFromEdit(edtCommand.Text);
          ClearCmdLine;
          RefreshPanel;
          Exit;
        end;
      end; //Shift=[]

      // execute active file in terminal (Shift+Enter)
      if Shift=[ssShift] then
      begin
        Chdir(ActiveDir);
        pnlFile.ExecuteFile('./'+pnlFile.GetActiveItem^.sName, True);
        Exit;
      end;
      // alt enter
      if Shift=[ssCtrl] then
      begin
        edtCmdLine.Text:=edtCmdLine.Text+pnlFile.GetActiveItem^.sName+' ';
        Exit;
      end;
      // ctrl+shift+enter
      if Shift=[ssShift,ssCtrl] then
      begin
        if (pnlFile.GetActiveItem^.sName = '..') then
        begin
          edtCmdLine.Text:=edtCmdLine.Text+(pnlFile.ActiveDir) + ' ';
        end
        else
        begin
          edtCmdLine.Text:=edtCmdLine.Text+(pnlFile.ActiveDir) + pnlFile.GetActiveItem^.sName+' ';
        end;
        Exit;
      end;
    end;
  end;  // handle ENTER with some modifier



  if Shift=[ssAlt] then
  begin



  end;

  if Shift=[ssShift] then
  begin
    if (Key=VK_F2) then
    begin
      edtCommand.SetFocus;
      Exit;
    end;

    {Kylix:
    this strange: KEY_15 is at real KEY_5
     and KEY_16 is a KEY_6, Why?
     it's a bug or feature? :-(
    }
    if ((Key=VK_F4) {or (Key=VK_F14)}) then
    begin
      actShiftF4.Execute;
      Exit;
    end;

    if ((Key=VK_F5){ or (Key=VK_F15)}) then
    begin
      actShiftF5.Execute;
      Exit;
    end;

    if ((Key=VK_F6) {or (Key=VK_F16)})then
    begin
      actShiftF6.Execute;
      Exit;
    end;
  end;

  if Shift=[ssCtrl] then
  begin

    // handle ctrl+q
    if (Key=VK_Q) then
    begin
      actExit.Execute;
      Exit;
    end;

    if (Key=VK_D) then
    begin
      actDirHotList.Execute;
      Exit;
    end;

    if (Key=VK_H) then
    begin
      actDirHistory.Execute;
      Exit;
    end;
    if (Key=VK_R) then
    begin
      actRefresh.Execute;
      Exit;
    end;
{
   // handle Ctrl+Enter
    if ((Key=VK_Return) or (Key=VK_SELECT)) and (edtCommand.Text='') then
    begin
      actCalculateSpace.Execute;
      Exit;
    end;
}
    // handle ctrl+right
    if (Key=VK_Right) then
    begin
      if (PanelSelected = fpLeft) then
        SetNotActFrmByActFrm;
      Exit;
    end;

    // handle ctrl+left
    if (Key=VK_Left) then
    begin
      if (PanelSelected = fpRight) then
        SetNotActFrmByActFrm;
      Exit;
    end;

    if (Key=VK_X) then
    begin
      actRunTerm.Execute;
      Exit;
    end;

    if (Key=VK_T) then
    begin
      actNewTab.Execute;
      Exit;
    end;
    if (Key=VK_W) then
    begin
      actRemoveTab.Execute;
      Exit;
    end;

    
    if (Key=VK_P) then
    begin
      with ActiveFrame do
      begin
        edtCmdLine.Text:=edtCmdLine.Text+(pnlFile.ActiveDir);
      end;
      Exit;
    end;

  end;
  
  // not handled
  Result:=False;
end;

procedure TfrmMain.actOptionsExecute(Sender: TObject);
begin
  inherited;
  with TfrmOptions.Create(Application) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;  
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  writeln('KeyPress:',Key);
  if Key=#27 then
    ActiveFrame.ClearCmdLine;
  if (ord(key)>31) and (ord(key)<255) then
  begin
    if ((Key='-') or (Key='*') or (Key='+') or (Key=' '))and (Trim(edtCommand.Text)='') then Exit;
    if not edtCommand.Focused then
    begin
      edtCommand.SetFocus; // handle first char of command line specially
      with ActiveFrame do
        edtCommand.Text:=edtCmdLine.Text+Key;
      Key:=#0;
    end;
  end;
end;

Function TfrmMain.ActiveFrame:TFrameFilePanel;
begin

  case PanelSelected of
    fpLeft:
      Result:=FrameLeft;
    fpRight:
      Result:=FrameRight;
  else
    assert(false,'Bad active frame');
  end;
end;

Function TfrmMain.NotActiveFrame:TFrameFilePanel;
begin
  case PanelSelected of
    fpRight: Result:=FrameLeft;
    fpLeft: Result:=FrameRight;
  else
    assert(false,'Bad active frame');
    Result:=FrameLeft;// only for compilator warning;
  end;
end;

function TfrmMain.FrameLeft: TFrameFilePanel;
begin
//  writeln(nbLeft.Page[nbLeft.PageIndex].Components[0].ClassName);
  Result:=TFrameFilePanel(nbLeft.Page[nbLeft.PageIndex].Components[0]);
end;

function TfrmMain.FrameRight: TFrameFilePanel;
begin
//  writeln(nbRight.Page[nbRight.PageIndex].Components[0].ClassName);
  Result:=TFrameFilePanel(nbRight.Page[nbRight.PageIndex].Components[0]);
  
//  Result:=TFrameFilePanel(nbRight.Page[0].Components[0]);

end;

Function TfrmMain.IsAltPanel:Boolean;
begin
  Result:= frameLeft.pnAltSearch.Visible or
           FrameRight.pnAltSearch.Visible;
end;

procedure TfrmMain.actCompareContentsExecute(Sender: TObject);
var
  sFile1, sFile2:String;
begin
  inherited;

  with frameLeft do
  begin
    SelectFileIfNoSelected(GetActiveItem);
    sFile1:=ActiveDir+pnlFile.GetActiveItem^.sName;
  end; // frameLeft;

  with frameRight do
  begin
    SelectFileIfNoSelected(GetActiveItem);
    sFile2:=ActiveDir+pnlFile.GetActiveItem^.sName;
  end; // frameright;
  if gUseExtDiff then
    begin
      ExecCmdFork(Format(gExtDiff,[sFile1, sFile2]));
      Exit;
    end;
  try
    ShowCmpFiles(sFile1, sFile2);
  finally
    frameLeft.UnMarkAll;
    FrameRight.UnMarkAll;
  end;
end;

procedure TfrmMain.AppException(Sender: TObject; E: Exception);
begin
  writeln(stdErr,'Exception:',E.Message);
  writeln(stdErr,'Func:',BackTraceStrFunc(get_caller_frame(get_frame)));
  Dump_Stack(StdErr, get_caller_frame(get_frame));
end;

procedure TfrmMain.actShowMenuExecute(Sender: TObject);
begin
  gtk_menu_item_select(PGtkMenuItem(mnuFiles.Handle));
end;

procedure TfrmMain.actRefreshExecute(Sender: TObject);
begin
  inherited;
  ActiveFrame.RefreshPanel;
end;

Function TfrmMain.GetFileDlgStr(iLngOne, iLngMulti:Integer):String;
var
  iSelCnt:Integer;
begin
  with ActiveFrame do
  begin
    SelectFileIfNoSelected(GetActiveItem);
    iSelCnt:=pnlFile.GetSelectedCount;
    if iSelCnt=0 then Abort;
    if iSelCnt >1 then
      Result:=Format(lngGetString(iLngMulti),[iSelCnt])
    else
      Result:=Format(lngGetString(iLngOne),[pnlFile.GetActiveItem^.sName])
  end;
end;

procedure TfrmMain.actMarkInvertExecute(Sender: TObject);
begin
  inherited;
  ActiveFrame.InvertAllFiles;
end;

procedure TfrmMain.actMarkMarkAllExecute(Sender: TObject);
begin
  inherited;
  ActiveFrame.MarkAll;
end;

procedure TfrmMain.actMarkUnmarkAllExecute(Sender: TObject);
begin
  inherited;
  ActiveFrame.UnMarkAll;
end;

procedure TfrmMain.actDirHotListExecute(Sender: TObject);
var
  p:TPoint;
begin
  inherited;
  CreatePopUpHotDir;
  p:=ActiveFrame.dgPanel.ClientToScreen(Point(0,0));
  pmHotList.Popup(p.X,p.Y);
end;

procedure TfrmMain.actSearchExecute(Sender: TObject);
begin
  inherited;
  ShowFindDlg(ActiveFrame.ActiveDir);
end;

procedure TfrmMain.miHotAddClick(Sender: TObject);
begin
  inherited;
  glsHotDir.Add(ActiveFrame.ActiveDir);
//  pmHotList.Items.Add();
// OnClick:=HotDirSelected;
end;

procedure TfrmMain.miHotConfClick(Sender: TObject);
begin
  inherited;
  with TfrmHotDir.Create(Application) do
  begin
    try
      LoadFromGlob;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.CreatePopUpDirHistory;
var
  mi:TMenuItem;
  i:Integer;
begin
  pmDirHistory.Items.Clear;

  // store only first gDirHistoryCount of DirHistory
  for i:=glsDirHistory.Count-1 downto 0 do
    if i>gDirHistoryCount then
      glsDirHistory.Delete(i)
    else
      Break;

  for i:=0 to glsDirHistory.Count-1 do
  begin
    mi:=TMenuItem.Create(pmDirHistory);
    mi.Caption:=glsDirHistory.Strings[i];
    mi.OnClick:=@HotDirSelected;
    pmDirHistory.Items.Add(mi);
  end;

end;


procedure TfrmMain.CreatePopUpHotDir;
var
  mi:TMenuItem;
  i:Integer;
begin
  // Create All popup menu
  pmHotList.Items.Clear;
  for i:=0 to glsHotDir.Count-1 do
  begin
    mi:=TMenuItem.Create(pmHotList);
    mi.Caption:=glsHotDir.Strings[i];
    mi.OnClick:=@HotDirSelected;
    pmHotList.Items.Add(mi);
  end;
  // now add delimiter
  mi:=TMenuItem.Create(pmHotList);
  mi.Caption:='-';
  pmHotList.Items.Add(mi);
  // now add ADD item
  mi:=TMenuItem.Create(pmHotList);
  mi.Caption:=Format(lngGetString(clngMsgPopUpHotAdd),[ActiveFrame.ActiveDir]);
  mi.OnClick:=@miHotAddClick;
  pmHotList.Items.Add(mi);

  // now add configure item
  mi:=TMenuItem.Create(pmHotList);
  mi.Caption:=lngGetString(clngMsgPopUpHotCnf);
  mi.OnClick:=@miHotConfClick;
  pmHotList.Items.Add(mi);
//  KeyPreview:=False;
end;

procedure TfrmMain.HotDirSelected(Sender:TObject);
var
  sDummy:String;
begin
 // this handler is used by HotDir and DirHistory
 // must extract & from Caption
  sDummy:=(Sender As TMenuItem).Caption;
  SDummy:=StringReplace(sDummy,'&','',[rfReplaceAll]);
  ActiveFrame.pnlFile.ActiveDir:=sDummy;
  ActiveFrame.LoadPanel;

  KeyPreview:=True;
  with ActiveFrame.dgPanel do
  begin
    if RowCount>0 then
     Row:=1;
  end;
end;

procedure TfrmMain.actDelete2Execute(Sender: TObject);
begin
  inherited;
  actDelete.Execute;
end;

procedure TfrmMain.edtCommandKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (key=VK_Down) and (Shift=[ssCtrl]) and (edtCommand.Items.Count>0) then
  begin
    Key:=0;
    edtCommand.DroppedDown:=True;
  end;
end;

procedure TfrmMain.actPathToCmdLineExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    edtCmdLine.Text:=edtCmdLine.Text+ActiveDir;
  end;
end;


procedure TfrmMain.CalculateSpace(bDisplayMessage:Boolean);
var
  fl:TFileList;
  p:TFileRecItem;
begin
  fl:=TFileList.Create; // free at Thread end by thread
  with ActiveFrame do
  begin
    p:=GetActiveItem^;
    p.sNameNoExt:=p.sName; //dstname
    p.sName:=ActiveDir+p.sName;
    p.sPath:='';

    fl.AddItem(@p);

//    CopyListSelectedExpandNames(pnlFile.FileList,fl,ActiveDir);
  end;
//  sDstPathTemp:=NotActiveFrame.ActiveDir;
  try
  with TSpaceThread.Create(fl) do
    begin
      Screen.Cursor:=crHourGlass;
      Resume;
      WaitFor;
      Screen.Cursor:=crDefault;

      if (bDisplayMessage = True) then
        ShowMessage(Format(lngGetString(clngSpaceMsg),[FilesCount, DirCount, FilesSize]));

      with ActiveFrame.GetActiveItem^ do
      begin
        if (bDisplayMessage = False) then
          iDirSize:=FilesSize;
        ActiveFrame.pnlFile.LastActive:=sName;
      end;

      Free;
    end;
  finally
    with ActiveFrame do
    begin
      Screen.Cursor:=crDefault;
//      UnMarkAll;
      pnlFile.UpdatePanel;
    end;
  end;
end;


procedure TfrmMain.actMarkPlusExecute(Sender: TObject);
begin
  ActiveFrame.MarkPlus;
end;

procedure TfrmMain.actMarkMinusExecute(Sender: TObject);
begin
  ActiveFrame.MarkMinus;
end;

procedure TfrmMain.actChModExecute(Sender: TObject);
begin
  inherited;
  try
    with ActiveFrame do
    begin
      SelectFileIfNoSelected(GetActiveItem);
      ShowAttrForm(ActiveFrame.pnlFile.FileList, ActiveFrame.ActiveDir);
    end;
  finally
    frameLeft.RefreshPanel;
    frameRight.RefreshPanel;
    ActiveFrame.SetFocus;
  end

end;

procedure TfrmMain.actSymLinkExecute(Sender: TObject);
var
  sFile1, sFile2:String;
begin
  inherited;
  try
    with ActiveFrame do
    begin
      SelectFileIfNoSelected(GetActiveItem);
      sFile1:=ActiveDir+pnlFile.GetActiveItem^.sName;
    end;

    with NotActiveFrame do
    begin
      SelectFileIfNoSelected(GetActiveItem);
      sFile2:=ActiveDir+pnlFile.GetActiveItem^.sName;
    end;
    ShowSymLinkForm(sFile1, sFile2);

  finally
    frameLeft.RefreshPanel;
    FrameRight.RefreshPanel;
    ActiveFrame.SetFocus;
  end;
end;

procedure TfrmMain.actHardLinkExecute(Sender: TObject);
var
  sFile1, sFile2:String;
begin
  inherited;
  try
    with ActiveFrame do
    begin
      SelectFileIfNoSelected(GetActiveItem);
      sFile1:=ActiveDir+pnlFile.GetActiveItem^.sName;
    end;

    with NotActiveFrame do
    begin
      SelectFileIfNoSelected(GetActiveItem);
      sFile2:=ActiveDir+pnlFile.GetActiveItem^.sName;
    end;
    ShowHardLinkForm(sFile1, sFile2);

  finally
    frameLeft.RefreshPanel;
    FrameRight.RefreshPanel;
    ActiveFrame.SetFocus;
  end;
end;

procedure TfrmMain.actReverseOrderExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    pnlFile.SortDirection:= not pnlFile.SortDirection;
    pnlFile.Sort;
  end;
end;

procedure TfrmMain.actSortByNameExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    pnlFile.SortByCol(0);
  end;
end;

procedure TfrmMain.actSortByExtExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    pnlFile.SortByCol(1);
  end;
end;

procedure TfrmMain.actSortBySizeExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    pnlFile.SortByCol(2);
  end;
end;

procedure TfrmMain.actSortByDateExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    pnlFile.SortByCol(3);
  end;
end;

procedure TfrmMain.actSortByAttrExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    pnlFile.SortByCol(4);
  end;
end;

procedure TfrmMain.actMultiRenameExecute(Sender: TObject);
var
  sl:TStringList;
  i:Integer;
begin
  with ActiveFrame do
  begin
    SelectFileIfNoSelected(GetActiveItem);

    sl:=TStringList.Create;
    try
      for i:=0 to pnlFile.FileList.Count-1 do
        if pnlFile.GetFileItem(i).bSelected then
          sl.Add(ActiveDir+pnlFile.GetFileItem(i).sName);
      if sl.Count>0 then
        ShowMultiRenameForm(sl);
    finally
      FreeAndNil(sl);
      FrameLeft.RefreshPanel;
      FrameRight.RefreshPanel;
      ActiveFrame.SetFocus;
    end;
  end;
end;

procedure TfrmMain.pmFileListPopup(Sender: TObject);
var
  mi:TMenuItem;
  i:Integer;
  pfri:PFileRecItem;
  sCmd:String;
  sl: TStringList;
begin
  // Create All popup menu
  with ActiveFrame do
  begin
    pmFileList.Items.Clear;
    sl:=TStringList.Create;
    try
      pfri:=GetActiveItem;
      if FPS_ISDIR(pfri^.iMode) or (pfri^.bIsLink) then Exit;
      if gExts.GetExtCommands(lowercase(ExtractFileExt(pfri^.sName)),sl) then
      begin
      //founded any commands
        for i:=0 to sl.Count-1 do
        begin
          sCmd:=sl.Strings[i];
          if pos('VIEW=',sCmd)>0 then Continue;  // view command is only for viewer
          pnlFile.ReplaceExtCommand(sCmd, pfri);
          mi:=TMenuItem.Create(pmFileList);
          mi.Caption:=sCmd;
          mi.Hint:=Copy(sCmd, pos('=',sCmd)+1, length(sCmd));
          // length is bad, but in Copy is corrected
          mi.OnClick:=@pmFileListSelect; // handler
          mi.Tag:=Integer(pfri);
          pmFileList.Items.Add(mi);
        end;

      end;
      // now add delimiter
      mi:=TMenuItem.Create(pmFileList);
      mi.Caption:='-';
      pmFileList.Items.Add(mi);

      // now add VIEW item
      mi:=TMenuItem.Create(pmFileList);
      mi.Caption:='{!VIEWER}'+ActiveDir+pfri^.sName;
      mi.Hint:=mi.Caption;
      mi.OnClick:=@pmFileListSelect; // handler
      pmFileList.Items.Add(mi);

      // now add EDITconfigure item
      mi:=TMenuItem.Create(pmFileList);
      mi.Caption:='{!EDITOR}'+ActiveDir+pfri^.sName;
      mi.Hint:=mi.Caption;
      mi.OnClick:=@pmFileListSelect; // handler
      pmFileList.Items.Add(mi);
    finally
      FreeAndNil(sl);
    end;

  end;
end;

procedure TfrmMain.pmFileListSelect(Sender:TObject);
var
  sCmd:String;
begin
//  ShowMessage((Sender as TMenuItem).Hint);
  sCmd:=(Sender as TMenuItem).Hint;
  with ActiveFrame do
  begin
    if Pos('{!VFS}',sCmd)>0 then
    begin
//      if VFS.VFSGetScriptName(PFileRecItem((Sender as TMenuItem).Tag).sName)<>'' then
      begin
        pnlFile.LoadPanelVFS(PFileRecItem((Sender as TMenuItem).Tag));
        Exit;
      end;
    end;
    pnlFile.ProcessExtCommand(sCmd);
  end;
end;

procedure TfrmMain.RenameFile(sDestPath:String);
var
  fl:TFileList;
  sDstMaskTemp:String;
  sCopyQuest:String;
begin
  fl:=TFileList.Create; // free at Thread end by thread
  sCopyQuest:=GetFileDlgStr(clngMsgRenSel,clngMsgRenFlDr);
  CopyListSelectedExpandNames(ActiveFrame.pnlFile.FileList,fl,ActiveFrame.ActiveDir);


  if (ActiveFrame.pnlFile.GetSelectedCount=1) then
  begin
    if sDestPath='' then
    begin
      ShowRenameFileEdit(ActiveFrame.pnlFile.GetActiveItem^.sName);
      Exit;
    end
    else
    begin
      if FPS_ISDIR(ActiveFrame.pnlFile.GetActiveItem^.iMode) then
        sDestPath:=sDestPath+'*.*'
      else
        sDestPath:=sDestPath+ActiveFrame.pnlFile.GetActiveItem^.sName;
    end;
  end
  else
    sDestPath:=sDestPath+'*.*';
  with TfrmMoveDlg.Create(Application) do
  begin
    try
      edtDst.Text:=sDestPath;
      lblMoveSrc.Caption:=sCopyQuest;
      if ShowModal=mrCancel then   Exit ; // throught finally
{        ActiveFrame.UnMarkAll;
        Exit;}
      sDestPath := ExtractFilePath(edtDst.Text);
      sDstMaskTemp:=ExtractFileName(edtDst.Text);
    finally
      Free;
    end;
  end;
  try
    with TMoveThread.Create(fl)do
    begin
      sDstPath:=sDestPath;
      sDstMask:=sDstMaskTemp;
      Resume;
      WaitFor; // temporally
      Free;
    end;

  finally
    frameLeft.RefreshPanel;
    frameRight.RefreshPanel;
    ActiveFrame.SetFocus;
  end;
end;

procedure TfrmMain.CopyFile(sDestPath:String);
var
  fl:TFileList;
  sDstMaskTemp:String;
  sCopyQuest:String;
begin
  fl:=TFileList.Create; // free at Thread end by thread
  sCopyQuest:=GetFileDlgStr(clngMsgCpSel,clngMsgCpFlDr);

  CopyListSelectedExpandNames(ActiveFrame.pnlFile.FileList,fl,ActiveFrame.ActiveDir);

  CopyListSelectedExpandNames(ActiveFrame.pnlFile.FileList,fl,ActiveFrame.ActiveDir);

  if (ActiveFrame.pnlFile.GetSelectedCount=1) and not (FPS_ISDIR(ActiveFrame.pnlFile.GetActiveItem^.iMode)) then
    sDestPath:=sDestPath+ActiveFrame.pnlFile.GetActiveItem^.sName
  else
    sDestPath:=sDestPath+'*.*';

  with TfrmCopyDlg.Create(Application) do
  begin
    try
      edtDst.Text:=sDestPath;
      lblCopySrc.Caption:=sCopyQuest;
      if ShowModal=mrCancel then
        Exit ; // throught finally
      sDestPath:=ExtractFilePath(edtDst.Text);
      sDstMaskTemp:=ExtractFileName(edtDst.Text);

    finally
      Free;
    end;
  end;
  try
    with TCopyThread.Create(fl)do
    begin
      sDstPath:=sDestPath;
      sDstMask:=sDstMaskTemp;
//      writeln(sDstMask);
      Resume;
      WaitFor;
      Free;
    end;
  finally
    frameLeft.RefreshPanel;
    frameRight.RefreshPanel;
    ActiveFrame.SetFocus;
  end;
end;

procedure TfrmMain.actShiftF5Execute(Sender: TObject);
begin
  CopyFile('');
end;

procedure TfrmMain.actShiftF6Execute(Sender: TObject);
begin
  RenameFile('');
end;

procedure TfrmMain.actShiftF4Execute(Sender: TObject);
var
  sNewFile:String;
  f:TextFile;
begin
  sNewFile:=ActiveFrame.ActiveDir+lngGetString(clngShiftF4file);
  if not InputQuery(lngGetString(clngShiftF4Open),lngGetString(clngShiftF4FileName),sNewFile) then Exit;
  if not FileExists(sNewFile) then
  begin
    assignFile(f,sNewFile);
    try
      rewrite(f);
    finally
      CloseFile(f);
    end;
  end;
  try
    ShowEditorByGlob(sNewFile);
  finally
    frameLeft.RefreshPanel;
    frameRight.RefreshPanel;
  end;
end;

procedure TfrmMain.actDirHistoryExecute(Sender: TObject);
var
  p:TPoint;
begin
  inherited;
  CreatePopUpDirHistory;
  p:=ActiveFrame.dgPanel.ClientToScreen(Point(0,0));
  pmDirHistory.Popup(p.X,p.Y);
end;

procedure TfrmMain.actCtrlF8Execute(Sender: TObject);
begin
  inherited;
  if (edtCommand.Items.Count>0) then
    edtCommand.DroppedDown:=True;
end;

procedure TfrmMain.actRunTermExecute(Sender: TObject);
begin
  ExecCmdFork(gRunTerm);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

//  writeln('Key down:',Key);
  if Key=18 then // is the ALT?
  begin
    ActiveFrame.ShowAltPanel;
    Key:=0;
    KeyPreview:=False;
    Exit;
  end;
  
  if Key=9 then
  begin
    Key:=0;
    case PanelSelected of
      fpLeft: SetActiveFrame(fpRight);
      fpRight: SetActiveFrame(fpLeft);
    end;
    Exit;
  end;

  bAltPress:=(Shift=[ssAlt]);

  // CTRL+PgUp
  if (Shift=[ssCtrl]) and (Key=VK_PRIOR) then
  begin
    ActiveFrame.pnlFile.cdUpLevel;
    Key:=0;

    Exit;
  end;

  // CTRL+PgDown
  if (Shift=[ssCtrl]) and (Key=VK_NEXT) then
  begin
    with ActiveFrame do
    begin
      if pnlFile.GetActiveItem^.sName='..' then Exit;
      pnlFile.cdDownLevel(pnlFile.GetActiveItem);
    end;
    Key:=0;
    Exit;
  end;

  // cursors keys in Lynx like mode
  if (Shift=[]) and (Key=VK_LEFT) and gLynxLike and (edtCommand.Text='') then
  begin
    ActiveFrame.pnlFile.cdUpLevel;
    Key:=0;
    Exit;
  end;

  if (Shift=[]) and (Key=VK_RIGHT) and gLynxLike and (edtCommand.Text='') then
  begin
    with ActiveFrame do
    begin
      if pnlFile.GetActiveItem^.sName='..' then Exit;
      pnlFile.cdDownLevel(pnlFile.GetActiveItem);
    end;
    Key:=0;
    Exit;
  end;

{  // this is hack for ShowModal bug
  with ActiveFrame do
  begin
    if bDialogShowed then
    begin
      Key:=0;
      bDialogShowed:=False;
      Exit;
    end;
  end;}
//  writeln(Key);
  if HandleActionHotKeys(Key, Shift) Then
  begin
    Key:=0;;
    Exit;
  end;
//  writeln(Key);

{  if bAltPress and (shift=[ssAlt]) and (key=VK_Alt) and not IsAltPanel then
  begin
//    qt.QMenuBar_activateItemAt(mnuMain.Handle, 0);
    bAltPress:=False;
    Exit;
  end;}
  bAltPress:=False;

  if (shift=[ssCtrl]) and (Key=VK_Down) then
  begin
    Key:=0;
    actCtrlF8.Execute;
    Exit;
  end;

  // handle Space key
  if (Shift=[]) and (Key=VK_Space) and (edtCommand.Text='') and (edtCommand.Text='') then
  begin
    with ActiveFrame do
    begin
//      if not AnySelected then Exit;
      if FPS_ISDIR(pnlFile.GetActiveItem^.iMode) then
        CalculateSpace(False);
      SelectFile(GetActiveItem);
      dgPanel.Invalidate;
      MakeSelectedVisible;
    end;
    Exit;
  end;

  if (Shift=[]) and (Key=VK_BACK) and (edtCommand.Text='') then
  begin
    if edtCommand.Focused then Exit;
    with ActiveFrame do
    begin
      pnlFile.cdUpLevel;
      RedrawGrid;
    end;
    Exit;
  end;




end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  KeyPreview:=True;
  ActiveFrame.SetFocus;
//  writeln('Activate');
end;

procedure TfrmMain.FrameRightedtRenameExit(Sender: TObject);
begin
// handler for both edits
//  writeln('On exit');
  KeyPreview:=True;
  ActiveFrame.edtRename.Visible:=False;
end;

procedure TfrmMain.FrameedtSearchExit(Sender: TObject);
begin
  // sometimes must be search panel closed this way
  TPanel(TEdit(Sender).Parent).Visible:=False;
  KeyPreview:=True;
end;

procedure TfrmMain.ShowRenameFileEdit(const sFileName:String);
begin
  KeyPreview:=False;
  With ActiveFrame do
  begin
    edtRename.OnExit:=@FrameRightedtRenameExit;
    edtRename.Width:=dgPanel.ColWidths[0]+dgPanel.ColWidths[1]-16;
    edtRename.Top:= (dgPanel.CellRect(0,dgPanel.Row).Top-2);
    edtRename.Left:=16;
    edtRename.Height:=dgpanel.DefaultRowHeight+4;
    edtRename.Hint:=sFileName;
    edtRename.Text:=ExtractFileName(sFileName);
    edtRename.Visible:=True;
    edtRename.SelectAll;
    edtRename.SetFocus;
  end;
end;

procedure TfrmMain.actCalculateSpaceExecute(Sender: TObject);
begin
  inherited;
  with ActiveFrame do
  begin
    if FPS_ISDIR(pnlFile.GetActiveItem^.iMode) then
      CalculateSpace(True);
    // I don't know what to do if the item is file or something else
  end;
end;

procedure TfrmMain.SetNotActFrmByActFrm;
var
  pfr:PFileRecItem;
begin
  with ActiveFrame do
  begin
    pfr:=pnlFile.GetActiveItem;
    if not assigned(pfr) then Exit;
    if FPS_ISDIR(pfr^.iMode) and (not (pfr^.sName = '..')) then
    begin
      NotActiveFrame.pnlFile.ActiveDir := ActiveDir + pfr^.sName;
    end
    else
    begin
      NotActiveFrame.pnlFile.ActiveDir := ActiveDir;
    end;
    NotActiveFrame.LoadPanel;
  end;
end;

procedure TfrmMain.actFilePropertiesExecute(Sender: TObject);
begin
  inherited;
  try
    with ActiveFrame do
    begin
      SelectFileIfNoSelected(GetActiveItem);
      ShowFileProperties(ActiveFrame.pnlFile.FileList, ActiveFrame.ActiveDir);
    end;
  finally
    frameLeft.RefreshPanel;
    frameRight.RefreshPanel;
    ActiveFrame.SetFocus;
  end
end;

procedure TfrmMain.FramedgPanelEnter(Sender: TObject);
begin
  if (Sender is TDrawGrid) then
  begin;
    with TFrameFilePanel(TDrawGrid(Sender).Parent) do
    begin
      PanelSelected:=PanelSelect;
      dgPanelEnter(Sender);
    end;
  end;
end;


procedure TfrmMain.FramelblLPathClick(Sender: TObject);
begin
//  writeln(TControl(Sender).Parent.Parent.ClassName);
  SetActiveFrame(TFrameFilePanel(TControl(Sender).Parent.Parent).PanelSelect);
  actDirHistory.Execute;
end;

procedure TfrmMain.SetActiveFrame(panel: TFilePanelSelect);
begin
  PanelSelected:=panel;
  ActiveFrame.SetFocus;
  NotActiveFrame.dgPanelExit(self);
end;

procedure TfrmMain.CreatePanel(AOwner: TWinControl; APanel:TFilePanelSelect);
begin
  with TFrameFilePanel.Create(AOwner, lblCommandPath, edtCommand) do
  begin
    edtCmdLine:=edtCommand;
    PanelSelect:=APanel;
    Init;
    ReAlign;
    pnlFile.LoadPanel;
    UpDatelblInfo;

    lblLPath.OnClick:=@FramelblLPathClick;
    edtRename.OnExit:=@FrameRightedtRenameExit;
    edtSearch.OnExit:=@FrameedtSearchExit;
    

    
    dgPanel.OnEnter:=@framedgPanelEnter;
    dgPanel.PopupMenu:=pmFileList;

  end;

end;

function TfrmMain.AddPage(ANoteBook: TNoteBook):TPage;
var
  x:Integer;
begin
  x:=ANotebook.PageCount;
  ANoteBook.Pages.Add('Page'+IntToStr(x));
  ANoteBook.ActivePage:='Page'+IntToStr(x);
  Result:=ANoteBook.Page[x];
{  writeln(Result.ClassName);
  writeln(Result.Name);}
  ANoteBook.ShowTabs:= (ANoteBook.PageCount > 1);
end;

procedure TfrmMain.RemovePage(ANoteBook: TNoteBook; iPageIndex:Integer);
begin
  if ANoteBook.PageCount>1 then
  begin
{    With ANoteBook.Page[iPageIndex] do
    begin
    if ComponentCount>0 then // must be true, but
    // component 0 is TFrameFilePanel
      Components[0].Free;
    end;}
    ANoteBook.Pages.Delete(iPageIndex);
  end;
  ANoteBook.ShowTabs:= (ANoteBook.PageCount > 1);
end;

procedure TfrmMain.edtCommandKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not edtCommand.DroppedDown and ((Key=VK_UP) or (Key=VK_DOWN)) then
  begin
    ActiveFrame.SetFocus;
    Key:=0;
  end;
end;

{mate}
procedure TfrmMain.actChownExecute(Sender: TObject);
begin
  inherited;
  try
    with ActiveFrame do
    begin
      SelectFileIfNoSelected(GetActiveitem);
      ShowChownForm(ActiveFrame.pnlFile.FileList, ActiveFrame.ActiveDir);
    end;
  finally
    frameLeft.RefreshPanel;
    frameRight.RefreshPanel;
    ActiveFrame.SetFocus;
  end
end;
{/mate}

procedure TfrmMain.actFileLinkerExecute(Sender: TObject);
var
  sl:TStringList;
  i:Integer;
begin

  with ActiveFrame do
  begin
    SelectFileIfNoSelected(GetActiveItem);
    sl:=TStringList.Create;
    try
      for i:=0 to pnlFile.FileList.Count-1 do
        if pnlFile.GetFileItem(i).bSelected then
          sl.Add(ActiveDir+pnlFile.GetFileItem(i).sName);
      if sl.Count>1 then
        ShowLinkerFilesForm(sl);
    finally
      FreeAndNil(sl);
      FrameLeft.RefreshPanel;
      FrameRight.RefreshPanel;
      ActiveFrame.SetFocus;
    end;
  end;
end;

procedure TfrmMain.actFileSpliterExecute(Sender: TObject);
var
  sl:TStringList;
  i:Integer;
begin
  with ActiveFrame do
  begin
    SelectFileIfNoSelected(GetActiveItem);

    sl:=TStringList.Create;
    try
      for i:=0 to pnlFile.FileList.Count-1 do
        if pnlFile.GetFileItem(i).bSelected then
          sl.Add(ActiveDir+pnlFile.GetFileItem(i).sName);
      if sl.Count>0 then
        ShowSplitterFileForm(sl);
    finally
      FreeAndNil(sl);
      FrameLeft.RefreshPanel;
      FrameRight.RefreshPanel;
      ActiveFrame.SetFocus;
    end;
  end;
end;

function TfrmMain.ExecuteCommandFromEdit(sCmd: String): Boolean;
var
  iIndex:Integer;
  sDir:String;
begin
  Result:=True;
  iIndex:=pos('cd ',sCmd);
  if iIndex=1 then
  begin
    sDir:=Trim(Copy(sCmd, iIndex+3, length(sCmd)));
    sDir:=IncludeTrailingBackslash(sDir);
    writeln('Chdir to:',sDir);
    if not fpchdir(PChar(sDir))=0 then
    begin
      msgError(Format('ChDir to [%s] failed!',[sDir]));
    end
    else
    begin
      with ActiveFrame.pnlFile do
      begin
        GetDir(0,sDir);
        ActiveDir:=sDir;
        writeln(sDir);
      end;
    end;
  end
  else
  begin
    if edtCommand.Items.IndexOf(sCmd)=-1 then
      edtCommand.Items.Insert(0,sCmd);
    ActiveFrame.pnlFile.ExecuteFile(sCmd, True);
    edtCommand.DroppedDown:=False;
    // only cMaxStringItems(see uGlobs.pas) is stored
    if edtCommand.Items.Count>cMaxStringItems then
      edtCommand.Items.Delete(edtCommand.Items.Count-1);
  end;
end;

initialization
 {$I fMain.lrs}
end.
