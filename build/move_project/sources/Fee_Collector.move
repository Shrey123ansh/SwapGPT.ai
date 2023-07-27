module swap_account::Fee_Collector{

    // use pancake::swap::router;
    use SwapDeployer::AnimeSwapPoolV1;
    use std::signer;
    

    public fun swap_x_to_y<X,Y>(
        sender:&signer,
        amount_in:u64,
        ){
        //swap X->Y
        let min_amount_out = 1;
        // router::swap_exact_input<X, Y>(sender,amount_in,min_amount_out);
        AnimeSwapPoolV1::swap_exact_coins_for_coins_entry<X, Y>(sender,amount_in,min_amount_out);
    }
 
}


