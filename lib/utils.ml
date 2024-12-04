open Core


(* let read_file filename = In_channel.read_lines filename; *)

(* module MySub = Sol *)
(* let read_file filename = *)
(*   match In_channel.with_file filename ~f:In_channel.input_lines with *)
(*   | Ok lines -> Ok lines *)
(*   | Error e -> Error (Error.to_string_hum e) *)

let%expect_test "-- Example expect_test --"= 120 |> Out_channel.printf "%d\n";
    [%expect{| 120 |}]
