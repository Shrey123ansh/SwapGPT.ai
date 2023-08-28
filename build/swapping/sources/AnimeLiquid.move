module swap_account::AnimeLiquid{

    use liquidswap::router_v2;
    use liquidswap::curves::Uncorrelated;
    use liquidswap::curves::Stable;

    #[view]
    public fun get_amount_out<X, Y>(amount_in: u64): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Uncorrelated>(amount_in);
    (coin_out_val)
    }

    #[view]
    public fun get_amount_in_<X, Y>(amount_out: u64): u64 {
    let value = router_v2::get_amount_in<X, Y, Uncorrelated>(amount_out);
    (value)// ex: 30 for 0.3%
    }

    #[view]
    public fun get_amount_out_Stable<X, Y>(amount_in: u64): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Stable>(amount_in);
    (coin_out_val)
    }

    #[view]
    public fun get_amount_in_Stable<X, Y>(amount_out: u64): u64 {
    let value = router_v2::get_amount_in<X, Y, Stable>(amount_out);
    (value)// ex: 30 for 0.3%
    }

    #[view]
    public fun get_amount_out_fee<X, Y>(amount_in: u64,fee_bips: u8): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Uncorrelated>(amount_in);
    (coin_out_val - (coin_out_val * (fee_bips as u64) / 10000))
    }

    #[view]
    public fun get_amount_in_fee<X, Y>(amount_out: u64,fee_bips: u8): u64 {
    let value = router_v2::get_amount_in<X, Y, Uncorrelated>(amount_out);
    (value + (value * (fee_bips as u64) / 10000))// ex: 30 for 0.3%
    }

    #[view]
    public fun get_amount_out_Stable_fee<X, Y, Curve>(amount_in: u64,fee_bips: u8): u64 {
    let coin_out_val = router_v2::get_amount_out<X, Y, Stable>(amount_in);
    (coin_out_val - (coin_out_val * (fee_bips as u64) / 10000))
    }

    #[view]
    public fun get_amount_in_Stable_fee<X, Y, Curve>(amount_out: u64,fee_bips: u8): u64 {
    let value = router_v2::get_amount_in<X, Y, Stable>(amount_out);
    (value + (value * (fee_bips as u64) / 10000))// ex: 30 for 0.3%
    }
}