module swap_account::example{

    use std::vector;
    use std::string::{Self, String};
    use aptos_framework::coin;
    use std::signer;

    struct Module has key {
        list: vector<CoinType>
    }

    // public fun swap(sender: &signer, lists: vector<CoinType>) {
    //     let _sender_addr = signer::address_of(sender);
    //     let size:u64 = vector::length(&lists);
        
    //     // coin::deposit(sender_addr, coin);

    //     let i=0;
    //     while(i < size)
    //     {
    //         let to_String = *vector::borrow(& lists,(i as u64));
    //         // aptos_account::transfer(from,to_address,amount); 
    //         i=i+1;
    //     };    
    // }

}
