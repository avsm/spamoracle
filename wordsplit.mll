(* Decompose a string into words. *)

{
(* Map uppercase to lowercase.  Remove ISO Latin 1 accents. *)

let tbl = "\
\000\001\002\003\004\005\006\007\008\t\n\011\012\013\014\015\
\016\017\018\019\020\021\022\023\024\025\026\027\028\029\030\031 \
!\"#$%&'()*+,-./\
0123456789:;<=>?\
@abcdefghijklmno\
pqrstuvwxyz[\\]^_\
`abcdefghijklmno\
pqrstuvwxyz{|}~\127\
\128\129\130\131\132\133\134\135\136\137\138\139\140\141\142\143\
\144\145\146\147\148\149\150\151\152\153\154\155\156\157\158\159\
\160���������������\
����������������\
aaaaaaeceeeeiiii\
�nooooo�ouuuuyps\
aaaaaaeceeeeiiii\
�nooooo�ouuuuypy"

let normalize s =
  for i = 0 to String.length s - 1 do
    s.[i] <- tbl.[Char.code s.[i]]
  done

}


let word_constituent =
  ['a'-'z' 'A'-'Z' '0'-'9' '-' '\'' '$' '%'
   (* The following is for French; 
      adapt to the languages you're interested in *)
   '\164' (* Euro *)
   '�' '�' '�' '�' '�' '�' '�' '�' '�' '�' '�' '�' '�'
   '�' '�' '�' '�' '�' '�' '�' '�' '�' '�' '�' '�' '�']

let uppercase_letter =
  ['A'-'Z']

let weird_character =
  ['\127' - '\255']

rule split = parse
    uppercase_letter uppercase_letter uppercase_letter uppercase_letter *
      { fun action ->
          let s = Lexing.lexeme lexbuf in
          action ("U" ^ string_of_int (String.length s));
          if String.length s <= 12 then (normalize s; action s);
          split lexbuf action }
  | word_constituent word_constituent word_constituent word_constituent *
      { fun action ->
          let s = Lexing.lexeme lexbuf in
          if String.length s <= 12 then (normalize s; action s);
          split lexbuf action }
  | weird_character weird_character weird_character weird_character *
      { fun action ->
          let s = Lexing.lexeme lexbuf in
          action ("W" ^ string_of_int (String.length s));
          split lexbuf action }
  | eof
      { fun action -> () }
  | _
      { split lexbuf }

{

let iter action txt =
  split (Lexing.from_string txt) action

}
