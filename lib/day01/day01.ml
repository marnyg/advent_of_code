open Core
open Base

let split_line_and_strip line =
  line
  |> String.split ~on:' '
  |> List.filter ~f:(fun s -> not (String.is_empty s))
  |> List.map ~f:Int.of_string
  |> function
  | [ a; b ] -> a, b
  | _ -> 0, 0
;;

let lists_of_input raw_string =
  raw_string
  |> String.split_on_chars ~on:[ '\n' ]
  |> List.map ~f:split_line_and_strip
  |> List.unzip
;;

let solv_part1 raw_string =
  lists_of_input raw_string
  |> fun (a, b) ->
  (List.sort a ~compare:Int.compare, List.sort b ~compare:Int.compare)
  |> fun (a, b) ->
  List.map2_exn a b ~f:(fun a b -> abs (a - b)) |> List.reduce ~f:( + )
;;

let solv_part2 raw_string =
  let list1, list2 = lists_of_input raw_string in
  let find_count_of_element el =
    el
    |> fun el ->
    List.fold ~init:0 ~f:(fun acc e -> acc + if e = el then 1 else 0) list2
  in
  List.map list1 ~f:find_count_of_element
  |> List.zip_exn list1
  |> List.fold ~init:0 ~f:(fun acc (a, b) -> acc + (a * b))
;;

let print_solution data =
  data
  |> solv_part1
  |> function
  | Some x -> printf "%d\n" x
  | None -> printf "0\n"
;;

let print_solution_part2 data = data |> solv_part2 |> Fmt.pr "%d\n"

let raw = {|3   4
4   3
2   5
1   3
3   9
3   3
|}

let%test "solve subset" = solv_part1 raw |> Option.is_some
let%test "solve subset" = solv_part1 raw |> Option.value ~default:0 = 11
let%test "solve subset part2" = solv_part2 raw |> fun x -> x |> fun x -> x = 31
