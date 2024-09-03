program task5;
type PNode = ^Node;
     Node = record
       el: string;
       next: PNode;
     end;
var
  Head: PNode;
  f1, f2: Text;
  i: integer;
  newel: string;
  
procedure Push(var Head: PNode; newel: string);
var NewNode: PNode;
begin
  New(NewNode);
  NewNode^.el := newel;
  NewNode^.next := Head;
  Head := NewNode; 
end;

function Pop (var Head: PNode): string;
var q: PNode;
begin
  if Head = nil then begin
    Exit;
  end;
  Result := Head^.el;
  q := Head;
  Head := Head^.next;
  Dispose(q);
end;

function TakeEl (F: Text) : string;
var c: char;
begin
  Result := '';
  c := ' ';
  while not eof(f) and (c <= ' ') do 
    read(F, c);  
  while not eof(f) and (c > ' ') do begin
    Result := Result + c;
    read(F, c);
  end;
end;

begin
  assign(f1, 'input.txt');
  assign(f2, 'output.txt');
  rewrite(f1);
  for i := 1 to 10 do
    write(f1, random(200) + ' ');
  close(f1);
  reset(f1);
  rewrite(f2);
  
  Head := nil;
  while not eof(f1) do begin
    newel := TakeEl(f1);
    Push(Head, newel);
  end;
  while Head <> nil do
    write(f2, Pop(Head) + ' ');
  close(f1);
  close(f2);
end.