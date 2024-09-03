unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, edit;

type

  { TfMain }

  TfMain = class(TForm)
    bAdd: TButton;
    bCat: TButton;
    bExit: TButton;
    bEdit: TButton;
    bDel: TButton;
    BG: TImage;
    bgMoveTimer: TTimer;
    SG: TStringGrid;
    procedure bAddClick(Sender: TObject);
    procedure bCatClick(Sender: TObject);
    procedure bDelClick(Sender: TObject);
    procedure bEditClick(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure bgMoveTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;
type
  SpaceShip = record
    Model: string[100];
    Manufactorer: string[100];
    Manned: boolean;
    CrewCapacity: integer;
    Date: string[100];
    Mission: string[20];
  end;
var
  fMain: TfMain;
  moveDir, isCatting: boolean;
  adres: string;

implementation

{$R *.lfm}

{ TfMain }

procedure TfMain.bExitClick(Sender: TObject);
begin
  fMain.Close;
end;

procedure TfMain.bgMoveTimerTimer(Sender: TObject);
begin
  if BG.Left = 0 then
     moveDir := False;
  if BG.Left = -1500 then
     moveDir := True;
  if moveDir then begin
     BG.Top := BG.Top + 1;
     BG.Left := BG.Left + 1;
  end
  else begin
     BG.Top := BG.Top - 1;
     BG.Left := BG.Left - 1;
  end;
end;

procedure TfMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
  var
  MyShip: SpaceShip;
  f: file of SpaceShip;
  i: integer;
begin
  if SG.RowCount = 1 then exit;
  try
    AssignFile(f, adres + 'spaceships.dat');
    Rewrite(f);
    for i := 1 to SG.RowCount-1 do begin
      MyShip.Model:= SG.Cells[0, i];
      MyShip.Manufactorer:= SG.Cells[1, i];
      case SG.Cells[2, i] of
           'Да': MyShip.Manned := True;
           'Нет': MyShip.Manned := False;
      end;
      MyShip.CrewCapacity:= strtoint(SG.Cells[3, i]);
      MyShip.Date:= SG.Cells[4, i];
      MyShip.Mission:= SG.Cells[5, i];
      Write(f, MyShip);
    end;
  finally
    CloseFile(f);
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
  var
    MyShip: SpaceShip;
    f: file of SpaceShip;
    i: integer;
  begin
    adres:= ExtractFilePath(ParamStr(0));
    SG.Cells[0, 0]:= 'Модель';
    SG.Cells[1, 0]:= 'Производитель';
    SG.Cells[2, 0]:= 'Пилотируемый';
    SG.Cells[3, 0]:= 'Вместимость';
    SG.Cells[4, 0]:= 'Дата запуска';
    SG.Cells[5, 0]:= 'Миссия';
    SG.ColWidths[0]:= 345;
    SG.ColWidths[1]:= 230;
    SG.ColWidths[2]:= 230;
    SG.ColWidths[3]:= 200;
    SG.ColWidths[4]:= 200;
    SG.ColWidths[5]:= 170;
    if not FileExists(adres + 'spaceships.dat') then exit;
    try
      AssignFile(f, adres + 'spaceships.dat');
      Reset(f);
      while not Eof(f) do begin
        Read(f, MyShip);
          SG.RowCount:= SG.RowCount + 1;
          SG.Cells[0, SG.RowCount-1]:= MyShip.Model;
          SG.Cells[1, SG.RowCount-1]:= MyShip.Manufactorer;
          if MyShip.Manned then
             SG.Cells[2, SG.RowCount-1] := 'Да'
          else
             SG.Cells[2, SG.RowCount-1] := 'Нет';
          SG.Cells[3, SG.RowCount-1]:= inttostr(MyShip.CrewCapacity);
          SG.Cells[4, SG.RowCount-1]:= MyShip.Date;
          SG.Cells[5, SG.RowCount-1]:= MyShip.Mission;
      end;
    finally
      CloseFile(f);
    end;
end;

procedure TfMain.bCatClick(Sender: TObject);
begin
  SG.Visible := isCatting;
  bAdd.Visible := isCatting;
  bEdit.Visible := isCatting;
  bDel.Visible := isCatting;
  bExit.Visible := isCatting;
  if isCatting then
     bCat.Caption := 'Наблюдать за котами'
  else
    bCat.Caption := 'Вернуться к работе';
  isCatting := not isCatting;
end;

procedure TfMain.bDelClick(Sender: TObject);
begin
  if SG.RowCount = 1 then exit;
  if MessageDlg('Требуется подтверждение',
                'Вы действительно хотите удалить запись "' +
                SG.Cells[0, SG.Row] + '"?',
      mtConfirmation, [mbYes, mbNo, mbIgnore], 0) = mrYes then
         SG.DeleteRow(SG.Row);
end;

procedure TfMain.bEditClick(Sender: TObject);
begin
  if SG.RowCount = 1 then exit;
  bgMoveTimer.Enabled := False;
  fEdit.eModel.Text := SG.Cells[0, SG.Row];
  fEdit.eManuf.Text := SG.Cells[1, SG.Row];
  case SG.Cells[2, SG.Row] of
       'Да': fEdit.checkPilot.Checked := True;
       'Нет': fEdit.checkPilot.Checked := False;
  end;
  fEdit.eCrewCap.Text := SG.Cells[3, SG.Row];
  fEdit.eDate.Text := SG.Cells[4, SG.Row];
  fEdit.eMission.Text := SG.Cells[5, SG.Row];
  fEdit.ModalResult:= mrNone;
  fEdit.ShowModal;
  if (fEdit.eModel.Text <> '') and (fEdit.eManuf.Text <> '') and
  (fEdit.eMission.Text <> '') and (fEdit.eDate.Text <> '') and
  (fEdit.eCrewCap.Text <> '') and (fEdit.ModalResult = mrOk) then begin
    SG.Cells[0, SG.Row] := fEdit.eModel.Text;
    SG.Cells[1, SG.Row] := fEdit.eManuf.Text;
    if fEdit.checkPilot.Checked then
       SG.Cells[2, SG.RowCount-1] := 'Да'
    else
       SG.Cells[2, SG.Row] := 'Нет';
    SG.Cells[3, SG.Row] := fEdit.eCrewCap.Text;
    SG.Cells[4, SG.Row] := fEdit.eDate.Text;
    SG.Cells[5, SG.Row] := fEdit.eMission.Text;
  end;
  bgMoveTimer.Enabled := True;
  exit;
end;

procedure TfMain.bAddClick(Sender: TObject);
begin
  bgMoveTimer.Enabled := False;
  fEdit.eModel.Text := '';
  fEdit.eManuf.Text := '';
  fEdit.eMission.Text := '';
  fEdit.eCrewCap.Text := '';
  fEdit.eDate.Text := '';
  fEdit.eDate.EditMask := '';
  fEdit.checkPilot.Checked := False;
  fEdit.eCrewCap.Enabled := False;
  fEdit.ModalResult:= mrNone;
  fEdit.ShowModal;
  if (fEdit.eModel.Text <> '') and (fEdit.eManuf.Text <> '') and
  (fEdit.eMission.Text <> '') and (fEdit.eDate.Text <> '') and
  (fEdit.eCrewCap.Text <> '') and (fEdit.ModalResult = mrOk) then begin
    SG.Cells[0, SG.RowCount-1] := fEdit.eModel.Text;
    SG.Cells[1, SG.RowCount-1] := fEdit.eManuf.Text;
    if fEdit.checkPilot.Checked then
       SG.Cells[2, SG.RowCount-1] := 'Да'
    else
       SG.Cells[2, SG.RowCount-1] := 'Нет';
    SG.Cells[3, SG.RowCount-1] := fEdit.eCrewCap.Text;
    SG.Cells[4, SG.RowCount-1] := fEdit.eDate.Text;
    SG.Cells[5, SG.RowCount-1] := fEdit.eMission.Text;
  end;
  bgMoveTimer.Enabled := True;
  exit;
end;

end.

