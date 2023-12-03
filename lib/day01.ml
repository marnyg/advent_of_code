open Core

let explode_string s = List.init (String.length s) ~f:(String.get s);;
let rec stringRep n s =
  if n = 0 then "" else s ^ stringRep (n - 1) s

let map_to_nums line =
  let replacements = [
    ("one", "1"); ("two", "2"); ("three", "3");
    ("four", "4"); ("five", "5"); ("six", "6");
    ("seven", "7"); ("eight", "8"); ("nine", "9")
  ] in
  print_endline line;
  let rec replace_first str from =
    if from >= String.length str then str
    else
      match List.find_map replacements ~f:(fun (pattern, with_) ->
        if String.is_prefix ~prefix:pattern (String.sub str ~pos:from ~len:(min (String.length pattern) (String.length str - from)))
        then Some (pattern, with_)
        else None
      ) with
      | Some (pattern, with_) ->
    let before = String.sub str ~pos:0 ~len:from in
    let after = String.sub str ~pos:(from + String.length pattern) ~len:(String.length str - from - String.length pattern) in
    before ^ with_ ^ replace_first after 0
| None -> replace_first str (from + 1)
      (* | Some (pattern, with_) -> *)
      (*   let before = String.sub str ~pos:0 ~len:from in *)
      (*   let after = String.sub str ~pos:(from + String.length pattern) ~len:(String.length str - from - String.length pattern) in *)
      (*   print_endline (string_of_int from ^ stringRep from "*" ^ before ^"-" ^ with_ ^"-" ^ after); *)
      (*   before ^ with_ ^ replace_first after from  *)
      (* | None ->   *)
      (*   print_endline (string_of_int from ^ stringRep from "^" ^str); *)
      (*   replace_first (String.sub str ~pos:1 ~len:(String.length str) ) 0 *)
  in

  replace_first line 0



let find_first_number_in_line line = 
    (* Fmt.pr "\n%s" line; *)
    explode_string line
    (* |> List.map ~f:(fun x->printf "\n%c" x;x ) *)
    |> List.filter_map ~f:(fun s -> 
            match s with
            | '0'..'9' -> Int.of_string (String.of_char s) |> Option.some
            | _ -> None)
    (* |> List.map ~f:(fun x->Fmt.pr "\n%d" x;x ) *)
    |> List.hd_exn
    (* |> fun x->Fmt.pr "\n%d" x;x  *)

let find_last_number_in_line line = 
    explode_string line
    |> List.filter_map ~f:(fun s -> 
            match s with
            | '0'..'9' -> Int.of_string (String.of_char s) |> Option.some
            | _ -> None)
    |> List.last_exn

let find_first_and_last_number_in_line line = 
    let numbers = line
    |> explode_string 
    |> List.filter_map ~f:(fun s -> 
            match s with
            | '0'..'9' -> Int.of_string (String.of_char s) |> Option.some
            | _ -> None) in
    (List.hd_exn numbers, List.last_exn numbers)

let find_first_and_last_number_in_line_part2 line = 
    let numbers = line
    |> map_to_nums
    |> (fun x->Fmt.pr "\n->%s" x;x )
    |> explode_string 
    |> List.filter_map ~f:(fun s -> 
            match s with
            | '0'..'9' -> Int.of_string (String.of_char s) |> Option.some
            | _ -> None) in
    (List.hd_exn numbers, List.last_exn numbers)

