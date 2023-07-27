module swap_account::Fee_Collector{

    // use pancake::swap::router;
    use hippo_aggregator::aggregator;
    use std::signer;
    
    public fun swap_x_to_y<X, Y, Z, OutCoin, E1, E2, E3>(
        sender: &signer,
        num_steps: u8,
        first_dex_type: u8,
        first_pool_type: u64,
        first_is_x_to_y: bool, // first trade uses normal order
        second_dex_type: u8,
        second_pool_type: u64,
        second_is_x_to_y: bool, // second trade uses normal order
        third_dex_type: u8,
        third_pool_type: u64,
        third_is_x_to_y: bool, // second trade uses normal order
        x_in: u64,
        m_min_out: u64,
        ){
        //swap X->Y
        aggregator::swap<X, Y, Z, OutCoin, E1, E2, E3>(
        sender,
        num_steps,
        first_dex_type,
        first_pool_type,
        first_is_x_to_y, 
        second_dex_type,
        second_pool_type,
        second_is_x_to_y, 
        third_dex_type,
        third_pool_type,
        third_is_x_to_y, 
        x_in,
        m_min_out,
    );
    }
 
}


