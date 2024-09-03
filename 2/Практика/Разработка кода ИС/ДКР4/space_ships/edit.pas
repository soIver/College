unit edit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  MaskEdit, ExtCtrls;

type

  { TfEdit }

  TfEdit = class(TForm)
    bSave: TBitBtn;
    bCancel: TBitBtn;
    checkPilot: TCheckBox;
    eCrewCap: TEdit;
    eMission: TComboBox;
    eModel: TEdit;
    eManuf: TEdit;
    eDate: TMaskEdit;
    catShip: TImage;
    catTimer: TTimer;
    Title: TLabel;
    procedure catTimerTimer(Sender: TObject);
    procedure checkPilotChange(Sender: TObject);
    procedure eDateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  fEdit: TfEdit;

implementation

{$R *.lfm}

{ TfEdit }

procedure TfEdit.eDateClick(Sender: TObject);
begin
  eDate.EditMask := '00.00.0000;_';
  eDate.SelectAll;
end;

procedure TfEdit.checkPilotChange(Sender: TObject);
begin
  eCrewCap.Enabled := checkPilot.Checked;
end;

procedure TfEdit.catTimerTimer(Sender: TObject);
begin
  catShip.Left := catShip.Left + 1;
  catShip.Top := catShip.Top - 2;
  if catShip.Top = -600 then
     catTimer.Enabled := False;


end;

procedure TfEdit.FormShow(Sender: TObject);
begin
  eModel.SetFocus;
  catShip.Left := 180;
  catShip.Top := 600;
  catTimer.Enabled := True;
end;


end.

