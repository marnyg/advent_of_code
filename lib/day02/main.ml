open Core

let () = print_endline "Day02 - part 1"

let input_example =
  {|7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9|}
;;

(* let () = input_example |> printf "input_example: %s\n";; *)

let split_lines str = String.split_on_chars ~on:[ '\n' ] str

let all_some lst =
  List.fold lst ~init:(Some []) ~f:(fun acc x ->
    match acc, x with
    | Some acc_list, Some value -> Some (value :: acc_list)
    | _ -> None)
  |> Option.map ~f:List.rev
;;

(* "7   6 g 4 2 1" *)
let parse_line line =
  line
  |> String.split_on_chars ~on:[ ' ' ]
  |> List.filter ~f:(fun s -> not (String.is_empty s))
  |> List.map ~f:Int.of_string_opt
  |> all_some
  |> function
  | Some nums -> nums
  | None -> []
;;

let process_line line = parse_line line

(* match [1; 2 ;3 ] with *)
(*   | first;; second;;_ -> first < second *)
(*   | _ -> false *)
(* ;; *)

let increasing report =
  match report with
  | f :: s :: _ -> f > s
  | _ :: [] -> false
  | [] -> false
;;

let check_if_valid_report report =
  match report with
  | first :: second :: tail when increasing report -> true
  | first :: second :: tail when not (increasing report) -> true
  | first :: second -> false
  | first :: [] -> false
  | [] -> false
;;

List.reduce ~f:( + ) [ 1; 2; 3 ];;
split_lines input_example |> List.map ~f:parse_line
(* |> List.map ~f:check_if_valid_report *)

(* Or stick with List.equal which is clearer and doesn't need type annotations *)
let%test "parse invalidline better" =
  List.equal Int.equal (parse_line "k 7 6 4 2 1") []
;;

let%test "parse valid line better" =
  List.equal Int.equal (parse_line "7 6 4 2 1") [ 7; 6; 4; 2; 1 ]
;;
