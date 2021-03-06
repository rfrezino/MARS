(*
  Copyright 2015-2016, MARS - REST Library

  Home: https://github.com/MARS-library

*)
unit Server.Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ExtCtrls

  , System.Diagnostics
  , IdContext

  , MARS.Core.Engine
  , MARS.http.Server.Indy


//  , MARS.Core.Utils
  , MARS.Core.Application
  , MARS.Diagnostics.Manager
  , MARS.Diagnostics.Resources
//  , MARS.Core.Token
  ;

type
  TMainForm = class(TForm)
    TopPanel: TPanel;
    StartButton: TButton;
    StopButton: TButton;
    MainActionList: TActionList;
    StartServerAction: TAction;
    StopServerAction: TAction;
    PortNumberEdit: TEdit;
    Label1: TLabel;
    procedure StartServerActionExecute(Sender: TObject);
    procedure StartServerActionUpdate(Sender: TObject);
    procedure StopServerActionExecute(Sender: TObject);
    procedure StopServerActionUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FServer: TMARShttpServerIndy;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
   MARS.Core.MessageBodyWriter
  , MARS.Core.MessageBodyWriters
  , MARS.Data.MessageBodyWriters
  , MARS.Data.FireDAC.MessageBodyWriters
  ;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopServerAction.Execute;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  StartServerAction.Execute;
end;

procedure TMainForm.StartServerActionExecute(Sender: TObject);
begin
  // Create http server
  FServer := TMARShttpServerIndy.Create;

  FServer.ConfigureEngine('/rest')
    .SetPort(StrToIntDef(PortNumberEdit.Text, 8080))
    .SetName('MARS HelloWorld')
    .SetThreadPoolSize(5)

    // Add and configure an application
    .AddApplication('/default')
      .SetName('Default')
      .SetResources([
        'Server.MainData.TMainDataResource'
      ])
  ;

  if not FServer.Active then
    FServer.Active := True;
end;

procedure TMainForm.StartServerActionUpdate(Sender: TObject);
begin
  StartServerAction.Enabled := (FServer = nil) or (FServer.Active = False);
end;

procedure TMainForm.StopServerActionExecute(Sender: TObject);
begin
  FServer.Active := False;
  FreeAndNil(FServer);
end;

procedure TMainForm.StopServerActionUpdate(Sender: TObject);
begin
  StopServerAction.Enabled := Assigned(FServer) and (FServer.Active = True);
end;

end.
