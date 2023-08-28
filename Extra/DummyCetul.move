module swap_account::AnimeLiquid{

    use liquidswap::router_v2;
    use liquidswap::curves::Uncorrelated;
    use liquidswap::curves::Stable;
    use cetus_amm::amm_config;
    use cetus_amm::amm_swap;
    use cetus_amm::amm_utils;

    public fun get_intermediate_output<X, Y, E>(
        _dex_type: u8,
        _x_in: coin::Coin<X>
    ): (Option<coin::Coin<X>>, coin::Coin<Y>){
        
        if (_dex_type == DEX_ANIMESWAP) {
            use SwapDeployer::AnimeSwapPoolV1;
            (option::none(), AnimeSwapPoolV1::swap_coins_for_coins(_x_in))
        }
        else if (_dex_type == DEX_PONTEM_STABLE) {
            use liquidswap::curves::Stable;
            use liquidswap::router;
            (option::none(), router::swap_exact_coin_for_coin<X, Y, Stable>(_x_in, 0))
        }
        else if (_dex_type == DEX_PONTEM_UNCORRELATED) {
            use liquidswap::curves::Uncorrelated;
            use liquidswap::router;
            (option::none(), router::swap_exact_coin_for_coin<X, Y, Uncorrelated>(_x_in, 0))
        }
        else if (_dex_type == DEX_CETUS){
            use cetus_amm::amm_router;
            let y_out = amm_router::swap<X, Y>(@swap_account, _x_in);
            (option::none(),y_out)
        }
        else {
            abort E_UNKNOWN_DEX
        }
    }

}
