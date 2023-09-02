module swap_account::AnimeLiquid{

    use liquidswap::router_v2;
    use liquidswap::curves::Uncorrelated;
    use liquidswap::curves::Stable;
    use cetus_amm::amm_config;
    use cetus_amm::amm_swap;
    use cetus_amm::amm_utils;
    use pancake::swap;
    use pancake::swap_utils;

    #[view]
    public fun get_amount_out_Uncorrelated<X, Y>(amount_in: u64): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Uncorrelated>(amount_in);
    (coin_out_val)
    }
    // 0:"0x1::aptos_coin::AptosCoin"
    // 1:"0xf22bede237a07e121b56d91a491eb7bcdfd1f5907926a9e58338f964a01b17fa::asset::USDT"
    // 2:"0x190d44266241744264b964a37b8f09863167a12d3e70cda39376cfb4e3561e12::curves::Uncorrelated"
    //100000000 to 5669811 

    #[view]
    public fun get_amount_in_Uncorrelated<X, Y>(amount_out: u64): u64 {
    let value = router_v2::get_amount_in<X, Y, Uncorrelated>(amount_out);
    (value)// ex: 30 for 0.3%
    }
    // 0:"0xf22bede237a07e121b56d91a491eb7bcdfd1f5907926a9e58338f964a01b17fa::asset::USDT"
    // 1:"0x1::aptos_coin::AptosCoin"
    // 2:"0x190d44266241744264b964a37b8f09863167a12d3e70cda39376cfb4e3561e12::curves::Uncorrelated"
    //5000000 to 285501 

    #[view]
    public fun get_amount_out_Stable<X, Y>(amount_in: u64): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Stable>(amount_in);
    (coin_out_val)
    }
    // 0:"0x1::aptos_coin::AptosCoin"
    // 1:"0xf22bede237a07e121b56d91a491eb7bcdfd1f5907926a9e58338f964a01b17fa::asset::USDT"
    // 2:"0x190d44266241744264b964a37b8f09863167a12d3e70cda39376cfb4e3561e12::curves::Uncorrelated"
    //100000000 to 5538261 

    #[view]
    public fun get_amount_in_Stable<X, Y>(amount_out: u64): u64 {
    let value = router_v2::get_amount_in<X, Y, Stable>(amount_out);
    (value)// ex: 30 for 0.3%
    }
    // 0:"0xf22bede237a07e121b56d91a491eb7bcdfd1f5907926a9e58338f964a01b17fa::asset::USDT"
    // 1:"0x1::aptos_coin::AptosCoin"
    // 2:"0x190d44266241744264b964a37b8f09863167a12d3e70cda39376cfb4e3561e12::curves::Uncorrelated"
    //5000000 to 285136 


    #[view]
    public fun get_amount_out_Uncorrelated_fee<X, Y>(amount_in: u64,fee_bips: u8): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Uncorrelated>(amount_in);
    (coin_out_val - (coin_out_val * (fee_bips as u64) / 10000))
    }
    // 0:"0x1::aptos_coin::AptosCoin"
    // 1:"0xf22bede237a07e121b56d91a491eb7bcdfd1f5907926a9e58338f964a01b17fa::asset::USDT"
    // 2:"0x190d44266241744264b964a37b8f09863167a12d3e70cda39376cfb4e3561e12::curves::Uncorrelated"
    //100000000 to 5659513 

    #[view]
    public fun get_amount_in_Uncorrelated_fee<X, Y>(amount_out: u64,fee_bips: u8): u64 {
    let value = router_v2::get_amount_in<X, Y, Uncorrelated>(amount_out);
    (value + (value * (fee_bips as u64) / 10000))// ex: 30 for 0.3%
    }

    #[view]
    public fun get_amount_out_Stable_fee<X, Y>(amount_in: u64,fee_bips: u8): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Stable>(amount_in);
    (coin_out_val - (coin_out_val * (fee_bips as u64) / 10000))
    }

    #[view]
    public fun get_amount_in_Stable_fee<X, Y>(amount_out: u64,fee_bips: u8): u64 {
    let value = router_v2::get_amount_in<X, Y, Stable>(amount_out);
    (value + (value * (fee_bips as u64) / 10000))// ex: 30 for 0.3%
    }
    
    #[view]
    public fun get_amount_out_cetus_without_fee<X, Y>(amount_a_in: u128): u128 {
        let (fee_numerator, fee_denominator) = amm_config::get_trade_fee<X, Y>();
        let (reserve_a, reserve_b) = amm_swap::get_reserves<X, Y>();
        amm_utils::get_amount_out(amount_a_in, (reserve_a as u128), (reserve_b as u128), fee_numerator, fee_denominator)
    }
    // 0:"0x1::aptos_coin::AptosCoin"
    // 1:"0xf22bede237a07e121b56d91a491eb7bcdfd1f5907926a9e58338f964a01b17fa::asset::USDT"
    //100000000 to 5865411 
    
    #[view]
    public fun get_amount_out_cetus_with_fee<X, Y>(amount_a_in: u128,fee_bips: u8): u128 {
        let (fee_numerator, fee_denominator) = amm_config::get_trade_fee<X, Y>();
        let (reserve_a, reserve_b) = amm_swap::get_reserves<X, Y>();
        let value = amm_utils::get_amount_out(amount_a_in, (reserve_a as u128), (reserve_b as u128), fee_numerator, fee_denominator);
        (value - (value * (fee_bips as u128) / 10000))// ex: 30 for 0.3%
    }
    // 0:"0x1::aptos_coin::AptosCoin"
    // 1:"0xf22bede237a07e121b56d91a491eb7bcdfd1f5907926a9e58338f964a01b17fa::asset::USDT"
    //100000000 to 5865411 
    
    #[view]
    public fun get_amount_in_cetus_without_fee<X, Y>(amount_b_out: u128): u128 {
        let (fee_numerator, fee_denominator) = amm_config::get_trade_fee<X, Y>();
        let (reserve_a, reserve_b) = amm_swap::get_reserves<X, Y>();
        amm_utils::get_amount_in(amount_b_out, (reserve_a as u128), (reserve_b as u128), fee_numerator, fee_denominator)
    }
    
    #[view]
    public fun get_amount_in_cetus_with_fee<X, Y>(amount_b_out: u128,fee_bips: u8): u128 {
        let (fee_numerator, fee_denominator) = amm_config::get_trade_fee<X, Y>();
        let (reserve_a, reserve_b) = amm_swap::get_reserves<X, Y>();
        let value = amm_utils::get_amount_in(amount_b_out, (reserve_a as u128), (reserve_b as u128), fee_numerator, fee_denominator);
        (value + (value * (fee_bips as u128) / 10000))// ex: 30 for 0.3%
    }
    
    #[view]
    public fun get_amount_in_pancake_without_fee<X, Y>(amount_b_out: u64): u64 {
        let (rin, rout, _) = swap::token_reserves<X, Y>();
        let amount_in = swap_utils::get_amount_in(amount_b_out, rin, rout);
        (amount_in)
    }
    
    #[view]
    public fun get_amount_in_pancake_with_fee<X, Y>(amount_b_out: u64,fee_bips: u8): u64 {
        let (rin, rout, _) = swap::token_reserves<X, Y>();
        let amount_in = swap_utils::get_amount_in(amount_b_out, rin, rout);
        (amount_in + (amount_in * (fee_bips as u64) / 10000))// ex: 30 for 0.3%
    }
    
    #[view]
    public fun get_amount_out_pancake_without_fee<X, Y>(amount_b_in: u64): u64 {
        let (rin, rout, _) = swap::token_reserves<X, Y>();
        let amount_out = swap_utils::get_amount_out(amount_b_in, rin, rout);
        (amount_out)
    }
    
    #[view]
    public fun get_amount_out_pancake_with_fee<X, Y>(amount_b_in: u64,fee_bips: u8): u64 {
        let (rin, rout, _) = swap::token_reserves<X, Y>();
        let amount_out = swap_utils::get_amount_out(amount_b_in, rin, rout);
        (amount_out - (amount_out * (fee_bips as u64) / 10000))// ex: 30 for 0.3%
    }

}
