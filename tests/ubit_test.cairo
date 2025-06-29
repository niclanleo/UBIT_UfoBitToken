// SPDX-License-Identifier: MIT
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address_global};
use starknet::{ContractAddress, contract_address_try_from_felt252};
use openzeppelin::token::erc20::interface::{
    IERC20Dispatcher, IERC20DispatcherTrait, IERC20MetadataDispatcher, IERC20MetadataDispatcherTrait
};
use core::result::ResultTrait;

#[test]
fn test_initial_supply() {
    let declared = declare("ubit").unwrap();
    let contract = declared.contract_class();
    let owner: ContractAddress = contract_address_try_from_felt252(0x123).unwrap();
    
    // 傳入 owner 地址作為 constructor 參數
    let (contract_address, _) = contract.deploy(@array![owner.into()]).unwrap();
    let dispatcher = IERC20Dispatcher { contract_address };
    
    let total_supply: u256 = 88888888_000000000000000000_u256;
    assert(dispatcher.total_supply() == total_supply, 'Invalid total supply');
    assert(dispatcher.balance_of(owner) == total_supply, 'Invalid owner balance');
}

#[test]
fn test_transfer() {
    let declared = declare("ubit").unwrap();
    let contract = declared.contract_class();
    let owner: ContractAddress = contract_address_try_from_felt252(0x123).unwrap();
    let recipient: ContractAddress = contract_address_try_from_felt252(0x456).unwrap();
    
    // 傳入 owner 地址作為 constructor 參數
    let (contract_address, _) = contract.deploy(@array![owner.into()]).unwrap();
    let dispatcher = IERC20Dispatcher { contract_address };
    
    start_cheat_caller_address_global(owner);
    let amount: u256 = 1000000_000000000000000000_u256;
    dispatcher.transfer(recipient, amount);
    
    assert(dispatcher.balance_of(recipient) == amount, 'Invalid recipient balance');
    assert(dispatcher.balance_of(owner) == 88888888_000000000000000000_u256 - amount, 'Invalid owner balance');
    assert(dispatcher.total_supply() == 88888888_000000000000000000_u256, 'Total supply changed');
}

#[test]
fn test_approve_and_transfer_from() {
    let declared = declare("ubit").unwrap();
    let contract = declared.contract_class();
    let owner: ContractAddress = contract_address_try_from_felt252(0x123).unwrap();
    let spender: ContractAddress = contract_address_try_from_felt252(0x456).unwrap();
    let recipient: ContractAddress = contract_address_try_from_felt252(0x789).unwrap();
    
    // 傳入 owner 地址作為 constructor 參數
    let (contract_address, _) = contract.deploy(@array![owner.into()]).unwrap();
    let dispatcher = IERC20Dispatcher { contract_address };
    
    start_cheat_caller_address_global(owner);
    let amount: u256 = 1000000_000000000000000000_u256;
    dispatcher.approve(spender, amount);
    assert(dispatcher.allowance(owner, spender) == amount, 'Invalid allowance');
    
    start_cheat_caller_address_global(spender);
    dispatcher.transfer_from(owner, recipient, amount);
    
    assert(dispatcher.balance_of(recipient) == amount, 'Invalid recipient balance');
    assert(dispatcher.balance_of(owner) == 88888888_000000000000000000_u256 - amount, 'Invalid owner balance');
    assert(dispatcher.allowance(owner, spender) == 0, 'Allowance not reset');
}

#[test]
#[should_panic(expected: ('ERC20: insufficient balance',))]
fn test_transfer_exceeds_balance() {
    let declared = declare("ubit").unwrap();
    let contract = declared.contract_class();
    let owner: ContractAddress = contract_address_try_from_felt252(0x123).unwrap();
    let recipient: ContractAddress = contract_address_try_from_felt252(0x456).unwrap();
    
    // 傳入 owner 地址作為 constructor 參數
    let (contract_address, _) = contract.deploy(@array![owner.into()]).unwrap();
    let dispatcher = IERC20Dispatcher { contract_address };
    
    start_cheat_caller_address_global(owner);
    let amount: u256 = 88888888_000000000000000000_u256 + 1;
    dispatcher.transfer(recipient, amount);
}

#[test]
fn test_metadata() {
    let declared = declare("ubit").unwrap();
    let contract = declared.contract_class();
    let owner: ContractAddress = contract_address_try_from_felt252(0x123).unwrap();
    
    // 傳入 owner 地址作為 constructor 參數
    let (contract_address, _) = contract.deploy(@array![owner.into()]).unwrap();
    let dispatcher = IERC20MetadataDispatcher { contract_address };
    
    assert(dispatcher.name() == "Ufo Bit Token", 'Invalid name');
    assert(dispatcher.symbol() == "UBIT", 'Invalid symbol');
    assert(dispatcher.decimals() == 18, 'Invalid decimals');
}