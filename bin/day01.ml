open Core
open AdvLib

let () = print_endline "Day01 - part 1"
let () = In_channel.read_all "inputs/day01.txt" |> Day01.print_solution
let () = print_endline "Day01 - part 2"
let () = In_channel.read_all "inputs/day01.txt" |> Day01.print_solution_part2
