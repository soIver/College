program task2;
type PNode = ^Node;
     Node = record 
       word: string[40];
       count: integer;
       next: PNode;
     end;
var
  Head, pp, NewNode: Pnode;
  f: Text;
  NewWord, newResult: string;
  en3 := Encoding.GetEncoding(65001);
  
function CreateNode(NewWord: string): PNode;
var NewNode: PNode;
begin
  New(NewNode);
  NewNode^.word := NewWord;
  NewNode^.count := 1;
  NewNode^.next := nil;
  Result := NewNode;
end;

procedure AddFirst (var Head: PNode; NewNode: PNode);
begin
  NewNode^.next := Head;
  Head := NewNode;
end;

procedure AddAfter(var p: PNode; NewNode: PNode);
begin
  NewNode^.next := p^.next;
  p^.next := NewNode;
end;

procedure AddLast (var Head: PNode; NewNode: PNode);
var pp: PNode;
begin
  if Head = nil then
    AddFirst (Head, NewNode)
  else begin
    pp := Head;
    while pp^.next <> nil do
      pp := pp^.next;
    AddAfter (pp, NewNode);
  end;
end;

procedure AddBefore(var Head: PNode; p, NewNode: PNode);
var pp: PNode;
begin
  pp := Head;
  if p = Head then
    AddFirst (Head, NewNode)
  else begin
    while (pp <> nil)  and  (pp^.next <> p) do
      pp := pp^.next;
    if pp <> nil then AddAfter (pp, NewNode);
  end;
end;

function FindWord(Head: PNode; NewWord: string): PNode;
var pp: PNode;
begin
  pp := Head;
  while (pp <> nil) and (NewWord <> pp^.word) do 
    pp := pp^.next;
  Result := pp;
end;

function FindPlace(Head: PNode; NewWord: string): PNode;
var pp: PNode;
begin
  pp := Head;
  while (pp <> nil) and (NewWord > pp^.word) do
    pp := pp^.next;
  Result := pp;
end;

procedure Incrementation(Head: PNode; NewWord: string);
var pp: PNode;
begin
  pp := Head;
  while not (NewWord = pp^.word) do
    pp := pp^.next;
  pp^.count := pp^.count + 1;
end;

function TakeWord (F: Text): string;
var c: char;
begin
  Result := '';
  c := ' ';
  while not eof(f) and (c <= ' ') do 
    read(F, c);  
  while not eof(f) and (c > ',') do begin
    Result := Result + c;
    read(F, c);
  end;
  if eof(f) then
    Result := Result + c
end;

begin
  Head := nil;
  NewNode := nil;
  assign(f, 'words.txt');
  reset(f, en3);
  
  while not eof(f) do begin
  NewWord := TakeWord(f);
  if FindWord(Head, NewWord) = nil then
    AddBefore(Head, FindPlace(Head, NewWord), CreateNode(NewWord))
  else
    Incrementation(Head, NewWord);
  end;
    
  pp := Head;
  while pp <> nil do begin
    write(pp^.word + ': ');
    writeln(pp^.count);
    pp := pp^.next;
  end;
  close(f);
end.