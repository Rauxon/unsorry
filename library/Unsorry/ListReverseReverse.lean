theorem list_reverse_reverse_thm (l : List Nat) : l.reverse.reverse = l :=
  List.reverse_reverse l
