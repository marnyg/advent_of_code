
open Core
open MyPro

(* let _ =  Utils.read_file "inputs/day01-1.txt"  *)
(*     |> List.iter ~f:(printf "\n%s");  *)
(*     print_endline "\n----------";; *)

let _ = print_endline "\nPart1";;
let _ = print_endline "----------";;
let _ = 
    Utils.read_file "inputs/day01-1.txt" 
    |> List.map ~f:Day01.find_first_and_last_number_in_line
    (* |> List.map ~f:(fun (a,b) -> printf "\n%d %d" a b; a, b)  *)
    |> List.map ~f:(fun (a,b) -> string_of_int (a) ^ string_of_int (b))
    (* |> List.iter ~f:(fun b -> printf "\n%s"  b)  *)
    |> List.fold ~init:0 ~f:(fun acc x -> acc + (int_of_string x))
    |> printf "\n%d"


let _ = print_endline "\n----------";;
let _ = print_endline "\n\nPart2";;
let _ = print_endline "----------";;

let _ =  Utils.read_file "inputs/day01-2.txt" 
    |> List.iter ~f:(printf "\n%s");;
    (* |> List.iter ~f:(printf "\n%s");  *)
let _ =  Utils.read_file "inputs/day01-1.txt" 
    |> List.map ~f:Day01.find_first_and_last_number_in_line_part2
    (* |> List.map ~f:(fun (a,b) -> printf "\n%d %d" a b; a, b)  *)
    |> List.map ~f:(fun (a,b) -> string_of_int (a) ^ string_of_int (b))
    (* |> List.map ~f:(fun b -> printf "\n %s"  b;  b)  *)
    |> List.fold ~init:0 ~f:(fun acc x -> acc + (int_of_string x))
    |> printf "\n%d"
    (* |> List.iter ~f:(printf "\n%s");  *)
    (* print_endline "\n----------";; *)

let _ = print_endline "----------";;
