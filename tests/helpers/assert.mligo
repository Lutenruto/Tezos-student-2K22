let tx_failure (p : test_exec_error) =
    (match p with
                Rejected _ -> "Rejected"
                | Balance_too_low _ -> "Balance too low"
                | Other (k) -> k
    )

let tx_success (result : test_exec_result) =
    (match result with
        Success _ -> "Success"
        | Fail (p) -> tx_failure(p)
    )
