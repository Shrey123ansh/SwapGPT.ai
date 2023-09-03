module swap_account::AnimeSwapTest{

    use SwapDeployer::AnimeSwapPoolV1f1;
    use std::signer;
    use aptos_framework::coin;


    public entry fun swap<X,Y>(account: &signer,amount_in:u64) {
        let coin_in = coin::withdraw<X>(account, amount_in);

        let coin_out = AnimeSwapPoolV1f1::swap_coins_for_coins<X,Y>(
            coin_in
        );
        
        if (!coin::is_account_registered<Y>(signer::address_of(account))) {
            coin::register<Y>(account);
        };
        
        coin::deposit(signer::address_of(account), coin_out)
    }
}