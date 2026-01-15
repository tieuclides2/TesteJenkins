unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  calculadora;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  v : TCalculadora;
begin
  v := TCalculadora.Create;
  Edit3.Text := IntToStr(v.Add(StrToInt(Edit1.Text), StrToInt(Edit2.Text)));

end;

end.
