let tx_failure (res, expected: test_exec_result * string) : unit =
    let expected_err = Test.eval expected in
    match res with
        Success _ -> failwith "contract success but expected failure"
        | Fail (error) ->
            (match error with 
                Rejected (reject_err) -> 
                    let (michelson_err, address) = reject_err in
                    assert (michelson_err = expected_err)
                | Balance_too_low _ -> failwith "contract failed: balance too low"
                | Other s -> failwith s
            )

let tx_success (res : test_exec_result) (expected : string) =
  match res with
      Success (actual, _) -> assert (actual = expected)
    | Fail (res) -> tx_failure res expected