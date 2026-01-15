unit Unit2;

interface

uses
  DUnitX.TestFramework, calculadora;

type
  [TestFixture]
  TMyTestObject = class
  private
  FCalc : TCalculadora;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2,3')]
    [TestCase('TestB','3,4,7')]
    procedure Test2(const A : Integer; const B : Integer; const R : Integer);
  end;

implementation

procedure TMyTestObject.Setup;
begin
  FCalc := TCalculadora.create;
end;

procedure TMyTestObject.TearDown;
begin
  FCalc.free;
end;

procedure TMyTestObject.Test1;
var
  Resultado: Integer;
begin
  Resultado := FCalc.Add(2,2);

  Assert.IsTrue(Resultado = 4, 'add está com erro');
end;

procedure TMyTestObject.Test2(const A : Integer;const B : Integer; const R : Integer);
var
  v: integer;
begin
  v := FCalc.Add(A, B);
  if v = r  then
    Assert.Pass('Passouu!')
  else
    Assert.Fail('Erro!');
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
