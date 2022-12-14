let tx_failure (res, expected_error: test_exec_result * test_exec_error) : unit =
    match res with
        Success _ -> failwith "contract success but expected failure"
        | Fail (error) -> assert(error = expected_error)


let tx_success (res: test_exec_result) : unit =
    match res with
        Success _ -> ()
        | Fail _ -> failwith "contract failure but expected success"