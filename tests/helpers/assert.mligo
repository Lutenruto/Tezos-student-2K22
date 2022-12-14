let tx_success (result : test_exec_result) =
    (match result with
    Success -> "Success"
    | Fail (p) -> tx_failure(p)
    )
    

let tx_failure (result : test_exec_error) =
    (match p with
                Rejected -> "Rejected"
                | Balance_too_low -> "Balance too low"
                | Other (k) -> k
    )