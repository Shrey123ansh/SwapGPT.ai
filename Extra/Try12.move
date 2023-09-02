// // https://aptscan.ai/modules/0xbeaa9e5ef5bee0781476a4adf293aae7dc3a28e9bd79fda89fca7211fb94c80/aggregator    
// module swap_account::SwapGPTAggregator{

//     use aptos_framework::account;
//     use aptos_framework::coin;
//     use std::option;
//     use std::option::Option;
//     use std::signer;

// const DEX_HIPPO: u8 = 1;
//     const DEX_ECONIA: u8 = 2;
//     const DEX_PONTEM: u8 = 3;
//     const DEX_PONTEM_UNCORRELATED: u8 = 23;
//     const DEX_PONTEM_STABLE: u8 = 13;
//     const DEX_BASIQ: u8 = 4;
//     const DEX_DITTO: u8 = 5;
//     const DEX_TORTUGA: u8 = 6;
//     const DEX_APTOSWAP: u8 = 7;
//     const DEX_AUX: u8 = 8;
//     const DEX_ANIMESWAP: u8 = 9;
//     const DEX_CETUS: u8 = 10;
//     const DEX_PANCAKE: u8 = 11;
//     const DEX_OBRIC: u8 = 12;
//     const E_UNKNOWN_DEX: u64 = 404;
//     const E_OUTPUT_LESS_THAN_MINIMUM: u64 = 2;
//     const E_UNSUPPORTED_NUM_STEPS: u64 = 9;
//     const EINSUFFICIENT_BALANCE: u64 = 6;
//     const RECEIVER_NOT_REGISTERED_FOR_COIN: u64 = 10;
//     const YOU_ARE_NOT_OWNER: u64 = 11;
//     const E_OUTPUT_NOT_EQAULS_REQUEST: u64 = 12;



//     public fun swap_direct<
//         X, Y, Z, OutCoin, E1, E2, E3
//     >(
//         num_steps: u8,
//         first_dex_type: u8,
//         first_pool_type: u64,
//         first_is_x_to_y: bool, // first trade uses normal order
//         second_dex_type: u8,
//         second_pool_type: u64,
//         second_is_x_to_y: bool, // second trade uses normal order
//         third_dex_type: u8,
//         third_pool_type: u64,
//         third_is_x_to_y: bool, // second trade uses normal order
//         x_in: coin::Coin<X>
//     ):(Option<coin::Coin<X>>, Option<coin::Coin<Y>>, Option<coin::Coin<Z>>, coin::Coin<OutCoin>) {
//         if (num_steps == 1) {
//             let (coin_x_remain, coin_m) = get_intermediate_output<X, OutCoin, E1>(first_dex_type, first_pool_type, first_is_x_to_y, x_in);
//             (coin_x_remain, option::some(coin::zero<Y>()), option::some(coin::zero<Z>()), coin_m)
//         }
//         else if (num_steps == 2) {
//             let (coin_x_remain, coin_y) = get_intermediate_output<X, Y, E1>(first_dex_type, first_pool_type, first_is_x_to_y, x_in);
//             let (coin_y_remain, coin_m) = get_intermediate_output<Y, OutCoin, E2>(second_dex_type, second_pool_type, second_is_x_to_y, coin_y);
//             (coin_x_remain, coin_y_remain, option::some(coin::zero<Z>()), coin_m)
//         }
//         else if (num_steps == 3) {
//             let (coin_x_remain, coin_y) = get_intermediate_output<X, Y, E1>(first_dex_type, first_pool_type, first_is_x_to_y, x_in);
//             let (coin_y_remain, coin_z) = get_intermediate_output<Y, Z, E2>(second_dex_type, second_pool_type, second_is_x_to_y, coin_y);
//             let (coin_z_remain, coin_m) = get_intermediate_output<Z, OutCoin, E3>(third_dex_type, third_pool_type, third_is_x_to_y, coin_z);
//             (coin_x_remain, coin_y_remain, coin_z_remain, coin_m)
//         }
//         else {
//             abort E_UNSUPPORTED_NUM_STEPS
//         }
//     }

//     public fun get_intermediate_output<X, Y, E>(
//         _dex_type: u8,
//         _pool_type: u64,
//         _is_x_to_y: bool,
//         _x_in: coin::Coin<X>
//     ): (Option<coin::Coin<X>>, coin::Coin<Y>){
        
//         if (_dex_type == DEX_ANIMESWAP) {
//             use SwapDeployer::AnimeSwapPoolV1;
//             (option::none(), AnimeSwapPoolV1::swap_coins_for_coins(_x_in))
//         }
//         else if (_dex_type == DEX_PONTEM_STABLE) {
//             use liquidswap::curves::Stable;
//             use liquidswap::router;
//             (option::none(), router::swap_exact_coin_for_coin<X, Y, Stable>(_x_in, 0))
//         }
//         else if (_dex_type == DEX_PONTEM_UNCORRELATED) {
//             use liquidswap::curves::Uncorrelated;
//             use liquidswap::router;
//             (option::none(), router::swap_exact_coin_for_coin<X, Y, Uncorrelated>(_x_in, 0))
//         }
//         else if (_dex_type == DEX_CETUS){
//             use cetus_amm::amm_router;
//             let y_out = amm_router::swap<X, Y>(@swap_account, _x_in);
//             (option::none(),y_out)
//         }
//         else {
//             abort E_UNKNOWN_DEX
//         }
//     }

//     fun check_and_deposit<X>(sender: &signer, coin: coin::Coin<X>) {
//         let sender_addr = signer::address_of(sender);
//         if (!coin::is_account_registered<X>(sender_addr)) {
//             coin::register<X>(sender);
//         };
//         coin::deposit(sender_addr, coin);
//     }

//     public entry fun one_step_route<X, Y, E>(
//         sender: &signer,
//         first_dex_type: u8,
//         first_pool_type: u64,
//         first_is_x_to_y: bool, // first trade uses normal order
//         x_in: u64,
//         y_min_out: u64,
//         fee_bips: u8

//     ) acquires ModuleData{
//         let coin_in = coin::withdraw<X>(sender, x_in);
//         let (coin_remain_opt, coin_out) = one_step_direct<X, Y, E>(first_dex_type, first_pool_type, first_is_x_to_y, coin_in);

//         process_fee(&mut coin_out, fee_bips);
//         assert!(coin::value(&coin_out) >= y_min_out, E_OUTPUT_LESS_THAN_MINIMUM);

//         add_process_fee(&mut coin_out,y_min_out);
//         // assert!(coin::value(&coin_out) >= y_min_out, E_OUTPUT_LESS_THAN_MINIMUM);

//         check_and_deposit_opt(sender, coin_remain_opt);
//         check_and_deposit(sender, coin_out);
//     }

//     public fun one_step_direct<X, Y, E>(
//         dex_type: u8,
//         pool_type: u64,
//         is_x_to_y: bool,
//         x_in: coin::Coin<X>
//     ):(Option<coin::Coin<X>>, coin::Coin<Y>) {
//         get_intermediate_output<X, Y, E>(dex_type, pool_type, is_x_to_y, x_in)
//     }

     
// }

