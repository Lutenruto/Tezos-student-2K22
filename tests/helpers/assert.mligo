let tx_success (result: test_exec_result ): bool = 
    match result with
        Success _ -> ()
        | Fail(err) -> 
            (match err with 
                Rejected _ -> false
                | Balance_too_low _ -> false
                | Other(_s) -> false
            )

let tx_failure (result: test_exec_result): bool = 
   match result with
        Success _ -> false
        | Fail(err) -> 
            (match err with 
                Rejected _ -> ()
                | Balance_too_low _ -> ()
                | Other(_s) -> ()
            )
