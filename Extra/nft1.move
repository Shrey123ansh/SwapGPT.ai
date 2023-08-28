// module mint_nft::TokenV2RAF
// {
//     use std::signer;
//     use aptos_framework::object; 
//     use std::option; 
//     use aptos_token_objects::royalty;  
//     use aptos_token_objects::collection; 
//     use aptos_framework::object::ConstructorRef; 
//     use std::string::{String,Self};
//     use std::simple_map::{Self, SimpleMap};
//     use aptos_framework::account::SignerCapability;
//     use aptos_framework::resource_account;
//     use aptos_framework::account;
//     use aptos_token_objects::token::{Self, Token};

//     const E_ALREADY_MINTED: u64 =1;

//     struct ModuleData has key { 
//         signer_cap: SignerCapability,
//         candidates: SimpleMap<address, u64> 
//     }


//     public fun assert_not_contains_key(map: &SimpleMap<address, u64>, addr: &address) {
//         assert!(!simple_map::contains_key(map, addr), E_ALREADY_MINTED );
//     }

//     fun create_collection_helper(creator: &signer, collection_name: String, max_supply: u64) {
//         collection::create_fixed_collection(
//             creator,
//             string::utf8(b"collection description resource account"),
//             max_supply,
//             collection_name,
//             option::none(),
//             string::utf8(b"collection uri"),
//         );
//     }

//     fun create_token_helper(creator: &signer, collection_name: String, token_name: String): ConstructorRef {
//         token::create_from_account(
//             creator,
//             collection_name,
//             string::utf8(b"token description ra"),
//             token_name,
//             option::some(royalty::create(25, 10000, signer::address_of(creator))),
//             string::utf8(b"https://gateway.pinata.cloud/ipfs/QmRMc1Q81pugAzu59urEhkijxp79hkDtovwGFb6RbMN4wa"),
//         )
//     }



//     fun init_module(resource_signer: &signer) {
         
//         create_collection_helper(resource_signer, string::utf8(b"collectionsdf name"), 1000);
//         let resource_signer_cap = resource_account::retrieve_resource_account_cap(resource_signer, @source_addr);
 
//         move_to(resource_signer, ModuleData {
//             signer_cap: resource_signer_cap,
//             candidates: simple_map::create(),
//         });
//     } 


//     fun create_collection(creator: &signer)
//     {
//         create_collection_helper(creator, string::utf8(b"collectionsdf name"), 1000);
//     }

//     public entry fun create_token(to: &signer ) acquires ModuleData {
//         let module_data = borrow_global_mut<ModuleData>(@mint_nft);
//         assert_not_contains_key(&module_data.candidates, &signer::address_of(to));



//         let resource_signer = account::create_signer_with_capability(&module_data.signer_cap);
//         let token_name = string::utf8(b"token name");
//         let cr = create_token_helper(&resource_signer, string::utf8(b"collectionsdf name"), token_name);


//         // let creator_address = signer::address_of(&resource_signer);
//         // let token_addr = token::create_token_address(&creator_address, &string::utf8(b"collectionsdf name"), &token_name);
//         let token_addr = object::address_from_constructor_ref(&cr);
//         let token = object::address_to_object<Token>(token_addr); 
//         object::transfer(&resource_signer, token, signer::address_of(to) ); 

//         simple_map::add(&mut module_data.candidates, signer::address_of(to) , 1);
//     }
// } 

